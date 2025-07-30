#!/usr/bin/env bash

# compile_c_setlog.sh <linprog/clpq>


SETLOG_DIR="./setlog_files"
minImpl="linprog_glpk_file"
libName="linprog"

SCRIPT_DIR="$(dirname "$0")"
cd $SCRIPT_DIR

if [ "$1" == "linprog" ] || [ -z "$1" ]; then
  for f in ../setlog_files/setlog*; do
  case "${f##*/}" in
    setlog_clpq.pl|README.md) ;;        # skip
    setlog_linprog.pl) cp "$f" ./setlog_files/setlog.pl ;;  # copy linprog version
    *) cp "$f" ./setlog_files/ ;;        # copy everything else
  esac
done
else
  for f in ../setlog_files/setlog*; do
    case "${f##*/}" in
      setlog_linprog.pl|README.md) ;;        # skip
      setlog_clpq.pl) cp "$f" ./setlog_files/setlog.pl ;;  # copy clpq version
      *) cp "$f" ./setlog_files/ ;;        # copy everything else
    esac
  done
fi

cp ../setlog_files/ttf_sp.pl ./setlog_files/ttf_sp.pl
cp ../setlog_files/size_solver.pl ./setlog_files/size_solver.pl
cp ../src/$minImpl.c ./setlog_files/$minImpl.c
cp ../src/$libName.pl ./setlog_files/$libName.pl


cd setlog_files


# Detect SWI-Prolog home directory
SWIPL_HOME=$(swipl --home)

# Determine system architecture
ARCH_DIR=$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')

# Construct SWI-Prolog include and library paths
SWI_INCLUDE="$SWIPL_HOME/include"
SWI_LIB="$SWIPL_HOME/lib/$ARCH_DIR"

# Detect GLPK library path
GLPK_INCLUDE=$(find /usr/local/include -name "glpk.h" 2>/dev/null | head -n 1 | xargs dirname)
GLPK_LIB=$(find /usr/local/lib -name "libglpk.*" 2>/dev/null | head -n 1 | xargs dirname)

# Compile with detected paths
gcc -I "$SWI_INCLUDE" -I "$GLPK_INCLUDE" -fpic -c "$minImpl.c" -o "$minImpl.o"
if [ $? -ne 0 ]; then
  echo "Compilation failed."
  exit 1
fi

# Link with detected paths
gcc -shared -o "$minImpl.so" "$minImpl.o" -L"$GLPK_LIB" -lglpk -L"$SWI_LIB" -lswipl
if [ $? -ne 0 ]; then
  echo "Linking failed."
  exit 1
fi

rm $minImpl.c
rm $minImpl.o

echo "Compilation produced successfully."
