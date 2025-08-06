#!/bin/bash
# run <test_name> <extension> [<linprog/clpq>]


libName="linprog.pl"

e="$1"
ext="${2:-out}"
output_file="${e%pl}$ext"

> test.pl

if [ -z "$3" ] || [ $3 == "linprog" ]; then
  echo "consult('./$libName')." >> test.pl
else
  echo "consult(library(clpq))." >> test.pl
fi

echo "time(once(" >> test.pl
cat "$e" >> test.pl
echo "))." >> test.pl
# > test.pl
# echo "consult('./../$libName')." >> test.pl
# # echo "consult(library(clpq))." >> test.pl
# echo "time(once(" >> test.pl
# cat "$e" >> test.pl
# echo "))." >> test.pl

# here is a timeout one more time, because C-programs can't be interapted by prolog timeout
timeout --foreground --kill-after=1s 20s swipl -q < test.pl 2>&1 | grep -v "Use ?- setlog" | grep -v "^true.$" | grep -v "^$" > out.out

time=$(grep "^%" out.out | sed -e 's/^.*in //' -e 's/ seconds.*$//')



# # Check if the output file contains "ERROR"
# if grep -q "ERROR" out.out; then
#   result="ERROR"
#   short_description=$(grep "ERROR" out.out | tail -n 1)
# else
  # Set default time to 0 if not found
  result=""
  if [ -z "$time" ]; then
    time="0"
  fi
  # Check if __R was not found, indicating a time limit (TL) result
  if [[ "$time" == 0 ]]; then
    result="timeout"
    # If the result is timeout or BAD, capture the last line of the output as a description
  elif [[ $result == "BAD" ]]; then
    short_description=$(tail -n 1 out.out)
  elif grep -q "Warning" out.out; then
    short_description=$(grep "Warning" out.out | tail -n 1)
  elif grep -q "ERROR" out.out; then
    short_description=$(grep "ERROR" out.out | tail -n 1)
    result="ERROR"
  elif grep -q "false" out.out; then
    result="failure"
  else
    result="success"
  fi
# fi

echo "${e#"$ext"-};$time;$result;$short_description" >> results_temp.txt
mv out.out $output_file

