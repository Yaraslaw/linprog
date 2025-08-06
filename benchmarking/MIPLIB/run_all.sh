#!/bin/bash

output_file="results.txt"
: > "$output_file"  # Truncate or create

printf "%-20s : %s\n" "Test name" "Result" >> "$output_file"
printf "%-20s : %s\n" "--------------------" "----------------" >> "$output_file"

for file in $(ls *.mps | sort); do
    if [ -f "$file" ]; then
        test_name="${file%.mps}"
        report_file="${test_name}.out"

        # Run glpsol with -o to write full report
        glpsol --freemps "$file" -o "$report_file" > /dev/null 2>&1

        # Extract the objective value
        if grep -q '^Objective:' "$report_file"; then
            result=$(awk '/^Objective:/ { print $4 }' "$report_file")
        else
            result="ERROR"
        fi

        # Append to results.txt with tabulated formatting
        printf "%-20s : %s\n" "$test_name" "$result" >> "$output_file"

        # Clean up
        rm -f "$report_file"
    fi
done

echo "All done. Results saved in $output_file"