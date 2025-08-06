# Benchmark reproducibility 

These guidelines help you to reproduce the benchmarking processes used to assess Linprog.

## Solver setup

### GLPK

You should have already installed glpk [(as it's required to use Linprog)](./../README.md#software-requirements).
Thus, you should be ready to use this solver to execute an instance.

To confirm that you are all set, in a terminal execute:

``$ glpsol --version``

If you get as  outcome (something close) to what is shown below, there you are good to run an instance with the GLPK solver.  

```txt
GLPSOL--GLPK LP/MIP Solver 5.0
Copyright (C) 2000-2020 Free Software Foundation, Inc.

This program has ABSOLUTELY NO WARRANTY.

This program is free software; you may re-distribute it under the terms
of the GNU General Public License version 3 or later.
```

### SWI-Prolog clpq

This solver operates withing SWI-Prolog. Thus, the only requirement to use it is to have installed SWI-Prolog. The clpq library comes along with the standard distribution of SWI-Prolog, so once it is installed, you should:

1-Start prolog

``$ swipl``

2-Load the library

``$ consult(library(clpq)).``

Now, you are ready to run an instance. See next section.

### Linprog

It is assumed that you have already installed all required software to use the Linprog library (otherwise see [Software requirements](../README.md)).
If you have linprog already installed, you should:

1-Start prolog

``$ swipl``

2-Load the library

``$ use_module(library(linprog)).``

Otherwise: you need to either install linprog [?see installation section?](./../README.md#????) or compile linprog by yourself [?see compilation section?](./../README.md#compilation).

Now, you are ready to run an instance. See next section.

**Remarks:**

> - It may be required to increase the GLPK timeout limit.
> - By default, this limit is set at 5 minutes.
> - The predicate *set_time* allows to change this limit (value is indicated in milliseconds).
> - Example to set the limit to 30 minutes: ``?- set_time_limit(1_800_000).``

## Instance execution

Inside folders you can find each test case in both `.mps` and `.pl` formats. \
`.mps` - original format, used by glpk. \
`.pl` - semantically the same test case translated from `.mps` using [transformer](./../helpers/transformer/README.md), used by clpq, linprog.

### Automated execution

<!-- ***NOTE:*** Automated execution relies on **local compiled** version of linprog.
Thus, before running benchmarks checkout [compilation README](./../helpers/README.md#compilation), and don't forget to compile linprog inside netlib/MIPLIB or any other test suit folder. -->

To run any any benchmarks, just use:\
`./run.sh <test-suit> <lib>`\
The result will be in file ``results-<test-suit>-<lib>-<data>.txt``,
where:

- `<test-suit>`
  - netlib
  - MIPLIB
  - Any other folder you create inside `benchmarks`. Please enter only a single word, no paths allowed.
- `<lib>`
  - glpk
  - linprog
  - clpq

### Manually execution

#### GLPK execution

Just run `glpsol --freemps <test-name>`

#### Linprog execution

If you installed linprog as an SWI-Prolog package

```prolog
?- use_module(library(linprog)).
?- consult('./<test-suit>/<test-name>').
```

If you installed linprog locally

```prolog
?- consult(linprog).
?- consult('./<test-suit>/<test-name>').
```

#### SWI-Prolog clpq execution

Just run

```prolog
?- consult(library(clpq)).
?- consult('./<test-suit>/<test-name>').
```

Note: clpq gives results in XrY, where X and Y are integers,
if you want to get a number in decimal format you can run ./convert.sh
