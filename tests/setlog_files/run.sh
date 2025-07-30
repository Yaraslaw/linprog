#!/bin/bash
# run_all.sh <extension>

libName="linprog.pl"

e=$1
ext=${2:-out}
output_file="${e%pl}$ext"
> test.pl
echo "consult('setlog.pl')." >> test.pl
echo "setlog(add_lib('setloglibIntervals.slog'))." >> test.pl
echo "set_prolog_flag(answer_write_options,[max_depth(0)])." >> test.pl
echo "set_prolog_flag(toplevel_print_options, [quoted(true), portray(true), spacing(next_argument)])." >> test.pl
echo "time(once(rsetlog(" >> test.pl
cat $e >> test.pl
# 5000 is a timeout in miliseconds, however it's not recommended to 
# put a number larger than 999999 due to undefinded behaviour 
# to run with "no limits", write 2147483646 as time limit
case $ext in
  fs) echo ",999999,__C,__R,[fix_size])))." >> test.pl ;;
  *)  echo ",47483646,__C,__R,[])))." >> test.pl ;;
esac
echo >> test.pl
echo >> test.pl


# here is a timeout one more time, because C-programs can't be interapted by prolog timeout
timeout --foreground 7000s swipl -q < test.pl 2>&1 | grep -v "Use ?- setlog" | grep -v "^true.$" | grep -v "^$" > out.out

time=$(grep "^%" out.out | sed -e 's/^.*in //' -e 's/ seconds.*$//')
result=$(grep "__R =" out.out | sed -e 's/__R = //' | tr -d ' .,')

if grep -q "ERROR" out.out; then
  result="ERROR"
fi


filename=$(basename "$e")
expected_line=$(grep "${filename#".pl"-}" expected.txt)
noTL_flag=$(echo "$expected_line" | grep -q "noTL" && echo true || echo false)

# # Check if the output file contains "ERROR"
# if grep -q "ERROR" out.out; then
#   result="ERROR"
#   short_description=$(grep "ERROR" out.out | tail -n 1)
# else
  # Set default time to 0 if not found
  if [ -z "$time" ]; then
    time="0"
  fi

  # Check if __R was not found, indicating a time limit (TL) result
  if [[ -z "$result" ]]; then
    result="timeout"
  fi

  # If the result is timeout and noTL flag is set, override the result to "OK"
  if [[ $result == "timeout" && $noTL_flag == true ]]; then
    result="OK"
  fi

  # If the result is timeout or BAD, capture the last line of the output as a description
  if [[ $result == "BAD" || $result == "timeout" ]]; then
    short_description=$(tail -n 1 out.out)
  fi
# fi

echo "${e#"$ext"-};$time;$result;$short_description" >> results_temp.txt
mv out.out $output_file

