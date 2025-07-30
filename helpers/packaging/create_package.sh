#!/usr/bin/env bash
set -euo pipefail

# --- locate project root ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# --- source files ---
SRC_PL="$PROJECT_ROOT/src/linprog.pl"
SRC_C="$PROJECT_ROOT/src/linprog_glpk_file.c"

# --- target pack directory ---
PKG_NAME="linprog"
PKG_VER="0.1.0"
PKG_DIR="$PROJECT_ROOT/package/$PKG_NAME"

# --- clean & create structure ---
rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR/prolog" "$PKG_DIR/foreign"

# --- copy sources ---
cp "$SRC_PL" "$PKG_DIR/prolog/"
cp "$SRC_C" "$PKG_DIR/foreign/"

# --- write pack metadata ---
cat > "$PKG_DIR/pack.pl" <<EOF
% pack metadata
name(${PKG_NAME}).
version('${PKG_VER}').
pack_version(2).
EOF

# --- write Makefile with SWI & GLPK detection + dummy check/install ---
cat > "$PKG_DIR/Makefile" <<'EOF'
# === SWI-Prolog include flags ===
SWI_CFG_PKG   := $(shell pkg-config --cflags swipl 2>/dev/null)
SWI_CFG_LD    := $(shell pkg-config --libs   swipl 2>/dev/null)
SWI_INC_LD    := $(shell swipl --dump-runtime-variables \
                   2>/dev/null | sed -n 's/.*SWIPL_CFLAGS=\(.*\)/\1/p')
SWI_LD2       := $(shell swipl --dump-runtime-variables \
                   2>/dev/null | sed -n 's/.*SWIPL_CFLAGS=\(.*\)/\1/p')
SWI_FALLBACK  := -I/opt/local/lib/swipl/include -I/usr/local/include

SWIPL_CFLAGS  := $(or $(SWI_CFG_PKG),$(SWI_INC_LD),$(SWI_FALLBACK))
SWIPL_LDFLAGS := $(or $(SWI_CFG_LD),$(SWI_LD2))

# === GLPK flags via pkg-config or fallback ===
GLPK_CFLAGS   := $(shell pkg-config --cflags glpk 2>/dev/null || echo -I/usr/local/include)
GLPK_LIBS     := $(shell pkg-config --libs   glpk 2>/dev/null || echo -L/usr/local/lib -lglpk)

# === build tools & names ===
CC            := gcc
LD            := swipl-ld
SOEXT := $(shell swipl --dump-runtime-variables \
           | sed -n 's/.*PLSOEXT="\([^"]*\)".*/\1/p')
MODULE_DIR    := $(SWIPL_MODULE_DIR)
MODULE        := $(MODULE_DIR)/linprog_glpk_file.$(SOEXT)
SRC           := foreign/linprog_glpk_file.c
OBJ           := foreign/linprog_glpk_file.o

# === targets ===
all: $(MODULE)

foreign/linprog_glpk_file.o: $(SRC)
	@mkdir -p foreign
	$(CC) $(SWIPL_CFLAGS) $(GLPK_CFLAGS) -fpic -c "$<" -o "$@"

$(MODULE): $(OBJ)
	@mkdir -p $(MODULE_DIR)
	$(CC) -shared -o "$@" "$<" $(GLPK_LIBS) $(SWIPL_LDFLAGS)

# Dummy test target so `make check` won’t fail
check:
	@echo "No tests to run for linprog."

# Dummy install target so `make install` (if invoked) is a no-op
install:
	@echo "Copying module to prolog directory..."
	@cp "$(MODULE)" "prolog/linprog_glpk_file.$(SOEXT)"

clean:
	rm -f foreign/*.o $(MODULE) prolog/linprog_glpk_file.$(SOEXT)

distclean: clean

.PHONY: all check install clean distclean
EOF

echo "✔ SWI-Prolog pack created at $PKG_DIR"