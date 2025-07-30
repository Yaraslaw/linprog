minImpl="linprog_glpk_file"
libName="linprog.pl"

SCRIPT_DIR="$(dirname "$0")"
cd $SCRIPT_DIR


rm ./$minImpl.c
rm ./$minImpl.o
rm ./$minImpl.so
rm ./$libName
rm ./lux.pl
rm ./test.pl