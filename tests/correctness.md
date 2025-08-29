# Correctness

<!-- /*
Move to benchmarking 
Remain only benchmarking. {First results, then how to reproduce them}
Move test results to tests 
Add links to images 
Correctness.md
benchmarking.md


Install dependencies |-> Virtual installation

Native installation -> Set up 


Assumption -> note
*/ -->

## Results structure

All results tables can be found [here](./tests-results/).\
Results as an image can be found [here](./graphs/). 

### Files name

Each run is described in its result name `<test-suite-name>-<lib-used>-<TL>-<ML>.txt`, where:
- `<test-suite-name>` - is a name of the test suit (`MIPLIB`/`netlib`).
- `<lib-used>` - is a library that was used (`glpk`/`linprog`/`clpq`).
- `<TL>` - time limit. If a library takes more than `<TL>`, it will be aborted.
- `<ML>` - memory limit. If a library takes more than `<ML>`, it will be aborted.

### Instancies


Automated test runners output CSV-like summaries with header:

    Experiment;time(s);expect;pass;short description

Example:

    t001.pl;0.003;success;OK;

> Automated runners classify correctness as: "was any solution found or not?" Thus some clp test cases (e.g. t066 - t070) are marked OK, even though they give incorrect answers using clpq. See [failing test cases](./../tests/test_cases/README.md#clpq-failing-test-cases).


## Scripts

### Converter
As clpq provides answers in `XrY` format, you may use `./converter.sh </path/to/results> </path/to/output>` to convert clpq results into decimal format.

### Generate charts
You can use `./generate-charts.sh <path-to-results-file>` to create an `svg` file with a chart representation of the data from indicated file.

>`<path-to-results-file>` must be named as it was mentioned in [Files name](#files-name).

>`<test-suite-name>-<lib-used>.svg` will appear inside `./graphs` directory.

### Generate comparison charts
Similar to [generate charts](#generate-charts), but instead of a single file it takes two files.

Usage: 

```bash
$ ./generate-comparison-charts.sh <path-to-file1> <path-to-file2>
```

where `<path-to-file1>` and `<path-to-file2>` are paths to result files. Created file will be in format `<test-suite-name1>-<lib-used1>-VS-<test-suite-name2>-<lib-used2>.svg`.

>Same as with [generate charts](#generate-charts), files must be named as mentioned in [Files name](#files-name).

>Data from `<file1>` will be on top of the data from `<file2>`.




<!-- # Comparison of clpq and linprog -->



## Runner for Prolog and {log} test suites

### Introduction

This folder contains runners designed to validate correctness. There are:

- Top-level runners you should use (`./RUN_*.sh`) for test suites in `test_cases`.
- Internal scripts used by the runners (in `prolog_files` and `setlog_files`).

Only use internal scripts if you want to simulate the process manually. For a single test, it is better to create a test suit with that single test and run it, rather than using internal scripts directly.

Inside `test_cases` folder you can find test suites. Each `test_*` directory includes test files and an `expected.txt` file with the reference outcomes. 

> See test cases [readme](./test_cases/README.md) for how to create your own suites and understand the difference between SWI-Prolog and **{log}** (setlog) suites.

### Automatic launch

#### Prolog tests

`./RUN_PROLOG_test.sh <test-group> <ext> [linprog/clpq]`
  Executes **Prolog** tests based on the specified test group and log extension.
  - `<test-group>` parameter refers to one of the existing test groups:
    - **clp**
    - **card**
    - **intervals**
    - **abz18**
    - Any other test suites you create ([see guidelines](./test_cases/README.md#test-suite-creation))
  
  - `<ext>` - extension that will be used for log files.
  - `[<linprog/clpq>]` - library that will be used. You can omit this parameter. By default `linprog` is used.

### Setlog tests

`./RUN_SETLOG_test.sh <test-group> <ext> [<linprog/clpq>]`
  Similar to `RUN_PROLOG_test.sh`, but this script is used for running **{log}** (setlog) tests.
