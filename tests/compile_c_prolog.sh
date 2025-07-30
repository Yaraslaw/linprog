PROLOG_DIR="./prolog_files"
minImpl="linprog_glpk_file"
libName="linprog"

SCRIPT_DIR="$(dirname "$0")"
cd $SCRIPT_DIR

cp ../src/$minImpl.c ./prolog_files/$minImpl.c
cp ../src/$libName.pl ./prolog_files/$libName.pl

cd prolog_files

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
