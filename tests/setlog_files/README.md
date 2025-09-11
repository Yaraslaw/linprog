# *{log}* test execution scripts

## Scripts
- `run.sh <test-name> <ext>`
  runs a single prepared test; logs to `<test-name>.<ext>` and writes `result_temp.txt`.

- `run_all.sh <ext>`
  Run all `e*.pl` tests; aggregates into `results.txt`
    - If an expected.txt file is provided, it should contain expected answers for the tests formatted like `<test-name>:<answer>`.
    - If the expected answer is the same as output of corresponded test case, `pass` becomes **OK**; otherwise **BAD**

- `clean.sh [<ext>]` remove generated files.

## Usage

1. Run a Single Test
   ```bash
   ./run.sh <test-name> <ext>
   ```

2. Run All Tests
    ```bash
    ./run_all.sh <ext>
    ```

3. Clean Up
    ```bash
    ./clean.sh [<ext>]
    ```
