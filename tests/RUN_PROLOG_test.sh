#!/bin/bash
# usage: ./RUN_PROLOG <test-group> <ext> <linprogq|linprogr|clpq|clpr>

minImpl="linprog_glpk_file"
libName="linprogq" # by default linprogq

if [ "$3" == "linprogr" ]; then
  libName="linprogr"
fi

cd ./tests || true

# Check if the correct number of arguments are provided
show_usage() {
  echo "Usage 1: $0 <test_name> <extension>"
  echo "Usage 2: $0 <test_name> <extension> <linprogq/linprogr/clpq/clpr>"
}
if [ "$#" -ne 2 ]; then
  if [ "$#" -ne 3 ]; then
    show_usage
    exit 1
  fi
  if [ "$3" != "linprogq" ] && [ "$3" != "linprogr" ]&& [ "$3" != "clpq" ] && [ "$3" != "clpr" ]; then
    show_usage
    exit 1
  fi
fi

TEST_NAME=$1
EXT=$2

# Compile the C implementation
# bash ./compile_c_prolog.sh 
bash ../helpers/compilation/compile_to.sh ../../tests/prolog_files $libName

# Define directories
TEST_DIR="./test_cases/test_$TEST_NAME"  # Adjust this if your tests are in a different folder
PROLOG_DIR="./prolog_files"
LOG_BASE_DIR="./logs"

# Create a unique log directory using the current timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_DIR="${LOG_BASE_DIR}/log_${TIMESTAMP}_$TEST_NAME"

# Create the log directory
mkdir -p $LOG_DIR


# Move all test files to the setlog_files directory
if [ -d "$TEST_DIR" ]; then

  for file in "$TEST_DIR"/t0*.pl; do
    if [ -f "$file" ]; then
      newname="$EXT-$(basename "$file")"
      cp "$file" "$PROLOG_DIR/$newname"
    fi
  done

  # cp $TEST_DIR/test.pl $PROLOG_DIR/ 2>/dev/null # old version
  cp $TEST_DIR/expected.txt $PROLOG_DIR/ 2>/dev/null

  # Check if the files were moved successfully
  if [ $? -eq 0 ]; then
    echo "Test files moved to $PROLOG_DIR successfully."
  else
    echo "Failed to move some test files. Please check if the files exist."
  fi
else
  echo "Test directory $TEST_DIR does not exist."
  exit 1
fi


# Run the tests in the setlog_files directory
cd $PROLOG_DIR
bash ./run_all.sh $EXT "${3:-linprogq}"

cd ..

# Move result files to the logs directory
# mv $PROLOG_DIR/t0*.$EXT $LOG_DIR/ 2>/dev/null
for f in "$PROLOG_DIR"/"$EXT"-t0*."$EXT"; do
  n=$(basename "$f")                    # e.g. "linprog-t01.linprog"
  cp "$f" "$LOG_DIR/${n#"$EXT"-}"   # strips "linprog-" → "t01.linprog"
done

mv $PROLOG_DIR/results.txt $LOG_DIR/ 2>/dev/null

# Clean up the setlog_files directory
cd $PROLOG_DIR
bash ./clean.sh $EXT

# Return to the original directory
cd ..

echo "Logs have been moved to $LOG_DIR"

cat $LOG_DIR/results.txt

pwd

