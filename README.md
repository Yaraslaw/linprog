# Linprog

*A tool for solving linear inequalities.*

Linprog is a linear programming (LP) library designed to replace the existing CLP(Q, R) library for linear programming within SWI-Prolog environments. Unlike CLP(Q, R), Linprog leverages the GNU Linear Programming Kit (GLPK), offering improved computational reliability and flexibility.

A key feature of Linprog is its compatibility with the CLP(Q, R) interface, allowing it to be used as a direct replacement without requiring code rewrites, along with a modular architecture that enables seamless integration of alternative LP solvers as needed

## Software requirements

Linprog (so far) has been proved to work in unix-based environments.

If you have a computer running a unix-based OS (e.g. Ubuntu, Debian, macOS), then you can go for the *Native installation*.

If you don't have a unix-based environment or want to give a try in an isolated environment you may want to use the provided sandox. Follow instructions in *Virtual installation* to go for this alternative.

> **Remark for Windows users**
> Nothing should forbid Linprog to work on Windows environments. However, as we have not yet tested it, we cannot guarantee its replicability nor correct behavior.

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

       $brew install swi-prolog
       $brew install glpk

> - install gtimeout
       $brew install coreutils

Then you need to install linprog:

### Linprog installation

Enter SWI-Prolog environment

    $swipl

Then install linprog:

    ?- pack_install(linprog).

The output should be

    true.

If this doesn't work. You can try to install linprog manually.

First, use [packaging](./helpers/packaging/) to compile linprog into an SWI-Prolog package. After this you should be able to see `package/linprog` in the root directory of the repository.

Then go inside `package/linprog` and use

    swipl pack install .

To check if linprog is installed, you can run:

    swipl
    use_module(library(linprog)).

The output should be

    true.


And finally there is the last possible way: compile source code directly. [see compilation process](#compilation)

## Virtual installation

To use Linprog into a sandbox, we need first to get installed:

- [VirtualBox V7.0](https://www.virtualbox.org/)

- [Vagrant v2.4.1](https://www.vagrantup.com/)

Once you have installed the required software, open a terminal, go to the root folder where the file *Vangrantfile*  is located, and then execute the following commands:

>     $vagrant up
>     $vagrant ssh

At this point, you will be inside å virtual machine already provisioned with the required softare to compile the Linprog ibrary. The final step is to go to the folder where the source files are. This is achieved by executing the following command:

>     $cd /vagrant_data

## Compilation

Linprog also distributes the source code. This means you can compile and use it locally.

To compile it, you have to navigate to the folder `helpers/compilation` and then run the script `./compile_to.sh <output_fodler>` indicating the directory where the binaries are generated. Note that relative paths are from folder `helpers/compilation/`.

After execution, you should get the following message:

       $Compilation produced successfully

## Usage

1. Start **SWI-Prolog**:

       $swipl

2. Load the new implementation:

The Linprog library can be loaded into the environment by running the following predicate:

       ?- consult(linprog).

3. If you see: "true", then it means you are ready to usage Linprog.

Read the [Manual](./docs/manual.md) to see examples, available predicates and how to use them.

## Correctness

To make sure Linprog behaves as expected we have created several test suits. One part of them contains test cases implemented in SWI-Prolog, whereas others contain test cases implemented using [{log}](https://www.clpset.unipr.it/setlog.Home.html) constraint programming language, which relies on SWI-Prolog's clpq library as dedicated solver to deal with constraints over the rational numbers. This is the main motivation why {log} has been selected to assess Linprog.

### Test suits

All test suits that where used to access correctness  are available in the folder **test**.

Test cases starting with `t0` are SWI-Prolog tests, and those with the letter `e` are {log} tests.

To automatically run Prolog tests, execute the following command:

      $./tests/RUN_PROLOG_test.sh <test-group> <ext> <linprog/clpq>

To automatically run {log} tests:

       $./RUN_SETLOG.sh_test <test-group> <ext> <linprog/clpq>

- `<test-group>` is one of the existing test groups:

  - **clpq**
  - **card**
  - **intervals**

- `ext` is an extension of log files generated.

- The last parameter is optional. The default value is **linprog**:
  - **linprog** - run tests using linprog library
  - **clpq** - run tests using clpq library

### Remarks

- Test cases showing clpq failing (while Linprog passes) are documented [HERE](./tests/test_cases/README.md#).

## Performance

We want to know how Linprog stands vs. SWI-Prolog's implementation of clpq library in terms of execution time. This assessment is done using tests borrow from the  [MIPLIB 2017](https://miplib.zib.de/tag_benchmark.html) and [netlib](https://www.netlib.org/lp/data/) benchmarks. More information about performance you can see [here](./benchmarking/README.md)

**************************************************************

## Notice

Linprog was created by Yaraslaw Akhramenka, Alfredo Capozucca, and Maximiliano Cristía.

It is licensed under [Simplified BSD license](https://opensource.org/license/BSD-2-Clause).

It is currently maintained by *yaraslaw.akhramenka.001 [AT] student.uni.lu*

See CONTRIBUTING.md to know how you can contribute to the project.
