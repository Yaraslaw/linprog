# Test-based verification

This page shows the **correctness** results of CLP(Q) and Linprog libraries based on the available test suites.

## Hardware

The test suites were run on a machine with [this specifications](./hardware.md)

## Results

**Remarks**

- `{log}` **v499-1b (June 2025)** used for cardinality/intervals test cases.

- Time limit (TL) and memory limit (ML) thresholds set up to run the test cases.

### clp

| Library | TL (sec) | ML (GB) | Passing | Timeout | Memory limit | Dataset |
|----------|----------|----------|----------|----------|----------|----------|
| clpq.pl | 20 | 1  | 60/69 *| 0 | 9 | [clp-clpq](../tests/tests-results/clp-clpq-TL20s-ML1gb.txt) |
| clpr.pl | 20 | 1  | 59/69 *| 0 | 9 | [clp-clpr](../tests/tests-results/clp-clpr-TL20s-ML1gb.txt) |
| linprog.pl | 20 | 1  | 66/69 | 3 | 0 | [clp-linprog](../tests/tests-results/clp-linprog-TL20s-ML1gb.txt) |

**(*)** Test cases **t066-t070** match the ``success`` expected outcome, but the solution found by CLP(Q,R) is incorrect. This judgment required manual inspection of the test case's outcomes as it cannot be automated. Therefore, these [failing test cases](../docs/known-failures.md) also provide evidence of the faulty behaviour of the CLP(Q,R) library.

### cardinality

| Library | TL (sec) | ML (GB) | Passing | Timeout | Memory limit | Dataset |
|----------|----------|----------|----------|----------|----------|----------|
| clpq.pl | 200 | 1  | 461/470 | 9 | 0 |  [card-clpq](../tests/tests-results/card-clpq-TL200s-ML1gb.txt) |
| linprog.pl | 200 | 1  | 461/470 | 9 | 0 | [card-linprog](../tests/tests-results/card-linprog-TL200s-ML1gb.txt) |

### intervals

| Library | TL (sec) | ML (GB) | Passing | Timeout | Memory limit | Dataset |
|----------|----------|----------|----------|----------|----------|----------|
| clpq.pl | 200 | 1  | 746/748 | 2 | 0 | [int-clpq](../tests/tests-results/int-clpq-TL200s-ML1gb.txt) |
| linprog.pl | 200 | 1  | 746/748 | 2 | 0 | [int-linprog](../tests/tests-results/int-linprog-TL200s-ML1gb.txt) |




