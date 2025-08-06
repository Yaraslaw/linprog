#!/bin/bash
# run_all.sh <extension>

# Initialize temporary results file
> results_temp.txt

start_time=$SECONDS
ext="$1"

# Get total number of test cases
total_tests=$(ls "${ext}-e"*.pl | wc -l)
current_test=0

# Function to display progress bar
display_progress() {
  progress=$((($current_test * 100) / $total_tests))
  bar=""

  for ((x=0; x<$progress; x+=2)); do
    bar="${bar}#"
  done

  printf "\rProgress: [%-50s] %d%% (%d/%d)" "$bar" "$progress" "$current_test" "$total_tests"
}

# Run tests for all cases
for i in "${ext}-e"*.pl; do
  display_progress "$i"
  bash ./run.sh $i $1 
  current_test=$(($current_test + 1))
done

elapsed_time=$(($SECONDS - $start_time))

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
  exp=$(echo $line | cut -d';' -f1)
  time=$(echo $line | cut -d';' -f2)
  result=$(echo $line | cut -d';' -f3)
  short_description=$(echo $line | cut -d';' -f4)
  expected_result=$(grep "${exp%.*}:" expected.txt | cut -d: -f 2 | tr -d ' ')
  
  # OK meaning test is skipped due to noTL flag while TLing
  if [[ $result == $expected_result || $result == "OK" ]]; then
    pass="OK"
  elif [[ $result == "ERROR" ]]; then
    pass="ERROR"
  else
    pass="BAD"
  fi

  # Log to results.txt based on pass status
  # if [[ $pass == "BAD" ]]; then
    echo "$exp;$time;$expected_result;$pass;$short_description" >> results.txt
  # else
    # echo "$exp;$time;$expected_result;$pass;" >> results.txt
  # fi

  # Update counts based on expected result and pass status
  if [[ $expected_result == "success" ]]; then
    ((success_count++))
    [[ $pass == "OK" ]] && ((success_passed++))
  elif [[ $expected_result == "failure" ]]; then
    ((failure_count++))
    [[ $pass == "OK" ]] && ((failure_passed++))
  elif [[ $expected_result == "time_out" ]]; then
    ((timeout_count++))
    [[ $pass == "OK" ]] && ((timeout_passed++))
  fi
done < results_temp.txt

# Summary of results
echo "" >> results.txt
echo "Success: $success_passed/$success_count" >> results.txt
echo "Failure: $failure_passed/$failure_count" >> results.txt
echo "Time_out: $timeout_passed/$timeout_count" >> results.txt
echo "" >> results.txt

total_passed=$((success_passed + failure_passed + timeout_passed))
total_tests=$((success_count + failure_count + timeout_count))

if [ $total_tests -ne 0 ]; then
  percent=$((total_passed * 100 / total_tests))
else
  percent=0
fi

echo "Total: $total_passed/$total_tests  $percent% | Total time taken: ${elapsed_time}s" >> results.txt

# Clean up temporary file
rm results_temp.txt
