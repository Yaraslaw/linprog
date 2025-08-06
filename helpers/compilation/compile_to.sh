if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <output_directory>"
  exit 1
fi

outdir=$1
minImpl="linprog_glpk_file"
libName="linprog"

SCRIPT_DIR="$(dirname "$0")"
cd $SCRIPT_DIR
echo $SCRIPT_DIR
echo $outdir
echo "copying files to from $(pwd) to $outdir"
cp ../../src/$minImpl.c $outdir/$minImpl.c
cp ../../src/$libName.pl $outdir/$libName.pl


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

echo $SWI_INCLUDE
echo $SWI_LIB
echo $GLPK_INCLUDE
echo $GLPK_LIB


# Compile with detected paths
gcc -I "$SWI_INCLUDE" -I "$GLPK_INCLUDE" -fpic -c "$outdir/$minImpl.c" -o "$outdir/$minImpl.o"
if [ $? -ne 0 ]; then
  echo "Compilation failed."
  exit 1
fi

# Link with detected paths
gcc -shared -o "$outdir/$minImpl.so" "$outdir/$minImpl.o" -L"$GLPK_LIB" -lglpk -L"$SWI_LIB" -lswipl
if [ $? -ne 0 ]; then
  echo "Linking failed."
  exit 1
fi

echo "Compilation produced successfully."