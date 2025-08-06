# Content

This folder contains results of executing benchmarks and correctness test suits

Each run is described in it's results name:

    <test-suit-name>-<lib-used>-<TL>-<ML>.txt

## benchmarks

### results structure

Results are presented in a table with the following header:

    Test name            : Result               : Time (s)

Example:

    sc50b                : -70                  : 0.171

### Script

As clpq provides answers in XrY format, you may use `./converter.sh </path/to/results> </path/to/output>` to convert clpq results into decimal format.

## tests

Output format is a table with the following header:

    Experiment;time(s);expect;pass;short description

Example:

    t001.pl;0.003;success;OK;

Note: \
we checked correctness only in terms of: was any solution found or not? Thus test cases from clp t066 - t070 are considered as OK, even though, they print incorrect answers using clpq. For better understanding, you can checkout [tests](./../tests/test_cases/test_clpq/) and [failing test cases](./../tests/test_cases/README.md#clpq-failing-test-cases).
