# Test-based verification

This page shows the results obtained from executing each available test suite.

## Hardware

The test suites were run on a machine with the following specifications:

- **Processor**: Intel® Core™ i9-7900X CPU @ 3.30GHz (10 cores) 

- **Memory** Kingston HyperX 16 GB DDR4-2400 DIMM (128 GB RAM) 

- **Motherboard** Gigabyte™ X299 AORUS Gaming 7 

- **OS**: Debian GNU/Linux 11 (bullseye) Kernel Version: 5.10.0 

## Results

**Note**: Time limit (TL) and memory limit (ML) thresholds set up to run the test cases.

### clp

| Library | TL (sec) | ML (GB) | Passing | Timeout | Memory limit | Chart | Data |
|----------|----------|----------|----------|----------|----------|----------|----------|
| clpq.pl | 20 | 1  | 60/69 *| 0 | 9 | [Time clp-clpq](../tests/graphs/clp-clpq.svg) | [clp-clpq](../tests/tests-results/clp-clpq-TL20s-ML1gb.txt) |
| linprog.pl | 20 | 1  | 66/69 | 3 | 0 | [Time clp-linprog](../tests/graphs/clp-linprog.svg) | [clp-linprog](../tests/tests-results/clp-linprog-TL20s-ML1gb.txt) |
|  |  |  |  |  |  | [Time clpq vs. Linprog](../tests/graphs/clp-linprog-vs-clp-clpq.svg) |  |

**(*)** Test cases **t066-t070** match the ``success`` expected outcome, but the solution found by clpq.pl is incorrect. This judgment required manual inspection of the test case outcomes, as it cannot be automated. Therefore, these [failing test cases](../docs/known-failures.md) also provide evidence of the faulty behaviour of the clpq.pl library.

### cardinality

| Library | TL (sec) | ML (GB) | Passing | Timeout | Memory limit | Chart | Data |
|----------|----------|----------|----------|----------|----------|----------|----------|
| clpq.pl | 200 | 1  | 461/470 | 9 | 0 | [Time card-clpq](../tests/graphs/card-clpq.svg) | [card-clpq](../tests/tests-results/card-clpq-TL200s-ML1gb.txt) |
| linprog.pl | 200 | 1  | 461/470 | 9 | 0 | [Time card-linprog](../tests/graphs/card-linprog.svg) | [card-linprog](../tests/tests-results/card-linprog-TL200s-ML1gb.txt) |
|  |  |  |  |  |  | [Time clpq vs. Linprog](../tests/graphs/card-linprog-vs-card-clpq.svg) |  |

### intervals

| Library | TL (sec) | ML (GB) | Passing | Timeout | Memory limit | Chart | Data |
|----------|----------|----------|----------|----------|----------|----------|----------|
| clpq.pl | 200 | 1  | 746/748 | 2 | 0 | [Time int-clpq](../tests/graphs/int-clpq.svg) | [card-clpq](../tests/tests-results/int-clpq-TL200s-ML1gb.txt) |
| linprog.pl | 200 | 1  | 746/748 | 2 | 0 | [Time int-linprog](../tests/graphs/int-linprog.svg) | [card-linprog](../tests/tests-results/int-linprog-TL200s-ML1gb.txt) |
|  |  |  |  |  |  | [Time clpq vs. Linprog](../tests/graphs/int-linprog-vs-int-clpq.svg) |  |




