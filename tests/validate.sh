#!/bin/bash

# Set the maximum allowed duration for tests (in seconds)
MAX_DURATION=$((20 * 60))

# Check the duration of the tests
if [ "$SECONDS" -gt "$MAX_DURATION" ]; then
  echo "Test execution time exceeded the maximum allowed duration of 20 minutes."
  exit 1
fi

# Check each results.txt file in the logs directory
for result_file in tests/logs/log*/results.txt; do
  if grep -q "BAD" "$result_file"; then
    echo "A test has failed. Details can be found in $result_file."
    exit 1
  fi
done

echo "All tests passed successfully."
exit 0
