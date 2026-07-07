#!/bin/bash
# run.sh — run all tests in a given test suit with a given library.

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <tests_folder> <library(glpk|linprogq|linprogr|clpq|clpr)>"
    exit 1
fi

tests_folder="$1"
library="$2"

if [[ ! -d "$tests_folder" ]]; then
    echo "Tests folder '$tests_folder' does not exist."
    exit 1
fi

case "$library" in
    glpk|linprogq|linprogr|clpq|clpr)
        echo "Running tests from folder '$tests_folder' using library '$library'..."
        ;;
    *)
        echo "Unknown library: $library. Use 'glpk', 'linprogq', 'linprogr', 'clpq' or 'clpr'."
        exit 1
        ;;
esac

cd "$tests_folder" || exit 1

# Compiling linprog if needed
if [[ $library == "linprogq"  || $library == "linprogr" ]]; then
    bash ./../../helpers/compilation/compile_to.sh ./../../benchmarking/"$tests_folder" $library
fi


# Spinner 
spinner() {
    local pid=$1
    local delay=0.1
    local spin_chars='|/-\'
    local i=0

    # Save current cursor position 
    tput sc

    while kill -0 $pid 2>/dev/null; do
        # Restore and move to right corner
        tput rc
        tput cuf $(($(tput cols) -1))
        printf "%s" "${spin_chars:i++%4:1}"
        sleep $delay 
    done

    # Clear spinner after done 
    tput rc 
    tput el
}




tmp_test="test.pl"


output_file="./../results-${tests_folder}-${library}-$(date +%Y%m%d-%H%M%S).txt"
: > "$output_file"

# Header
printf "%-20s : %-20s : %s\n" "Test name" "Result" "Time (s)" >> "$output_file"
printf "%-20s : %-20s : %s\n" "--------------------" "--------------------" "--------" >> "$output_file"

IFS=$'\n'  # Set IFS to newline to handle filenames with spaces correctly
# Sort .pl files by line count (ascending)
if [[ $library == "glpk" ]]; then
    # For GLPK, we only need the .mps files
    # go through all .mps files, sort by line count
    sorted_files=($(wc -l *.mps | sort -n | awk '{print $2}'))

else
    # For other libraries, we use .pl files
    # go through all .pl files, sort by line count
    sorted_files=($(wc -l *.pl | sort -n | awk '{print $2}'))
fi
unset IFS  # Reset IFS to default

for file in "${sorted_files[@]}"; do
    if [[ -f "$file" && $file != "linprogq.pl" && $file != "linprogr.pl" && $file != "$tmp_test" ]]; then

        test_name="${file%.pl}"

        # Create new test.pl 
        rm -f "$tmp_test"

        if [[ $library == "clpq" ]]; then
            echo "use_module(library(clpq))." >> "$tmp_test"
        elif [[ $library == "clpr" ]]; then
            echo "use_module(library(clpr))." >> "$tmp_test"
        elif [[ $library == "linprogq" ]]; then
            echo "use_module(library(linprogq))." >> "$tmp_test"
        elif [[ $library == "linprogr" ]]; then
            echo "use_module(library(linprogr))." >> "$tmp_test"
        fi
        if [[ $library != "glpk" ]]; then
            echo "set_prolog_flag(stack_limit, 50_000_000_000)." >> "$tmp_test"
            echo "consult('$file')." >> "$tmp_test"
        fi
        

        # Logs
        echo "Processing $file"

        # Measure time 
        start=$(date +%s.%N)



        # {
        if [[ $library == "glpk" ]]; then
            timeout --foreground --kill-after=1s 3000s glpsol --freemps "$file" -o "$tmp_test" > /dev/null 2>&1
            result=$(awk '
            # Capture Objective value
            /^Objective:/ {
                # print $0
                for (i=1; i<=NF; i++) {
                    if ($i == "=") {
                        print $(i+1)
                        found = 1
                    }
                }
            }
            END {
                if (!found) {
                    print "ERROR"
                }
            }
            ' "$tmp_test")
        else 
            result=$(
                timeout --foreground --kill-after=1s 3000s swipl -q < "$tmp_test" 2>&1 | \
                awk '
                    # Track whether any “%…” lines ever appeared
                    /^%/ { has_percent = 1; next }

                    # Memory Limit? 
                    /Stack limit/ { ml = 1 }

                    # Did the goal fail?
                    /failed/ { failed = 1 }

                    # Capture the last numeric line
                    /[0-9]/ { last = $0 }

                    END {
                    if (ml) {
                         # fallback
                        print "Memory Limit"
                    }
                    else if (!has_percent) {
                        # no “%…” means SWI never actually ran ⇒ we presume a timeout
                        print "TIMEOUT"
                    }
                    else  if (failed) {
                        # explicit Prolog failure
                        print "false"
                    }
                    else if (last) {
                        # otherwise, print the last numeric result
                        print last
                    }
                    else {
                        # fallback
                        print "ERROR"
                    }
                    }
                '
            )
        fi
        # } & 
        # pid=$!

        # Show spinner while it's running 
        # spinner $pid

        # Wait for process to complete (just in case)
        # wait $pid

        # Capture end time 
        end=$(date +%s.%N)

        # Calculate elapsed time (in second, 3 decimals) 
        elapsed=$(awk "BEGIN {print sprintf(\"%.3f\", $end - $start)}")

        # Write results 
        printf "%-20s : %-20s : %s\n" "$test_name" "$result" "$elapsed" >> "$output_file"

        # Clean up
        rm -f "$tmp_test"
    fi
done 

echo "All done. Results in $output_file"

# Cleanup linprog files
rm -f ./linprogq.pl
rm -f ./linprogr.pl
rm -f ./linprog_glpk_file.c
rm -f ./linprog_clpq_file.o
rm -f ./linprog_clpq_file.*