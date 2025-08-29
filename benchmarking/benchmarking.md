# Benchmarks

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

All results tables can be found [here](./benchmarking-results/). \
Results in images can be found [here](./graphs/). 

### Files name

Each run is described in its result name `<test-suite-name>-<lib-used>-<TL>-<ML>.txt`, where:
- `<test-suite-name>` - is a name of the test suit (`MIPLIB`/`netlib`).
- `<lib-used>` - is a library that was used (`glpk`/`linprog`/`clpq`).
- `<TL>` - time limit. If a library takes more than `<TL>`, it will be aborted.
- `<ML>` - memory limit. If a library takes more than `<ML>`, it will be aborted.


### Instancies

Results are presented in a table with header:

    Test name            : Result               : Time (s)

Example:

    sc50b                : -70                  : 0.171

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

>Same as for [generate charts](#generate-charts), files must be named as mentioned in [Files name](#files-name).

>Data from `<file1>` will be on top of the data from `<file2>`.



<!-- # Comparison of clpq and linprog -->



## Benchmarking reproduction

This section explains how to reproduce the benchmarking processes used to assess Linprog.

> Prerequisite: You must have the dependencies installed. See [software requirements](./../README.md#software-requirements).

The folder contains benchmark instances in two formats:
- `.mps` - original format for GLPK.
- `.pl` - Generated prolog instancies.

If you want to regenerate `.pl` files from `.mps`, see [use of transformer](./../helpers/transformer/README.md#usage).

### Instance execution

#### Automated

> Automated execution relies on **locally compiled** version of linprog (handled by `./run.sh`).
If any problems occur while running, benchmarks see the [compilation guide](./../README.md#alternative-local-compilation).

Run a benchmark suite:

```bash
$ ./run.sh <test-suite> <lib>
```

- `<test-suite>`
  - netlib
  - MIPLIB
  - Any other folder you create inside `benchmarking`. 
  > Enter only a single word, no slashes.
- `<lib>`
  - glpk
  - linprog
  - clpq

The result should appear in a file named like: `results-<test-suite>-<lib>-<timestamp>.txt`.

#### Manual

##### GLPK

To execute a single benchmark test case with GLPK use glpsol (built-in solver):

  ```bash 
  $ glpsol --freemps <test-name>
  ```

##### Linprog

To execute a single benchmark test case with linprog, first enter SWI-Prolog environment.

Then load a test case.

  ```prolog
  ?- consult('./<test-suite>/<test-name>').
  ```

##### SWI-Prolog clpq

As clpq is distributed with SWI-Prolog, you should enter SWI-Prolog environment.

```bash
$ swipl
```

Then, load clpq library and a test case.

```prolog
?- consult(library(clpq)).
?- consult('./<test-suite>/<test-name>').
```



**Remarks:**

> - It may be required to increase the GLPK timeout limit in linprog.
> - By default, this limit is set at 1000 seconds.
> - The predicate *set_time_limit* allows to change this limit (value is indicated in milliseconds).
> - Example to set the limit to 30 minutes: ``?- set_time_limit(1_800_000).``
