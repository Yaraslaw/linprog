#!/bin/bash
#----------------------------------------------#
#----------------- Validation -----------------#
#----------------------------------------------#
# Define the logs directory
LOGS_DIR="logs/"

# Check if logs directory exists
if [ ! -d "$LOGS_DIR" ]; then
  echo "Logs directory does not exist."
  exit 1
fi

# Check for expected files
if ls $LOGS_DIR/log*/*.txt 1> /dev/null 2>&1; then
  echo "Found results files in the logs directory."
else
  echo "No results files found in the logs directory."
  exit 1
fi

#----------------------------------------------#
#--------------- Process Files ----------------#
#----------------------------------------------#

TOTAL_TIME=0
TOTAL_TESTS=0
TOTAL_PASSED=0
TOTAL_FILES=0
TOTAL_FULL_PASSED=0
TOTAL_DID_NOT_PASS=""
TOTAL_TEST_SUITS_TEST_CASES=0
TOTAL_TEST_SUITS_TEST_CASES_PASS=0
# Function to wrap text to a specific width
wrap_text() {
  local text="$1"
  local width="$2"
  echo "$text" | fold -sw "$width" | sed '2,$s/^/|                      |               |                                    | /'
}

# Create the header of the markdown file


#if [ "$2" = "TS" ] || [ "$2" = "CS" ]; then
#  head -n 1 "../setlog.pl" > results${1}.md
#fi
#
#if [ "$2" = "VC" ]; then
#  head -n 1 "../setlog_vcg.pl" > results${1}.md
#fi

echo '+----------------------+---------------+------------------------------------+------------------------------------+' >> results${1}.md

if [ "$2" = "TS" ]; then
  echo '| Test suit            | Time (s)      | Passed (%)                         | Did not pass                       |' >> results${1}.md
fi

if [ "$2" = "VC" ] || [ "$2" = "CS" ]; then
  echo '| Case study           | Time (s)      | Passed (%)                         | Did not pass                       |' >> results${1}.md
fi

echo '+----------------------+---------------+------------------------------------+------------------------------------+' >> results${1}.md

# Process each results file
for FILE in $LOGS_DIR/log*/results*.txt; do
  TEST_NAME=$(basename "$FILE" .txt | sed 's/results_//')

  # Extract the total line
  TOTAL_LINE=$(grep "Total:" "$FILE")

  # Extract values
  TIME_TAKEN=$(echo "$TOTAL_LINE" | grep -oP 'Total time taken: \K[0-9]+')
  TOTAL_TESTS_CURRENT=$(echo "$TOTAL_LINE" | grep -oP 'Total: \K[0-9]+')
  PASSED_TESTS=$(echo "$TOTAL_LINE" | grep -oP 'Total: [0-9]+/\K[0-9]+')
  PASSED_PERCENT=$(echo "$TOTAL_LINE" | grep -oP '\K[0-9]+(?=%)')

  # Calculate not passed tests
  NOT_PASSED_TESTS=$(grep ";BAD" "$FILE" | awk -F';' '{print $1}' | tr '\n' ' ' | sed 's/ $//')

  if [ -z "$NOT_PASSED_TESTS" ]; then
    NOT_PASSED_TESTS="-/-"
  fi

  # Wrap the "Did not pass" text
  WRAPPED_NOT_PASSED=$(wrap_text "$NOT_PASSED_TESTS" 32)

  # Format passed percentage with details
  PASSED_FORMAT="${PASSED_PERCENT}% (${TOTAL_TESTS_CURRENT}/${PASSED_TESTS})"
  if [ "$PASSED_PERCENT" -eq 100 ]; then
    PASSED_FORMAT="$PASSED_FORMAT YES"
    TOTAL_FULL_PASSED=$((TOTAL_FULL_PASSED + 1))
  else
    PASSED_FORMAT="$PASSED_FORMAT NO"
  fi

  # Append data to the markdown file
  printf "| %-20s | %-13s | %-34s | %-34s |\n" "$TEST_NAME" "$TIME_TAKEN" "$PASSED_FORMAT" "$WRAPPED_NOT_PASSED" >> results${1}.md
echo '+----------------------+---------------+------------------------------------+------------------------------------+' >> results${1}.md

  # Accumulate totals
  TOTAL_TIME=$((TOTAL_TIME + TIME_TAKEN))
  TOTAL_TESTS=$((TOTAL_TESTS + TOTAL_TESTS_CURRENT))
  TOTAL_PASSED=$((TOTAL_PASSED + PASSED_TESTS))
  TOTAL_FILES=$((TOTAL_FILES + 1))
  TOTAL_TEST_SUITS_TEST_CASES=$((TOTAL_TEST_SUITS_TEST_CASES + PASSED_TESTS))
  TOTAL_TEST_SUITS_TEST_CASES_PASS=$((TOTAL_TEST_SUITS_TEST_CASES_PASS + TOTAL_TESTS_CURRENT))
done

  if [ $TOTAL_FULL_PASSED -eq $TOTAL_FILES ]; then
    TOTAL_DID_NOT_PASS="ALL PASS"
  else
    TOTAL_DID_NOT_PASS="DID NOT PASS"
  fi

if [ $TOTAL_FILES -gt 0 ]; then
  TOTAL_PASS_PERCENT=$(echo "scale=0; 100 * $TOTAL_FULL_PASSED / $TOTAL_FILES" | bc)
  TOTAL_PASS_PERCENT_FULL=$(echo "scale=0; 100 * $TOTAL_TEST_SUITS_TEST_CASES_PASS / $TOTAL_TEST_SUITS_TEST_CASES" | bc)
else
  TOTAL_PASS_PERCENT=0
  TOTAL_PASS_PERCENT_FULL=0
fi

# Append the total summary to the markdown file
TOTAL_PASSED_FORMAT="${TOTAL_PASS_PERCENT}% (${TOTAL_FULL_PASSED}/${TOTAL_FILES}) | ${TOTAL_PASS_PERCENT_FULL}% (${TOTAL_TEST_SUITS_TEST_CASES_PASS}/${TOTAL_TEST_SUITS_TEST_CASES})"
printf "| %-20s | %-13s | %-34s | %-34s |\n" "TOTAL" "$TOTAL_TIME" "$TOTAL_PASSED_FORMAT" "$TOTAL_DID_NOT_PASS" >> results${1}.md
echo '+----------------------+---------------+------------------------------------+------------------------------------+' >> results${1}.md

echo "Markdown file results.md created successfully."
mv results${1}.md logs/

# Exit with status based on pass percentage
#if [ $(echo "$TOTAL_PASS_PERCENT < 100" | bc) -eq 1 ]; then
#  exit 1
#else
#  exit 0
#fi
