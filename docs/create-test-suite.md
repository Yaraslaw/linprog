# Test suite creation

## Step 1 - Make a suite directory

Create a folder `test_<name>` under `tests/test_cases`.

Example `test_card`

## Step 2 - Choose Prolog or {log}

Determine if your test cases will be written in Prolog or **{log}** (setlog). Based on that choice, use the corresponding folder structure.

### Prolog suites

- Add test files named `t0*.pl` (e.g. `t001.pl`).
- Provide `expected.txt` (the source of truth).

### {log} suites

- Add test files named `e*.pl` (e.g. `e001.pl`).
- Provide `expected.txt` (the source of truth).

## Step 3 - `expected.txt` format

Each line of `expected.txt` should be like:\
`<test_name>:<success|failure>[:<comments>]`

- <test_name> - filename without `.pl`.
- <success/failure>
  
  - success - the query should yield `true.`.
  - failure - the query should yield `false.`.

- <comments> - optional (timings, memory, notes).

Example: `e001:success:32s:256MB:slow_test_case`\
Example: `t001:failure`

## Clpq failing test cases

Known failing test cases for clpq:

t003, t004, t006 - t009 - clpq consumes too much memory on simple examples and raises an ERROR.

t066 - t070 - even though, clpq finds a solution, it is incorrect.
You can see in comments, what solution is expected and what was the outcome of clpq.

Example [t070.pl](./test_clp/t070.pl)

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

This means the expected solution can be `I=1, V=[1, 1]`, but clpq gives `V=[1,0]` which is incorrect according to `Y >= 1` bound.

> ### Assumption about why clpq is wrong
>
> It seems like if a variable is not participating in the objective function, then it will be 0 as default regarding any constraints that are not leading to infeasibility of the whole system.
