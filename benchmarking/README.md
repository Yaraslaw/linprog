# Benchmark reproducibility 

These guidelines help you to reproduce the benchmarking processes used to assess Linprog.

## Solver setup 


### GLPK
You should have already installed glpk (as it's required to use Linprog). 
Thus, you should be ready to use this solver to execute an instance.

To confirm that you are all set, in a terminal execute:

``$ glpsol --version``

If you get as  outcome (something close) to what is shown below, there you are good to run an instance with the GLPK solver.  

```
GLPSOL--GLPK LP/MIP Solver 5.0
Copyright (C) 2000-2020 Free Software Foundation, Inc.

This program has ABSOLUTELY NO WARRANTY.

This program is free software; you may re-distribute it under the terms
of the GNU General Public License version 3 or later.
```



### SWI-Prolog clpq
This solver operates withing SWI-Prolog. Thus, the only requirement to use it is to have installed SWI-Prolog. The clpq library comes along with the standard distribution of SWI-Prolog, so once it is installed, you should:


1-Start prolog

``$ swipl``

2-Load the library

``$ consult(library(clpq)).``


Now, you are ready to run an instance. See next section.


### Linprog
It is assumed that you have already installed all required software to use the Linprog library (otherwise see [Software requirements](../README.md)). It is also assumed that you are located in a folder where Linprog is installed (see [Usage](../README.md)). Under these assumptions, to use Linprog you should:

1-Start prolog

``$ swipl``

2-Load the library

``$ consult(linprog).``

Now, you are ready to run an instance. See next section.

**Remarks:**
> - It may be required to increase the GLPK timeout limit.
> - By default, this limit is set at 5 minutes.
> - The predicate *set_time* allows to change this limit (value is indicated in milliseconds). 
> - Example to set the limit to 30 minutes: ``?- set_time_limit(18000000).``



## Instance execution 
This section indicates how to run an instance depending in its format. 


### MPS format
Instances with this format can be directly run by the GLPK solver. To do it, simply call glpsol passing as parameter the .ms file. For example:

``glpsol markshare_4_0.mps``



### Prolog file
Prolog instances can be executed using solvers implemented in SWI-Prolog. Thus, these instances are used to compare clpq vs. Linprog. 
Assuming you have completed the setup steps indicated above, to run an instance you should simply load it into the environment. For example, to run the instance *t001.pl*:

``$ consult(t001.pl).``

The expected outcome should look like this:


```
TBC
```

**Remark: actual numbers may be different, as they depend on the chosen solver and employed environment.**


#### MIPLIB 

An instances belonging to this benchamrk before it can be executed, it needs be translated from its standard representation to a valid SWI-Prolog predicate. To do this transalation you should:

**Remark: we use the instance *markshare_4_0.mps* as example.

1- Go to the *transformer* folder
2- Copy the instance *markshare_4_0.mps* into that folder.
3-Start prolog

``$ swipl``

4- Consult the helper that implements the translation

``?- consult('transformer.pl').``


5- Perform the translation

``?- parse('markshare_4_0.mps','markshare_4_0.pl').``

A new file named *markshare_4_0.pl'* should be available in the folder. This file can be used as indicated above as it is a valid SWI-Prolog instance.  


### Setlog file
Instances in this group are executed from inside the {log} environment. Before loading this environment, it has to be decided which solver {log} should use. This is indicated into the *setlog.pl* file, by loading the library that implements the solver. So, open the file, look for the line:

```
:- use_module('linprog').
% :- use_module(library(clpq)).
```

Comment/Uncomment the line that corresponds to the solver you want to use. By default, {log} uses Linprog. 

To run an instance:

1-Start prolog

``$ swipl``

2-Load {log} 

``?- consult(’setlog.pl’).``

3-Start {log}  

``? setlog.``

4-Load the targeted instance 

``{log}=> consult('e014.pl’).``

The expected outcome should look like this:


```
TBC
```
