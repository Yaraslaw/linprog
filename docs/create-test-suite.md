# Test suite creation

## Step 1 - Make a suite directory

Create a folder `test_<name>` under `tests/test_cases`.

Example `test_card`

## Step 2 - Choose SWI-Prolog or {log}

Determine if your test cases will be written in SWI-Prolog or **{log}**. Based on that choice, use the corresponding folder structure.

### SWI-Prolog suites

- Add test files named `t0*.pl` (e.g. `t001.pl`).
- Provide `expected.txt` (the source of truth).

### {log} suites

- Add test files named `e*.pl` (e.g. `e001.pl`).
- Provide `expected.txt` (the source of truth).

## Step 3 - `expected.txt` format

Each line of `expected.txt` should be like:\
`<test_name>:<success|failure|timeout>[:<comments>]`

- <test_name> - filename without `.pl`.
- <success/failure/timeout>
  
  - success (a solution exists for the LP problem described in the test case)
  - failure (no solution exists)
  - timeout (max execution allowed time is exceeded)

- <comments> - optional (timings, memory, notes).

Example: `e001:success:32s:256MB:slow_test_case`\
Example: `t001:failure`

## CLP(Q) failing test cases

Known failing test cases when using clpq.pl library:

**t003, t004, t006 - t009**: memory limit is exceeded, so ERROR exception is raised.

**t066 - t070**: the provided solution is incorrect. Each test case contains comments indicating what solution is expected to be found, and what is provided by clpq.pl.

Example [t070.pl](../tests/test_cases/test_clp/t070.pl)

```prolog
/*

Solution: 
I = 1,
V = [1, 1],
{X>=1},
{Y>=1}.

V = [1, 0], 
is NOT a solution, because:
Y >= 1
*/
```

This means the expected solution is `I=1, V=[1, 1]`, but clpq.pl gives `V=[1,0]` which is incorrect as it violates the constraint `Y >= 1`.

