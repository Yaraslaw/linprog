# Running benchmark instances

This section explains how to execute a benchmarks' instances.

Its aim is to ease the reproduciability of the benchmarking process.  

## Prerequisites

- You must have the [required software](../README.md#requirements) installed.
- Use [Linprog Development release](../README.md#development-release).
- Install this release by [compiling Linprog](../README.md#compilation).

## Usage

**Good to know**

- An instance is considered to be in SWI-Prolog format and stored in a `.pl` file. 
- If you want/need to (re)generate a `.pl` file from a `.mps` file, [use the provided transformer](../helpers/transformer/README.md).


### Interactive manual mode

Execute an individual instance from within the SWI-Prolog environmet.

#### Using SWI-Prolog CLP(Q) library

1- Enter into SWI-Prolog environment.

```bash
$ swipl
```

2- Load clpq library.

```prolog
?- consult(library(clpq)).
```

3- Load instance.

```prolog
?- consult('./<path-to-instance>/<instance-name>.pl').
```

#### Using Linprog library

1- Enter into SWI-Prolog environment.

```bash
$ swipl
```

2- Load Linprog library.

```prolog
?- consult(linprog).
```

3- Load instance.

```prolog
?- consult('./<path-to-instance>/<instance-name>.pl').
```

**Remarks:**

- Linprog has a default execution time limit set at 1000 seconds.

- The predicate *set_time_limit* allows to change this time limit (value is indicated in milliseconds).
  - Example to set the limit to 30 minutes:

    ```prolog
    ?- set_time_limit(1_800_000).
    ```

### Batch mode

Execute all instances located into the `<benchmark>` folder using `<lib>` as library.

1- Go to the folder containing the script

```bash
$ cd benchmarking/
```

2- Run the script

```bash
$ ./run.sh <benchmark> <lib>
```

where
- `<benchmark>` := netlib | MIPLIB
- `<lib>` := linprog | clpq

**Output**

The results are stored in a file named: `results-<benchmark>-<lib>-<timestamp>.txt`.

This file is created in the same directory where the script was executed.

## Results post-processing

We provide scripts to help process the results obtained after executing the benchmarks

These scripts are located in the `/helpers/postprocessing/` folder.

### Decimal converter

The library clpq.pl represents decimal number with the format `XrY`.

Use
```bash
./converter.sh </path/to/result/file-orig> </path/to/output/file-new>
```

to convert numbers from the clpq.pl representation to standard decimal format (i.e., using a dot as the decimal separator).

### Chart generators

First, install [mermaid-cli](https://github.com/mermaid-js/mermaid-cli?tab=readme-ov-file).

Once done, you can use the provided scripts to generate charts.



#### Single bar chart

Use
```bash
./generate-charts.sh </path/to/result/file>
```

to create an `svg` file with a chart representation of the data from indicated file.

The `svg` file is generated inside the directory `graphs/`.

#### Comparison bar chart

It combines in a single chart the results of two different files. This should ease the comparison of results produced for similar executions using different libraries.

To use it, do:

```bash
./generate-comparison-charts.sh </path/to/file1> </path/to/file2>
```

where `</path/to/file1>` and `</path/to/file2>` correspond to each result file.

The `svg` file is generated inside the directory `/graphs`.

Results from `<file1>` are placed on top of results from `<file2>`.
