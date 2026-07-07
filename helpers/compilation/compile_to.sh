#!/usr/bin/env bash
# usage: ./compile_to <output-dir> <linprogq/linprogr>
# $2 by default is linprogq
set -e

INCLUDE_DIRS_GLPK="/usr/local/include /usr/include /opt/homebrew/include /opt/local/include /mingw64/include /msys64/mingw64/include"
LIB_DIRS_GLPK="/usr/local/lib /usr/lib /opt/homebrew/lib /opt/local/lib /mingw64/lib /msys64/mingw64/lib"

[ "$#" -eq 1 ] || [ "$#" -eq 2 ]|| { echo "Usage: $0 <output_directory>" >&2; exit 1; }

outdir=$1
minImpl="linprog_glpk_file"
libName="linprogq"

if [[ $2 == "linprogr" ]]; then
  libName="linprogr"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
cd "$SCRIPT_DIR"

mkdir -p "$outdir"
cp "../../src/$minImpl.c" "$outdir/$minImpl.c"
cp "../../src/$libName.pl" "$outdir/$libName.pl"

command -v swipl >/dev/null 2>&1 || { echo "swipl not found"; exit 1; }
eval "$(swipl --dump-runtime-variables)"

# Use ONLY what swipl gives us
SWI_INCLUDE="${PLINCDIR:-${PLBASE:+$PLBASE/include}}"
SWI_LIB="${PLLIBDIR:-}"
[ -n "$SWI_INCLUDE" ] || { echo "No SWI include from swipl (PLINCDIR/PLBASE)."; exit 1; }
[ -n "$SWI_LIB" ]     || { echo "No SWI lib dir from swipl (PLLIBDIR)."; exit 1; }

# Honor swipl's shared-object extension
SOEXT="${PLSOEXT:-${SOEXT:-}}"
# Use the fallback if PLSOEXT is defined but empty
if [ -z "$SOEXT" ]; then
  case "$(uname -s)" in
    Darwin) SOEXT="dylib" ;;
    MINGW*|MSYS*|CYGWIN*) SOEXT="dll" ;;
    *) SOEXT="so" ;;
  esac
fi

src="$outdir/$minImpl.c"
obj="$outdir/$minImpl.o"
outlib="$outdir/$minImpl.$SOEXT"

# Find GLPK (you can also set GLPK_INCLUDE/GLPK_LIB env vars)
if [ -z "${GLPK_INCLUDE:-}" ]; then
  for d in $INCLUDE_DIRS_GLPK; do
    [ -f "$d/glpk.h" ] && GLPK_INCLUDE="$d" && break
  done
fi
[ -n "${GLPK_INCLUDE:-}" ] || { echo "glpk.h not found. Set GLPK_INCLUDE=... or update the list of directories to search INCLUDE_DIRS_GLPK=.. and LIB_DIRS_GLPK=.."; exit 1; }

if [ -z "${GLPK_LIB:-}" ]; then
  for d in $LIB_DIRS_GLPK; do
    # Look for the static library specifically
    [ -f "$d/libglpk.a" ] && GLPK_LIB="$d" && break
  done
fi
# GLPK_LIB optional; linker may find -lglpk via system paths.

echo "GLPK was found in $GLPK_INCLUDE and executable was found in $GLPK_LIB"

if [ -z "${CC:-}" ]; then
  if command -v gcc >/dev/null 2>&1; then CC=gcc
  elif command -v clang >/dev/null 2>&1; then CC=clang
  else CC=swipl-ld
  fi
fi

echo "Compiler used: $CC"
# Explicitly check for Windows-like systems
FPIC="-fPIC"
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) FPIC="" ;; # Position Independent Code not needed on Windows
esac

echo "Compiling..."
$CC -O2 $FPIC -I"$SWI_INCLUDE" -I"$GLPK_INCLUDE" -c "$src" -o "$obj"

echo "Linking -> $outlib"
case "$SOEXT" in
  dylib) $CC -dynamiclib -o "$outlib" "$obj" -L"$SWI_LIB" -lswipl ${GLPK_LIB:+-L"$GLPK_LIB"} -l:libglpk.a  ;;
  dll)   $CC -shared     -o "$outlib" "$obj" -L"$SWI_LIB" -lswipl ${GLPK_LIB:+-L"$GLPK_LIB"} -l:libglpk.a -static-libgcc ;;
  *)     $CC -shared     -o "$outlib" "$obj" -L"$SWI_LIB" -lswipl ${GLPK_LIB:+-L"$GLPK_LIB"} -lglpk ;;
esac

echo "✅ Built: $outlib"
echo "Also copied: $outdir/$libName.pl"