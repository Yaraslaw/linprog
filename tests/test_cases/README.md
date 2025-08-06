# Test suit creation

## Step 1

Create a test suit you need to create a folder `test_<name>`\
Example `test_card`

## Step 2

Determine if your test cases will be written on prolog or **{log}** (setlog). Based on it. Your folder structure should be the following

### Step 2 prolog

You need to have `expected.txt` which will be used as a source of truth. Each test case should be in a single file that starts with `t0` and has extension with `.pl`\
Example: `t001.pl`

### Step 2 {log}

You need to have `expected.txt` which will be used as a source of truth. Each test case should be in a single file that starts with `e` and has extension with `.pl`\
Example: `e001.pl`

## expected format

Each line of `expected.txt` should be in format `<test_name>:<success/failure>:<any_comments>`

- <test_name> - name of test case file without `.pl` extensions.
- <success/failure>
  
  - success - if test case should ended with returning `true` from SWI-Prolog
  - failure if test case should ended with returning `false` from SWI-Prolog

- <any_comments> - you may add comments to test case.

Example: `e001:success:32s:256MB:slow_test_case`\
Example: `t001:failure`

## Clpq failing test cases

failing test cases for clpq:

t003, t004, t006 - t009 - clpq consumes too much memory on simple examples and falls into ERROR.

t066 - t070 - even though, clpq finds a solution, it's incorrect one.
You can see in comments, what solution is expected and what was the outcome of clpq.

Example [t070](./test_clp/t070.pl)

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

This means, that a solution that is expected can be `I=1, V=[1, 1]`. But clpq gives `V=[1,0]`, which is incorrect according to `Y >= 1` bound.

### Assumption about why clpq is wrong

It seems like if a variable is not participating in the objective function, then it will be 0 as default regarding any constraints that are not leading to infeasibility of the whole system.
