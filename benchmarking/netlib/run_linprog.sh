#!/bin/bash

output_file="results-linprog.txt"
: > "$output_file"  # Truncate or create

# Header
printf "%-20s : %-20s : %s\n" "Test name" "Result" "Time (s)" >> "$output_file"
printf "%-20s : %-20s : %s\n" "--------------------" "--------------------" "--------" >> "$output_file"

# Loop through sorted .pl files
for file in $(ls *.pl | sort); do
    if [ -f "$file" ]; then
        test_name="${file%.pl}"

        # Create test.pl using echo
        echo "consult(linprog)." > test.pl
        echo "consult('$file')." >> test.pl

        # Measure time and capture output
        start=$(date +%s.%N)
        result=$(swipl -q < test.pl 2>&1 | awk '!/^%/ && /[0-9]/ { last=$0 } END { if (last) print last; else print "ERROR" }')
        end=$(date +%s.%N)

        # Calculate elapsed time (in seconds, 3 decimals)
        elapsed=$(awk "BEGIN {print sprintf(\"%.3f\", $end - $start)}")

        # Write result
        printf "%-20s : %-20s : %s\n" "$test_name" "$result" "$elapsed" >> "$output_file"

        # Clean up
        rm -f test.pl
    fi
done

echo "All done. Results saved in $output_file"