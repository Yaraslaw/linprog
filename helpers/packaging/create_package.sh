#!/usr/bin/env bash
set -euo pipefail

# --- locate project root ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# --- source files ---
SRC_PLQ="$PROJECT_ROOT/src/linprogq.pl"
SRC_PLR="$PROJECT_ROOT/src/linprogr.pl"
SRC_C="$PROJECT_ROOT/src/linprog_glpk_file.c"

# --- target pack directory ---
PKG_NAME="linprog"
PKG_VER="0.1.2"
PKG_DIR="$PROJECT_ROOT/package/$PKG_NAME"

# --- clean & create structure ---
rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR/prolog" "$PKG_DIR/foreign"

# --- copy sources ---
cp "$SRC_PLQ" "$PKG_DIR/prolog/"
cp "$SRC_PLR" "$PKG_DIR/prolog/"
cp "$SRC_C" "$PKG_DIR/foreign/"

# --- write pack metadata ---
cat > "$PKG_DIR/pack.pl" <<EOF
% pack metadata
name(${PKG_NAME}).
version('${PKG_VER}').
pack_version(2).
title('Linear Programming with GLPK').
author('Yaraslaw Akhramenka', 'yaroslav.akhramenko@gmail.com').
author('Alfredo Capozucca', 'alfredo.capozucca@uni.lu').
author('Maximiliano Cristiá', 'cristia@cifasis-conicet.gov.ar').
% license('BSD 2-Clause').
EOF

# --- write Makefile with SWI & GLPK detection + dummy check/install ---
cat > "$PKG_DIR/Makefile" <<'EOF'
# === SWI-Prolog dump runtime variables ===

PLBASE   := $(shell swipl --dump-runtime-variables | awk -F\" '/PLBASE=/{print $$2}')
PLLIBDIR := $(shell swipl --dump-runtime-variables | awk -F\" '/PLLIBDIR=/{print $$2}')
PLLIB    := $(shell swipl --dump-runtime-variables | awk -F\" '/PLLIB=/{print $$2}')

# === GLPK autodetect (env override supported) ===
INCLUDE_DIRS_GLPK ?= /mingw64/include /msys64/mingw64/include /usr/local/include /usr/include /opt/homebrew/include /opt/local/include /msys64/mingw64/include
LIB_DIRS_GLPK     ?= /mingw64/lib /msys64/mingw64/lib /usr/local/lib /usr/lib /opt/homebrew/lib /opt/local/lib 


# If GLPK_INCLUDE isn't provided, find the first dir that contains glpk.h
ifeq ($(strip $(GLPK_INCLUDE)),)
	GLPK_INCLUDE := $(shell \
		find $(INCLUDE_DIRS_GLPK) -name glpk.h 2>/dev/null | \
		head -1 | xargs dirname 2>/dev/null || echo "")
endif

# Error out if we still don't have the header
ifeq ($(strip $(GLPK_INCLUDE)),)
	$(error glpk.h not found. Set GLPK_INCLUDE=... or update INCLUDE_DIRS_GLPK/LIB_DIRS_GLPK.)
endif


# If GLPK_LIB isn't provided, find the first dir that contains the static library
ifeq ($(strip $(GLPK_LIB)),)
	GLPK_LIB := $(shell \
	find $(LIB_DIRS_GLPK) -name libglpk.a 2>/dev/null | \
	head -1 | xargs dirname 2>/dev/null || echo "")
endif
# (No hard error here to match your snippet; link may fail later if not found.)


# Explicitly check for Windows-like systems




# Path transform (Unix -> Windows)
ifneq (,$(filter MINGW% MSYS% CYGWIN%,$(shell uname -s)))
	FPIC = 

    PLBASE := $(shell cygpath -m "$(PLBASE)" 2>/dev/null || echo "$(PLBASE)")
	PLLIBDIR := $(shell cygpath -m "$(PLLIBDIR)" 2>/dev/null || echo "$(PLLIBDIR)")
	GLPK_INCLUDE := $(shell cygpath -m "$(GLPK_INCLUDE)" 2>/dev/null || echo "$(GLPK_INCLUDE)")
	GLPK_LIB := $(shell cygpath -m "$(GLPK_LIB)" 2>/dev/null || echo "$(GLPK_LIB)")

	# === SWI-Prolog include flags ===
	SWIPL_CFLAGS   := -I"$(PLBASE)/include"
	SWIPL_LDFLAGS  := -L"$(PLLIBDIR)" $(PLLIB)
	# Flags exposed to the rest of the Makefile
	GLPK_CFLAGS    ?= -I"$(GLPK_INCLUDE)"
	GLPK_LDFLAGS   ?= -L"$(GLPK_LIB)" -l:libglpk.a
	
	RUNTIME_LDLIBS ?= -static-libgcc -Wl,-Bstatic -lwinpthread -Wl,-Bdynamic
	NO_UNDEF       := -Wl,--no-undefined


else
	FPIC = -fPIC

	# === SWI-Prolog include flags ===
	SWIPL_CFLAGS   := -I"$(PLBASE)/include"
	SWIPL_LDFLAGS  := -L"$(PLLIBDIR)" $(PLLIB)

	# Flags exposed to the rest of the Makefile
	GLPK_CFLAGS ?= -I"$(GLPK_INCLUDE)"
	GLPK_LDFLAGS ?= $(if $(strip $(GLPK_LIB)),-L"$(GLPK_LIB)" ,)-lglpk

	RUNTIME_LDLIBS := 
	NO_UNDEF       := 

endif

# === build tools & names ===
SOEXT := $(shell swipl --dump-runtime-variables \
           | sed -n 's/.*PLSOEXT="\([^"]*\)".*/\1/p')
PLARCH        := $(shell swipl --arch)
MODULE_DIR    := lib/$(PLARCH)
MODULE        := $(MODULE_DIR)/linprog_glpk_file.$(SOEXT)
SRC           := foreign/linprog_glpk_file.c
OBJ           := foreign/linprog_glpk_file.o

# Pick gcc, then clang, else swipl-ld
COMPILER ?= $(shell command -v gcc || command -v clang || command -v swipl-ld)

# === targets ===
all: build

build: $(MODULE)
	@mkdir -p foreign

$(OBJ): $(SRC)
	cc $(SWIPL_CFLAGS) $(GLPK_CFLAGS) $(FPIC) -c "$<" -o "$@"

$(MODULE): $(OBJ)
	@echo $(COMPILER) -shared -o $@ $< $(GLPK_LDFLAGS) $(SWIPL_LDFLAGS)
	@[ -n "$(MODULE_DIR)" ] && mkdir -p -- "$(MODULE_DIR)"
	cc -shared -o "$@" "$<" $(GLPK_LDFLAGS) $(SWIPL_LDFLAGS) $(RUNTIME_LDFLAGS) $(NO_UNDEF)
	@echo "Copying module to prolog directory..."

# Dummy test target so make check won't fail
check:
	@echo "No tests to run for linprog."

# Dummy install target so make install (if invoked) is a no-op
install:
	@echo "Installing..."

clean:
	rm -f foreign/*.o $(MODULE) prolog/linprog_glpk_file.$(SOEXT)
	rm -rf $(MODULE_DIR)


distclean: clean

.PHONY: build check install clean distclean
EOF

echo "✔ SWI-Prolog pack created at $PKG_DIR"