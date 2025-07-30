# clean.sh <preffix>


SCRIPT_DIR="$(dirname "$0")"
cd $SCRIPT_DIR

if [ -n "$1" ]; then
  for i in "${1}-e*"; do
    rm -f $i
  done
else 
  for i in "e*"; do
    rm -f $i
  done
fi

rm -f test.pl
rm -f *.so
rm -f expected.txt
rm -f setlog.pl
rm -f out.out
rm -f results_temp.txt
rm -f setlog*
rm -f ttf_sp.pl
rm -f size_solver.pl
rm -f linprog.pl