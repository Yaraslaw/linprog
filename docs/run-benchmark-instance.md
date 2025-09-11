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

Step 1. Enter into SWI-Prolog environment.

```bash
$ swipl
```

Step 2. Load clpq library.

```prolog
?- consult(library(clpq)).
```

Step 3. Load instance.

```prolog
?- consult('./<path-to-instance>/<instance-name>.pl').
```

#### Using Linprog library


Step 1. Enter into SWI-Prolog environment.

```bash
$ swipl
```

Step 2. Load Linprog library.

```prolog
?- consult(linprog).
```

Step 3. Load instance.

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


```bash
$ ./run.sh <bechmark> <lib>
```

where
- `<bechmark>` := netlib | MIPLIB
- `<lib>` := linprog | clpq

**Output**

The results appear in a file named like: `results-<benchmark>-<lib>-<timestamp>.txt`.
