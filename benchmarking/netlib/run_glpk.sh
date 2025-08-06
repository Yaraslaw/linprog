#!/bin/bash

output_file="results-glpk.txt"
: > "$output_file"  # Truncate or create

# Header
printf "%-20s : %-20s : %s\n" "Test name" "Result" "Time (s)" >> "$output_file"
printf "%-20s : %-20s : %s\n" "--------------------" "--------------------" "--------" >> "$output_file"

# Loop through sorted .mps files
for file in $(ls *.mps | sort); do
    if [ -f "$file" ]; then
        test_name="${file%.mps}"

        # Create test.pl using echo
        # echo "consult(linprog)." > test.pl
        # echo "consult('$file')." >> test.pl

        report_file="$test_name.out"
        echo "Running GLPK on $file, output will be saved to $report_file"
        # Measure time and capture output
        start=$(date +%s.%N)
        glpsol --freemps "$file" -o "$report_file" > /dev/null 2>&1
        
        if grep -q '^Objective:' "$report_file"; then
            result=$(awk '/^Objective:/ { print $4 }' "$report_file")
        else
            result="ERROR"
        fi

        end=$(date +%s.%N)
        # Calculate elapsed time (in seconds, 3 decimals)
        elapsed=$(awk "BEGIN {print sprintf(\"%.3f\", $end - $start)}")

        # Write result
        echo "Test name: $test_name, Result: $result, Time: $elapsed seconds"
        printf "%-20s : %-20s : %s\n" "$test_name" "$result" "$elapsed" >> "$output_file"

        # Clean up
        rm -f "$report_file"
    fi
done

echo "All done. Results saved in $output_file"