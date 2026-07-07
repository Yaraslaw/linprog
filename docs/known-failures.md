# Known failing scenarios

## Example

Consider the linear system consisting of the integer variables X, Y, which are constrained as follows:

1. X ≥ 1
2. Y ≥ 1

The objective function is ``Minimize Z = X``.

To solve this system using SWI-Prolog's CLP(Q) library, do:

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
?- {X >= 1, Y >= 1}, bb_inf([X,Y], X, I, V).
```

Recalling ``bb_inf/4`` predicate, the first parameter holds the list of variables that must take integer values. The second parameter is an arithmetic expression (aka objective function) to be minimized subject to the current constraints and integrality of the variables in the list provided as first parameter. The third parameter corresponds to the result of minimizing the objective function, and last one is a list of values representing one vertex where the objective function yields its minimal value.

The solution produced is:

```prolog
I = 1,
V = [1, 0],
{X>=1},
{Y>=1}.
```

Certainly, the vertex V = [1, 0] (which means X=1 and Y=0) is is not a valid solution as the constraint Y ≥ 1 does not hold.

## Failing test cases

We have identified more failing scenarios.

These failing scenarios are reported as test cases.

These test cases are located in the folder ``./tests/test_cases/test_clp/``.

The example given above corresponds to the test case [t070.pl](../tests/test_cases/test_clp/t070.pl).

Other failing test cases for CLP(Q) are:

- **t003**, **t004**, and **t006-t009**: clpq raises an ERROR.

- **t066-t070**: the solution (vertex) found by clpq is incorrect.


#### CLP(R) library

- The identified failing test cases also occur when using SWI-Prolog's CLP(R) and its exclusive predicate [``bb_inf/5``](https://www.swi-prolog.org/pldoc/man?predicate=bb_inf/5).

- Next, the same example as above, but now using SWI-Prolog's CLP(R).

1- Launch SWI-Prolog,

```bash
$ swipl
```

2- Load the CLP(R) library.

```prolog
?- use_module(library(clpr)).
```

3- Encode the system into SWI-Prolog using the library's predicates and execute.

```prolog
?- {X >= 1, Y >= 1}, bb_inf([X,Y], X, I, V, 0.001).
```

It produces the same **incorrect** solution, but now with real values.

```prolog
I = 1.0,
V = [1, 0],
{X>=1.0},
{Y>=1.0}.
```

#### Another problem found in CLP(R) library

We have also identified problems with [``{}/1``](https://www.swi-prolog.org/pldoc/doc_for?object=%7B%7D/1) when executing some instances of Netlib. 

Each instance in this library has a solution, so we expect either to find it or reach either TIMEOUT or Memory Limit. However, we detected that for some instances when using CLP(Q) a solution is found, whereas it fails when using CLP(R). **Clearly this indicates a problem in the library CLP(R).**

More precisely, the problem happens when adding constraints to the constraint store via ``{}/1``. Below we provide the list of Netlib instances where we detect the problem. The goal is to use these instances not only to reproduce the problem, but also to help in the quest for finding a solution.

**Tip:** changing the order in which the constraints are added to the store allows CLP(R) to find the solution.


### Netlib

| Instance            | Result               | Time (s)| Result        | Time (s) |
|--------------------|--------------------|--------|--------------------|--------|
|| CLP(Q)               | | CLP(R)                | |
beaconfd             |33592,48581|0,591|false|0,288
brandy               |1518,509896|124,629|false|10,951
e226                 |-18,75192907|1179,505|false|0,635
bore3d               |1373,080394|7,713|false|6,906
grow7                |-47787811,81|762,962|false|30,257
scfxm1               |18416,75903|36,433|false|8,300
agg2                 |-20239252,36|44,301|false|757,692
agg3                 |10312115,94|61,748|false|1836,529
stair	| TIMEOUT	| 3001,007	| false	| 147,570
scsd1                |8,666666674|640,177|false|11,083
scagr25              |-14753433,06|3,587|false|434,055
degen2               |-1435,178|12,901|false|16,773
finnis               |172791,0656|41,023|false|116,080
etamacro             |-755,7152334|18,856|false|214,507
pilot4	| TIMEOUT	| 3001,007 |	false |	9,598
scfxm2               |36660,26156|214,82|false|66,853
bnl1                 |1977,629562|1254,752|false|364,894
perold	| TIMEOUT	| 3001,008 |	false |	32,002
scfxm3               |54901,25455|543,725|false|10,042
25fv47	| TIMEOUT |	3001,008 |	false |	6,378
pilot-ja	| TIMEOUT	| 3001,008	| false	| 18,105
degen3	| -987,293999999999983	| 797,454	| false	| 1368,519
pilotnov | TIMEOUT	| 3001,009	| false	| 27,209
pilot-we	| TIMEOUT	| 3001,009	| false	| 374,769
cycle	|TIMEOUT	|3001,007	|false	|95,800
bnl2	|TIMEOUT	|3001,009	|false	|2710,917
pilot	|TIMEOUT	|3001,011	|false	|128,931
d2q06c	| TIMEOUT	| 3001,008	| false	| 438,226
greenbea	|TIMEOUT	|3001,008	|false	|2010,302
pilot87	|TIMEOUT	|3001,017	|false	|2028,227
80bau3b	|Memory Limit	|2176,205	|false	|91,584

