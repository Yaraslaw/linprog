# Linprog 

*A tool for solving linear inequalities.*

Linprog is a linear programming (LP) library designed to replace the existing CLP(Q, R) library for linear programming within SWI-Prolog environments. Unlike CLP(Q, R), Linprog leverages the GNU Linear Programming Kit (GLPK), offering improved computational reliability and flexibility.

A key feature of Linprog is its compatibility with the CLP(Q, R) interface, allowing it to be used as a direct replacement without requiring code rewrites, along with a modular architecture that enables seamless integration of alternative LP solvers as needed

## Software requirements

Linprog (so far) has been proved to work in unix-based environments. 

If you have a computer running a unix-based OS (e.g. Ubuntu, Debian, macOS), then you can go for the *Native installation*.

If you don't have a unix-based environment or want to give a try in an isolated environment you may want to use the provided sandox. Follow instructions in *Virtual installation* to go for this alternative.

> **Remark for Windows users**
> Nothing should forbid Linprog to work on Windows environments. However, as we have not yet tested it, we cannot guarantee its replicability nor correct behaviour.

## Native installation

You need to get installed:

- [GLPK v5.0](https://www.gnu.org/software/glpk/#TOCdownloading)

- [SWI-Prolog v8.4.2 for aarch64-linux](https://www.swi-prolog.org/download/stable?show=all)

- [GCC v11.4.0](https://gcc.gnu.org/releases.html)

### Linux users

Use apt-get to install the required software.

              $ sudo apt-get update
              $ sudo apt-get install -y gcc
              $ sudo apt-get install -y swi-prolog
              $ sudo apt-get install -y glpk-utils
       

### Mac users

- [Apple Clang](https://opensource.apple.com/projects/llvm-clang/) works too, so no need to install GCC

- use brew to install the required software.

              $ brew install swi-prolog
              $ brew install glpk

> - install gtimeout

              $ brew install coreutils 

## Virtual installation

To use Linprog into a sandox, we need first to get installed:

- [VirtualBox V7.0](https://www.virtualbox.org/)

- [Vagrant v2.4.1](https://www.vagrantup.com/)

Once you have installed the required software, open a terminal, go to the root folder where the file *Vangrantfile*  is located, and then execute the following commands:

>     $ vagrant up
>     $ vagrant ssh

At this point, you will be inside å virtual machine already provisioned with the required softare to compile the Linprog ibrary. The final step is to go to the folder where the source files are. This is achieved by executing the following command:

>     $ cd /vagrant_data

## Compilation

Linprog is distributed as source code. This means you need to compile to get it working.

To compile it, you have to navigate to the folder `testing_env` and then either:

- a.  run the script `./compile_to.sh` \<output_fodler> indicating the directory where the binaries are generated. Note that relative paths are from folder `testing_env`.

- b. run the script `compile.sh` \<exec_time> indicating of max allowed time of execution (in seconds). You may want to use this option to execute randomly generated tests. Read [Prolog Test Automation Scripts](./testing_env/README.md) for more information.


After execution, you should get the following message:

       $ Compilation produced successfully

## Usage

1. Start **SWI-Prolog**:

       $ swipl

2. Load the new implementation:

The Linprog library can be loaded into the environment by running the following predicate:

       ?- consult(linprog).

3. If you see: "true", then it means you are ready to usage Linprog. 

Read the [Manual](./docs/manual.md) to see examples, available predicates and how to use them.ß


## Correctness

To make sure Linprog behaves as expected we have created two test suites. One test suits contains test cases implemented in SWI-Prolog, whereas the other contains test cases implemented using the [{log}](https://www.clpset.unipr.it/setlog.Home.html) constraint programming language, which relies on SWI-Prolog's clpq library as dedicated solver to deal with constraints over the rational numbers. This is the main motivation why {log} has been selected to assess Linprog.

### Test suites

These test suites are available into the folder **test**.

Test cases starting with `t0` are SWI-Prolog tests, and those with the letter `e0` are {log} tests.

To automatically run Prolog tests, execute the following command:

      $ ./tests/RUN_PROLOG_test.sh <test-group> <ext>

To automatically run {log} tests:

       $ ./RUN_SETLOG.sh_test <test-group> <ext>

Where `<test-group>` is one of the existing test groups:

- **clpq**
- **card**
- **intervals**

And `ext` is the extention of log files generated.

**Remarks**

- Test cases showing clpq failing (while Linprog passes) are documented [HERE](./tests/test_cases/README.md).

- You can also automatically generate test cases. For more information see [Prolog Test Automation Scripts](./testing_env/README.md). 

- Calling clpq multiple times may cause the garbage collector to remove some variables that are already in use by clpq. To solve this problem uncomment the line  ```:- set_prolog_flag(gc, false)``` in file *testing.pl*.  

## Performance

We want to know how Linprog stands vs. SWI-Prolog's implementation of clpq library in terms of execution time. This assessment is done using tests both created by our own, and borrow from the  [MIPLIB 2017](https://miplib.zib.de/tag_benchmark.html) benchmark.

The assessment is done using the following environments:

#### Env1:

- Hardware: Apple M4 Max, 64 GB
- OS: macOS 15.3.1

#### Env2:

- Hardware: Intel® Core i9-7900X 10-Core CPU 3.30GHz, 128 GB (8x Kingston HyperX 16 GB DDR4-2400
DIMM (KHX3000C15/16GX))
- OS: Debian GNU/Linux 11 (bullseye)
Kernel Version: 5.10.0

#### Env3:

- Hardware: Apple M2, 16GB
- OS: maxOS 15.4.1???

**Remarks**

- Results are shown in seconds.

- Guidelines to reproduce the benchmarking are provided [HERE](./benchmarking/README.md)

### Own tests

#### Prolog  

| | |  | Env1  |  | Env2   |  |  Env3 | | 
|----------|----------|----------|----------|----------|----------|----------|----------|----------|
| Test | #Var | Feasible | clpq  | Linprog |clpq  | Linprog | clpq | Linprog |
| `t056.pl` | 5 | Y  | 0.005   | 0.003   | Data 1   | Data 2   | | 0.001? 
| `t057.pl`  | 6 | Y | 0.007   | 0.002   | Data 1   | Data 2   | | 0.001? 
| `t058.pl`  | 7 | Y | 0.003   | 0.002   | Data 1   | Data 2   | | 0.001?
| `t059.pl`  | 8 | Y | 0.006   | 0.002   | Data 1   | Data 2   | | 0.001?
| `t060.pl`  | 9 | Y | 0.006   | 0.003   | Data 1   | Data 2   | | 0.001?
| `t061.pl`  | 10 | Y | 0.007   | 0.004  | Data 1   | Data 2   | | 0.001?
| `t062.pl`  | 14 | Y | 0.008   | 0.003   | Data 1   | Data 2   | | 0.001?
| `t063.pl`  | 6 | N | 0.001   | 0.001   | Data 1   | Data 2   | | 0.001?
| `t064.pl`  | 7 | N | 0.001 | 0.002   | Data 1   | Data 2   | | 0.001?
| `t065.pl`  | 8 | N | 0.001  | 0.003  | Data 1   | Data 2   | | 0.001?


#### {log} predicates (cardinality)
(14, 15, 16 are not representative, find better selection?)

|  | Env1  |  | Env2   |  | Env3 | | 
|----------|----------|----------|----------|----------|----------|----------|
| Test | clpq  | Linprog | clpq  | Linprog | clpq | Linprog |
| `e014.pl`  | Data 1   | Data 2   | Data 1   | Data 2   |
| `e015.pl`   | Data 1   | Data 2   | Data 1   | Data 2   |
| `e016.pl`  | Data 1   | Data 2   | Data 1   | Data 2   |


### MIPLIB benchmark

|  | | Env1  |   |  | Env2   |  |  | Env3 | |
|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|
| Test | GLPK | clpq |  Linprog | GLPK | clpq |  Linprog | GLPK | clpq | Linprog |
| `markshare_4_0`  | 369.70   | 1557.56   | Data 3   | 748.10   | Data 2   | Data 3   |
| `markshare_5_0`  | TBC   | TBC   | TBC   | TBC   | TBC   | TBC   |
| `markshare1`  | TBC   | TBC   | TBC   | TBC   | TBC   | TBC   |
| `markshare2` | TBC   | TBC   | TBC   | TBC   | TBC   | TBC   |
| `gen-ip054`  |  TBC   | TBC   | TBC   | TBC   | TBC   | TBC   |
| `gen-ip002`  |  TBC   | TBC   | TBC   | TBC   | TBC   | TBC   |
| `neos5`  | TBC   | TBC   | TBC   | TBC   | TBC   | TBC   | | | |



**************************************************************

## Notice

Linprog was created by Yaraslaw Akhramenka, Alfredo Capozucca, and Maximiliano Cristía.

It is licensed under [Simplified BSD license](https://opensource.org/license/BSD-2-Clause).

It is currently maintained by *yaraslaw.akhramenka.001 [AT] student.uni.lu*

See CONTRIBUTING.md to know how you can contribute to the project.
