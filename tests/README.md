# Test and Runner Suite for Prolog and {log} Implementations

## Introduction
This folder contains tests and runners designed to validate the correctness of the implementation. The provided scripts facilitate the compilation and execution of various test cases, ensuring the robustness of the codebase.

## Contents

### Compilation Scripts
- **`compile_c_prolog.sh` / `compile_c_setlog.sh`**:  
  These scripts compile the necessary components of the Prolog and {log} implementations. The compilation process outputs two key files in the current directory:
  - `clpq.pl` - Contains the Prolog part of the code.
  - `minimize_glpk_str.so` - Contains the C part of the code.

### Test Runner Scripts
- **`RUN_PROLOG_test.sh <test-group> <ext>`**:  
  Executes Prolog tests based on the specified test group and log extension. The `<test-group>` parameter refers to one of the existing test groups:
  - **clpq**
  - **card**
  - **intervals**

  You can add new test groups by creating a folder named `test_<test-group>` inside the `test_cases` directory. The `<ext>` parameter specifies the log file extension. This script compiles the tests using `./compile_c_prolog.sh`, runs the tests (starting with `t0`), and moves the results into the `logs` folder.

- **`RUN_SETLOG_test.sh <test-group> <ext>`**:  
  Similar to `RUN_PROLOG_test.sh`, but this script is used for running {log} tests (tests starting with `e`). 

### Directories
- **`prolog_files`**:  
  Contains scripts that execute Prolog tests.

- **`setlog_files`**:  
  Contains {log} files and scripts that execute {log} tests.

## Usage
1. **Run tests** using `RUN_PROLOG_test.sh` or `RUN_SETLOG_test.sh` with the appropriate parameters:
   ```bash
   ./RUN_PROLOG_test.sh clpq log
   ``` 
   Replace `<test-group>` with the desired test group and `<ext>` with your preferred log file extension.
---
**_NOTE:_** 

You may add new test groups by creating a directory `test_<test-group>` under `test_cases` if necessary.
