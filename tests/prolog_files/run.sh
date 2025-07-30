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

timeout --foreground 60s swipl -q < test.pl 2>&1 \
  | grep -v "Use ?- setlog" \
  | grep -v "^true.$" \
  | grep -v "^$" \
  > out.out

ret=$?

inference_line=$(grep "^%" out.out)
time="0"

if [ -n "$inference_line" ]; then
  time=$(echo "$inference_line" | sed -e 's/^.*in //' -e 's/ seconds.*$//')
fi

if grep -q "ERROR" out.out; then
  inference_line="ERROR"
fi


if [ $ret -eq 124 ]; then
  result="time_out"
  short_description="Timeout after 5s"
elif [ -z "$inference_line" ] || [ "$inference_line" == "ERROR" ]; then
  result="ERROR"
  short_description="ERROR"
elif grep -q "^false.$" out.out; then
  result="failure"
  short_description=""
else
  result="success"
  short_description=""
fi

echo "${e#"$ext"-};$time;$result;$short_description" >> results_temp.txt
mv out.out "$output_file"