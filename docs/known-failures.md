# Known failing scenarios

## Example

Consider the linear system consisitng of the following constraints:

1. X ≥ 1
2. Y ≥ 1

and having as objective function ``Minimize Z = X``.

To solve this system using CLP(Q) library, do:

1- Launch SWI-Prolog,

```bash
$ swipl
```

2- Load the CLP(Q) library.

```prolog
?- use_module(library(clpq)).
```

3- Encode the system into SWI-Prolog using the library's predicates and execute.


```prolog
?- ( {X >= 1, Y >= 1}, bb_inf([X,Y], X, I, V)).
```

Recalling ``bb_inf/4`` predicate, the first parameter holds the list of constrained variables, the second one is the object function to be minimized, next one corresponds to the result of minimizing the objective function, and last one is the vertex where the objective function yields its minimal value.

The solution produced is:

```prolog
I = 1,
V = [1, 0],
{X>=1},
{Y>=1}.
```

Certainly, the vertex V = [1, 0] (which means X=1 and Y = 0 ) is is not a valid solution as the constraint Y ≥ 1 does not hold.

## Failing test cases

We have identified more failing scenarios.

These failing scenarios are reported as test cases.

These test cases are located in the folder ``./tests/test_cases/test_clp/``.

The example given above corresponds to the test case [t070.pl](../tests/test_cases/test_clp/t070.pl).

Other failing test cases for clpq are:

- **t003**, **t004**, and **t006-t009**: clpq raises an ERROR.

- **t066-t070**: the solution (vertex) found by clpq is incorrect.