# SWI-Prolog test execution scripts

## Scripts
- `run.sh <test-name> <ext> <linprog|clpq>`
  Run a single prepared Prolog test specified by `<test-name>.pl`. The execution results are logged in a file named `<test-name>.<ext>`. Additionally, it creates a temporary file `result_temp.txt` containing a description of the execution.

- `run_all.sh <ext> [linprog|clpq]`
  Apply `run.sh` to all Prolog test files in the current directory that start with `{ext}-t0`. The results of these executions are stored in a file named `results.txt`.
    - Expected Output File:
        If an expected.txt file is provided, lines formatted as `<test-name>:<answer>` are used to check outputs.
    - Verification:

        After executing the tests, `run_all.sh` checks each test's output against the expected answers listed in `expected.txt`.

        - If the output answer is the same as expected the property `pass` is set to **OK**.
        
        - If the output answer differs from expected the property `pass` is set to **BAD**.

- `clean.sh [<ext>]` - remove generated files (omit `<ext>` to clean `t0*.pl` cases).


## Usage

1. Run a Single Test
   ```bash
   ./run.sh <test-name> <ext> [linprog|clpq]
   ```
    Replace `<test-name>` with the test name you want to execute and `<ext>` with the desired log file extension.

2. Run All Tests
    ```bash
    ./run_all.sh <ext>
    ```
    Replace `<ext>` with the desired log file extension. This command will run all test files starting with `t0` and store the results in `results.txt`.

3. Clean Up Temporary Files
    ```bash
    ./clean.sh [<ext>]
    ```
    Use this command to remove generated files (omit `<ext>` to clean `t0*.pl` cases as well).
