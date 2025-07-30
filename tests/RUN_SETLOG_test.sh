#!/bin/bash
# RUN_SETLOG_test.sh <test_name> <extension> [linprog/clpq]

minImpl="linprog_glpk_file"
libName="linprog.pl"

SCRIPT_DIR="$(dirname "$0")"
cd $SCRIPT_DIR

# Check if the correct number of arguments are provided
show_usage() {
  echo "Usage 1: $0 <test_name> <extension>"
  echo "Usage 2: $0 <test_name> <extension> <linprog/clpq>"
}
if [ "$#" -ne 2 ]; then
  if [ "$#" -ne 3 ]; then
    show_usage
    exit 1
  fi
  if [ "$3" != "linprog" ] && [ "$3" != "clpq" ]; then
    show_usage
    exit 1
  fi
fi

TEST_NAME=$1
EXT=$2

# Compile the C implementation
sh ./compile_c_setlog.sh "${3:-linprog}"

# Define directories
TEST_DIR="./test_cases/test_$TEST_NAME"  # Adjust this if your tests are in a different folder
SETLOG_DIR="./setlog_files"
LOG_BASE_DIR="./logs"

# Create a unique log directory using the current timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_DIR="${LOG_BASE_DIR}/log_${TIMESTAMP}_$TEST_NAME"

# Create the log directory
mkdir -p $LOG_DIR


# Move all test files to the setlog_files directory
if [ -d "$TEST_DIR" ]; then

  for file in "$TEST_DIR"/e*.pl; do
    if [ -f "$file" ]; then
      newname="$EXT-$(basename "$file")"
      cp "$file" "$SETLOG_DIR/$newname"
    fi
  done

  cp $TEST_DIR/test.pl $SETLOG_DIR/ 2>/dev/null
  cp $TEST_DIR/expected.txt $SETLOG_DIR/ 2>/dev/null

  # Check if the files were moved successfully
  if [ $? -eq 0 ]; then
    echo "Test files moved to $SETLOG_DIR successfully."
  else
    echo "Failed to move some test files. Please check if the files exist."
  fi
else
  echo "Test directory $TEST_DIR does not exist."
  exit 1
fi

# Run the tests in the setlog_files directory
cd $SETLOG_DIR
./run_all.sh $EXT 

cd ..

# Move result files to the logs directory
# mv $SETLOG_DIR/t0*.$EXT $LOG_DIR/ 2>/dev/null
for f in "$SETLOG_DIR"/"$EXT"-e*."$EXT"; do
  n=$(basename "$f")                    # e.g. "linprog-e.linprog"
  cp "$f" "$LOG_DIR/${n#"$EXT"-}"   # strips "linprog-" → "e.linprog"
done
mv $SETLOG_DIR/results.txt $LOG_DIR/ 2>/dev/null

# Clean up the setlog_files directory
cd $SETLOG_DIR
./clean.sh $EXT

# Return to the original directory
cd ..

echo "Logs have been moved to $LOG_DIR"

cat $LOG_DIR/results.txt

pwd

