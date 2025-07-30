# Clpq failing test cases

This page documents the test cases that fail when using the  **clpq** library either directly from SWI-Prolog or {log}.


**__Remarks__**
- The **Expected** column indicates what should be the correct outcome of having executed the test case or verification condition (VC). 
- The **Outcome** column indicates the actual result obtained from executing the test case or VC.
- Test cases were executed using SWI-Prolog version 9.2.9 for arm64-darwin.
- VCs were checked using {log} version setlog498-14a. 


## SWI Prolog test cases


### Usage
- $ swipl
- ?- consult(library(clpq)).
- copy-paste the content of the test case into the prompt.



**__Remark__**: if the test case contains a feasible system (indicated by the column), then a solution should be found. Otherwise it should return false.

| Test case   | Feasible | Expected | Outcome Clpq | Outcome Linprog |
|-------------|----------|---------|---------|---------|
| t001.pl | Y | find solution  | Exception: bb_q:bb_branch(...)    | TBC |
| t002.pl | N | false | Exception: bb_q:bb_branch(...)     | TBC |
| t003.pl | Y |find solution  | Exception: bb_q:bb_branch(...)     | TBC |
| t004.pl | Y |find solution  | Exception: bb_q:bb_inf_internal(...)    | TBC |
| t005.pl | N | false | Exception: bb_q:bb_branch(...)     | TBC |
| t006.pl | Y |find solution  | Exception: bb_q:bb_inf_internal(...)    | TBC |
| t007.pl | Y |find solution  | Exception: bb_q:bb_branch(...)     | TBC |
| t008.pl | Y |find solution  | Exception: ineq_q:ineq_one_n_p_i(...) | TBC |
| t009.pl | Y |find solution  | Exception: bb_q:bb_branch(...)     | TBC |
| t010.pl | Y |find solution  | _2749568 = 1,_2749570 = [0, -1],{...}.  | TBC |
| t011.pl | N | false | Exception: bb_q:bb_reoptimize(...)    | TBC |




## {log} 

### Cardinality test cases (to be double-checked)


#### Usage
- $ swipl
- ?- consult(setlog).
- ?- setlog.
- copy-paste the content of the test case into the prompt.


**__Remark__**: if the test case contains a satisfiable predicate, then it returns **true** along with a solution. Otherwise it returns **no**.

| Test case   | Expected | Outcome Clpq | Outcome Linprog |
|-------------|----------|---------|---------|
| e035.pl | find solution   | TBC    | TBC    |
| e059.pl | find solution   | TBC   | TBC    |
| e060.pl | find solution   | TBC   | TBC    |
| e063.pl | find solution   | TBC   | TBC    |
| e064.pl | find solution   | TBC   | TBC    |
| e066.pl | find solution   | TBC   | TBC    |
| e067.pl | find solution   | TBC   | TBC    |
| e068.pl | find solution   | TBC   | TBC    |


### ABZ18 verification conditions (VCs)


#### Usage
- $ swipl
- ?- consult(setlog).
- ?- setlog.
- Consult the file with the VCs, e.g.:
{log}=> consult('cm1-vc-linprog-new-inv-all.pl').
- Launch the VCs check process, e.g.: {log}=> check_vcs_cm1.


**__Remarks__**: 
- if the VC is discharged, then it returns **Ok**. Otherwise it returns **ERROR** or **TIMEOUT**.
- Timeout limits are set at 1 minute, 10 minutes, and 1000 minutes (~16.5 hours).

#### Pools of VCs.

The available files containing mutliple VCs are listed and explained in the [ABZ18 case study page](../../case-studies/abz18/Readme.md).


#### Individual VCs grouped by operations


| VC | Timeout (min) | Outcome Clpq | Outcome Linprog|
|-------------|----------|---------|---------|
| | move_non_ambtrain_1 |||
| move_non_ambtrain_1_pi_inv3_1 | 1 | Ok | TIMEOUT |
| move_non_ambtrain_1_pi_inv4_2 | 1 | Ok | TIMEOUT |
| move_non_ambtrain_1_pi_inv5_2 | 1 | Ok | TIMEOUT |
| move_non_ambtrain_1_pi_inv13 | 10 | TBD | TIMEOUT |
| move_non_ambtrain_1_pi_inv13 | 1000 | TBD | TIMEOUT |
| | move_non_ambtrain_2 |||
| move_non_ambtrain_2_pi_inv12 | 1 | TIMEOUT | TIMEOUT |
| move_non_ambtrain_2_pi_inv13 | 10 | TBD | ***ERROR***: problem in arithmetic expression |
| move_non_ambtrain_2_pi_inv13 | 1000 | TBD | TIMEOUT |
| | disconnect_1 |||
| disconnect_1_pi_inv_LastU_AMBTRAIN | 1000 | TBD | ERROR |
| disconnect_1_pi_inv13 | 1 | TIMEOUT | ***ERROR***: problem in arithmetic expression |
| | disconnect_2 |||
| disconnect_2_pi_inv13 | 1 | TIMEOUT | ***ERROR***: problem in arithmetic expression |
| disconnect_2_pi_inv13 | 1000 | TBD | TIMEOUT |
| disconnect_2_pi_inv_LastU_AMBTRAIN | 1000 | TBD | ERROR |
| | reconnect |||
| reconnect_pi_inv13 | 1 | ERROR | ***ERROR***: problem in arithmetic expression |
| reconnect_pi_inv17 | 1 | TIMEOUT | TIMEOUT |
| reconnect_pi_inv_LastU_AMBTRAIN | 1000 | TBD | ERROR |
| | ghost_1 |||
| ghost_1_pi_inv1 | 1000 | TBD | ERROR |
| | ghost_2 |||
| ghost_2_pi_inv1 | 1000 | TBD | ***ERROR***: Stack limit (1.0Gb) exceeded |
| ghost_2_pi_inv_LastU_AMBTRAIN | 1000 | TBD | TBD |
| ghost_2_pi_inv_Comp1_AMBTRAIN | 1000 | TBD | TBD |
| ghost_2_pi_inv_Comp2_AMBTRAIN | 1000 | TBD | TBD |
| | move_ambtrain_3 |||
| move_ambtrain_3_pi_inv_22 | 1 | TIMEOUT | TIMEOUT |
| move_ambtrain_3_pi_inv_LastU_AMBTRAIN | 1000 | TBD | TBD |
| move_ambtrain_3_pi_inv_Comp1_AMBTRAIN | 1000 | TBD | TBD |
| move_ambtrain_3_pi_inv_Comp2_AMBTRAIN | 1000 | TBD | TBD |
| | move_ambtrain_4 |||
| move_ambtrain_4_pi_inv_22 | 1 | TIMEOUT | TIMEOUT |
| move_ambtrain_4_pi_inv_25 | 1 | TIMEOUT | TIMEOUT |
| move_ambtrain_4_pi_inv_LastU_AMBTRAIN | 1000 | TBD | TBD |
| move_ambtrain_4_pi_inv_Comp2_AMBTRAIN | 1000 | TBD | TBD |