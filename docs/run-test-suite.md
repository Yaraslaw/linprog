# Running test suites

We created two bash scripts to ease the execution of the provided test suites.
These scripts are:

- RUN_PROLOG_test.sh: meant to run a SWI-Prolog test suite
- RUN_SETLOG_test.sh: meant to run a *{log} test suite.

These scripts can be found in the folder `/test'.

**Good to know**

- Scripts were tested with the test suites located in `/test/test_cases`.
- Each test suite directory must include a file named `expected.txt`. This file specifies the expected outcome for every test case.
  - **Remark:** the expected outcome of a test case can be one of the following:
    - `success` (a solution exists for the LP problem described in the test case)  
    - `failure` (no solution exists)  
    - `timeout` (max execution allowed time is exceeded)

- These scripts rely on other scripts that can also be used to automate the execution of one or several test cases. Characteristics and usage of these [SWI-Prolog](./tests/prolog_files/README.md) and [{log}](./tests/setlog_files/README.md) scripts are duly documented.

**Script output**

- It creates the directory ``/logs/log_<TIMESTAMP>_<test-group>`` to store all output. Any generated files are saved in this directory. `<test-group>` corresponds to the used test suite.
- It generates a log file recording the outcome of each executed test case.
- It creates a CSV-like file named `results.txt` with header ``Experiment;time(s);expect;pass;short description``, where
  - Experiment: indicates the name of the executed test case
  - time(s): the time (in seconds) taken to execute by the test case
  - expect: has a copy of the value indicated in the ``expected.txt`` file for the test case
  - pass: contains OK if the outcome of the test case matches the expected value. Otherwise, BAD.
  - short description: exta notes related to the outcome of the test case.  

## Usage

### SWI-Prolog test suite

`./RUN_PROLOG_test.sh <test-group> <ext> [linprog/clpq]`

- Executes **SWI-Prolog** test cases from the `<test-group>` test suite. For the moment, the only available value for this parameter is **clp**.
- `<ext>` extension that will be used for log files.
- `[<linprog/clpq>]` library that will be used during the execution. When omitted, the default value is `linprog`.

**Example:**

The following example executes the **clp** test suite using the clpq library that comes along with SWI-Prolog. 

```bash
./RUN_PROLOG_test.sh clp log clpq
```
  

### *{log}* test suite

`./RUN_SETLOG_test.sh <test-group> <ext> [<linprog/clpq>]`

- Executes *{log}* test cases from the `<test-group>` test suite. For the moment, the only available values for this parameter are **card** and **intervals**.
- `<ext>` extension that will be used for log files.
- `[<linprog/clpq>]` library that will be used during the execution. When omitted, the default value is `linprog`.

**Example:**

The following example executes the **card** test suite using the Linprog library.

```bash
./RUN_SETLOG_test.sh card log 
```

## Results post-processing

We provide scripts to help process the results obtained after executing a test suite.

These scripts are located in the `/helpers/postprocessing/` folder.

### Decimal converter

The library clpq.pl represents decimal number with the format `XrY`.

Use
```bash
./converter.sh </path/to/results> </path/to/output>
```

to convert numbers from the clpq.pl representation to standard decimal format (i.e., using a dot as the decimal separator).

### Chart generator

Use
```bash
./generate-charts.sh <path-to-results-file>
```

to create an `svg` file with a chart representation of the data from indicated file.

The `svg` file is generated inside the directory `graphs/`.


### Comparison chart generator

It combines in a single chart the results of two different files. This should ease the comparison of results produced for similar executions using different libraries.

To use it, do:

```bash
./generate-comparison-charts.sh <path-to-file1> <path-to-file2>
```

where `<path-to-file1>` and `<path-to-file2>` are the paths to each result file.

The `svg` file is generated inside the directory `graphs/`.

Results from `<file1>` are placed on top of results from `<file2>`.
