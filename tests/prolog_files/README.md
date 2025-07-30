# Prolog Test Execution Scripts

## Introduction
This folder contains scripts designed to execute Prolog tests efficiently. These scripts facilitate the execution of individual tests or batches of tests, with the ability to log results and clean up temporary files generated during the process.

## Contents

### Scripts
- **`run.sh <test-name>.pl <ext>`**  
  This script runs a single Prolog test specified by `<test-name>.pl`. The execution results are logged in a file named `<test-name>.<ext>`. Additionally, it creates a temporary file `result_temp.txt` containing a description of the execution.

- **`run_all.sh <ext>`**  
  This script applies `run.sh` to all Prolog test files in the current directory that start with `t0`. The results of these executions are aggregated and stored in a single file named `result.txt`.
    - **Expected Output File**:

        If an expected.txt file is provided, it should contain expected answers for the tests, formatted as `<test-name>:<answer>`.
    - **Verification**: 
    
        After executing the tests, `run_all.sh` checks each test's output against the expected answers listed in `expected.txt`.

        - If the expected answer is found in the log, the property `pass` in the file `result.txt` is set to **OK**.
        
        - If the expected answer is not found, the property `pass` in the file `result.txt` is set to **BAD**.

- **`clean.sh`**  
  This script deletes all temporary and intermediate files generated during the execution of the above scripts, except for the final result files. Use this script to clean up the workspace and maintain only essential output.

## Usage

1. **Run a Single Test**
   ```bash
   ./run.sh <test-name>.pl <ext>
   ```
    Replace `<test-name>` with the name of the test you wish to execute and `<ext>` with the desired log file extension. This command will generate logs and a `result_temp.txt` file.

2. **Run All Tests**
    ```bash
    ./run_all.sh <ext>
    ```
    Replace `<ext>` with the desired log file extension. This command will run all test files starting with `t0` and store the results in `result.txt`.

3. Clean Up Temporary Files
    ```bash
    ./clean.sh
    ```
    Use this command to remove all temporary files created during the test executions, preserving only the main result files.