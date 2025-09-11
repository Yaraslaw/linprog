# clean.sh <preffix>


SCRIPT_DIR="$(dirname "$0")"
cd $SCRIPT_DIR

if [ -n "$1" ]; then
  for i in "${1}-t0*"; do
    rm -f $i
  done
else 
  for i in "t0*"; do
    rm -f $i
  done
fi

rm -f test.pl
rm -f *.so
rm -f expected.txt
rm -f out.out
rm -f results_temp.txt
rm -f linprog_glpk_file.c
rm -f linprog_glpk_file.o
rm -f linprog_glpk_file.*
rm -f linprog.pl