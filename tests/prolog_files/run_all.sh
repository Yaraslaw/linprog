#!/bin/bash
# run_all.sh <extension> [<linprog/clpq>]

# Initialize temporary results file
> results_temp.txt

start_time=$SECONDS
ext="$1"

# Get total number of test cases
total_tests=$(ls "${ext}-t0"*.pl | wc -l)
echo "Total tests: $total_tests"
current_test=0

# Function to display progress bar
display_progress() {
  current_file="$1"
  progress=$(( ($current_test * 100) / $total_tests ))
  bar=""

  for ((i=0; i<$progress; i+=2)); do
    bar="${bar}#"
  done

  printf "\rProgress: [%-50s] %d%% (%d/%d) file : %s" "$bar" "$progress" "$current_test" "$total_tests" "$current_file"
}

# Run tests for all cases

for i in "${ext}-t0"*.pl; do
  num=$(echo "$i" | grep -o -E '[0-9]+' | sed 's/^0*//')
   
  if [[ $num -lt 1000 ]]; then
      # Pass file (i) and optional second arg ($1) to run.sh
      ./run.sh "$i" "$1" "$2"
  fi 
  current_test=$((current_test + 1))
  display_progress "$i"
done

elapsed_time=$((SECONDS - start_time))

echo ""

# Process the results
success_count=0
failure_count=0
timeout_count=0

success_passed=0
failure_passed=0
timeout_passed=0

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Experiment;time(s);expect;pass;short description" > results.txt

while IFS= read -r line; do
  exp=$(echo "$line" | cut -d';' -f1)
  time=$(echo "$line" | cut -d';' -f2)
  result=$(echo "$line" | cut -d';' -f3)
  short_description=$(echo "$line" | cut -d';' -f4)

  # Look up the expected result from expected.txt
  # e.g. if t037.pl => we look for "t037:" in expected.txt
  expected_result=$(grep "${exp%.*}:" expected.txt | cut -d: -f2 | tr -d ' ')

  # Compare actual result vs. expected
  if [[ "$result" == "$expected_result" ]]; then
    pass="OK"
  else
    pass="BAD"
  fi

  # Write to results.txt
  # The third column is "expect" = the expected_result from expected.txt
  if [[ "$pass" == "BAD" ]]; then
    echo "$exp;$time;$expected_result;$pass;$short_description" >> results.txt
  else
    echo "$exp;$time;$expected_result;$pass;" >> results.txt
  fi

  # Tally them by the *expected* category:
  case "$expected_result" in
    "success")
      ((success_count++))
      [[ "$pass" == "OK" ]] && ((success_passed++))
      ;;
    "failure")
      ((failure_count++))
      [[ "$pass" == "OK" ]] && ((failure_passed++))
      ;;
    "time_out")
      ((timeout_count++))
      [[ "$pass" == "OK" ]] && ((timeout_passed++))
      ;;
  esac

done < results_temp.txt

# Summary in results.txt
echo "" >> results.txt
echo "Success: $success_passed/$success_count" >> results.txt
echo "Failure: $failure_passed/$failure_count" >> results.txt
echo "Time_out: $timeout_passed/$timeout_count" >> results.txt
echo "" >> results.txt

total_passed=$(( success_passed + failure_passed + timeout_passed ))
total_tests=$(( success_count + failure_count + timeout_count ))

if [ $total_tests -ne 0 ]; then
  percent=$(( total_passed * 100 / total_tests ))
else
  percent=0
fi

echo "Total: $total_passed/$total_tests  $percent% | Total time taken: ${elapsed_time}s" >> results.txt

# Clean up temporary file
rm results_temp.txt