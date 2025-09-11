# Benchmarking

This page shows the **performance results** of CLP(Q) and Linprog based  selected benchmarks.



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


## Results post-processing

The [same scripts](../docs/run-test-suite.md#results-post-processing) used to process the results obtained from executing a test suite can be used to process the bechmark results.




