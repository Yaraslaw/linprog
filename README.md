# Linprog

*A tool for solving linear constraints over Q or R.*

Linprog is a linear programming (LP) library designed to act as an alternative to the CLP(Q,R) libraries that come with SWI-Prolog. 

**Why?**

We have identified [some scenarios](./docs/known-failures.md) where the libraries fail to produce the right expected output. Moreover, these libraries currently [are not being maintained](https://www.swi-prolog.org/man/clpqr.html).

**How?**

Linprog leverages the GNU Linear Programming Kit (GLPK), offering improved computational reliability and flexibility, while respecting compatibility with the CLP(Q,R) interface. This allows current users of the CLP(Q,R) libraries to replace them by Linprog without incurring in code rewrites.

## Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Quality assurance](#quality)
- [Performance](#performance)
- [License](#notice)


## Requirements

Linprog (so far) has been proven to work in unix-based environments. 

If you do not have a unix-based environment or want to give it a try in an isolated environment we provided instructions how to create virtual sandboxes.

**Note to Windows users**: nothing should forbid Linprog to work on Windows environments. However, as we have not yet tested it, we cannot guarantee its replicability nor correct behaviour.

To get Linprog working you need first to get installed:

- [GLPK](https://www.gnu.org/software/glpk/#TOCdownloading) (v5.0 or higher)

- [SWI-Prolog](https://www.swi-prolog.org/download/stable?show=all) (v9.0 or higher)

- A C compiler like [GCC](https://gcc.gnu.org/releases.html) (v11.x or later) or [Apple Clang](https://opensource.apple.com/projects/llvm-clang/) (for Mac users)

- [Make](https://www.gnu.org/software/make/) (v3.81 or later).

### Linux

Use apt-get to install the required software.

```bash
$ sudo apt-get update
$ sudo apt-get install -y swi-prolog
$ sudo apt-get install -y build-essential
$ sudo apt-get install -y glpk-utils libglpk-dev
```

### MacOS

Install Xcode from the Mac App Store to get the required C compiler.
Use [Homebrew](https://brew.sh/) to install the remaining required software.

```bash
$ brew install swi-prolog
$ brew install glpk
$ brew install coreutils
$ brew install make
```

### Sandboxes

#### Vagrant

You need to install:

- [VirtualBox](https://www.virtualbox.org/) (v7.0 or later)

- [Vagrant](https://www.vagrantup.com/) (v2.4.1 or later)

Once you have installed VirtualBox and Vagrant, open a terminal, go to the root folder where the provided [Vagrantfile](./Vagrantfile) file is located, and then execute the following commands:

```bash
$ vagrant up
$ vagrant ssh
```

At this point, you will be inside a virtual machine already provisioned with the required software to compile the Linprog library. The final step is to go to the folder where the source files are. This is achieved by executing the following command:

```bash
$ cd /vagrant_data
```

#### Docker

Below are steps to build an image using the provided [Dockerfile](./Dockerfile) and then run a container out of it.

**Remark:** You may need `sudo` rights to use docker.

1- Build the image

```bash
$ docker build -t linprog:dev .
```

2- Run a container and jump into it.

```bash
$ docker run -it --rm --name linprog -p 3000:3000 linprog:dev
```

**Remarks**

- If you want to enter into the same container from another terminal, then do:

```bash
$ docker exec -it linprog sh # or bash if available
```

- If you want to get rid of the container and image, then do:

```bash
$ docker stop linprog
$ docker rm linprog # if any image left
$ docker rmi linprog:dev # if any image left
 ```

## Installation

### Stable release

Install [released pack](https://www.swi-prolog.org/pack/list?p=linprog) for SWI-Prolog.

1- Launch SWI-Prolog.

```bash
$ swipl
```

2- Install the pack.

```prolog
?- pack_install(linprog).
```

Follow the instructions to complete the installation.

3- To verify the installation was successful, load the library.

```prolog
?- use_module(library(linprog)).
```

You should get `true.`.

Great! You are all set to use Linprog. Try the [example](#usage).

**Remark**
- if you want to remove the library, then do:

```prolog
?- pack_remove(linprog).
```


### Development release

1- Clone this repository to your local machine.

2- Install the development release. You can do this in two ways: (i) by creating a local package from the latest source code, or (ii) by compiling the latest source code directly.

#### Local package

1- Go to folder `helpers/packaging`, and run packaging script.

```bash
$ cd helpers/packaging
$ ./create_package.sh
```

Upon completion, the folder `package/linprog` appears in the root directory of the repository.

2- Navigate to `package/linprog` folder, and launch SWI-Prolog

```bash
$ cd ../../package/linprog/
$ swipl
```

3- Install the created package.

```prolog
?- pack_install('.').
```

4- To verify the installation was successful:

```prolog
?- use_module(library(linprog)).
```

The output should be `true.`.

Great! You are all set to use Linprog. Try the [example](#usage).

**Remark**

- if you want to remove the library, then do:

```prolog
?- pack_remove('linprog').
```

#### Compilation

1- Go to the folder containing the provided compilation script, and specify the output folder where the compilation results should be saved.

```bash
$ cd helpers/compilation
$ ./compile_to.sh <output_folder>
```

If compilation was successful, the you will see:

```
Compiling...
Linking -> <output_folder>/linprog_glpk_file.so
✅ Built: <output_folder>/linprog_glpk_file.so
```

2.1 - To verify the installation was successful, go to the <output_folder> and launch SWI Prolog.

```bash
$ cd <output_folder>
$ swipl
```

2.2- Load the library.

```prolog
?- consult(linprog).
```

The output should be `true.`.

Great! You are all set to use Linprog. Try the [example](#usage).

## Usage

Once the Linprog library has been installed and loaded into the SWI-Prolog environment, it is ready for use.

We show how to use it via a simple example consisting of the following constraints:

1. X + Y ≥ 6
2. X ≥ 2
3. Y ≥ 2
4. X ≤ 10
5. Y ≤ 10

and having as objective function ``Minimize Z = 3X + 2Y``.

This example is encoded as follows:


```prolog
 ({ X + Y >= 6 },
  { X >= 2 },
  { Y >= 2 },
  { X =< 10 },
  { Y =< 10 }, 
  bb_inf([X, Y], 3*X + 2*Y, Z, V)).
```

Variables Z and V represent the value of the objective function when replaced with the vertex V (i.e. the found values for each variable). 

The expected output is:

```prolog
Z = 14,
V = [2, 4].
```

which means that the minimal value of the objective function is 14, and this happens when X and Y are replaced by 2 and 4, respectively.

This example shows how to use the ``{}/1`` and ``bb_inf/4`` predicates. The [User Manual](./docs/manual.md) documents each predicate provided by Linprog along with examples.

## Quality

We rely on test cases to verify the correctness of Linprog. For that purpose we have created several test suites. Apart from a test suite containing SWI-Prolog test cases, we have also implemented test cases in [{log}](https://www.clpset.unipr.it/setlog.Home.html).

*{log}* is a constraint programming language that comes equipped with a solver to decide whether a given formula is satisfiable or not. *{log}* solver is implemented in SWI-Prolog and relies on clpq library to check the satisfiability of formulas that deal with finite integer intervals or the cardinality of a set. Examples of such formulas and their satisfiability checks are provided in Sections 8 and 9 of the [*{log}*'s user manual](https://www.clpset.unipr.it/SETLOG/setlog-man.pdf), respectively.

### Test suites

| Name | Type | # Test cases | Location |
|----------|----------|----------|----------|
| clp    | SWI-Prolog | 69    | ``./tests/test_cases/test_clp`` |
| cardinality    | *{log}*     | 470    | ``./tests/test_cases/test_card`` |
| intervals | *{log}*  | 748    | ``./tests/test_cases/test_intervals`` |


### Results

The results of having executed these test suites are duly described in a [dedicated page](./docs/testing.md)


**Remarks**

- We provide [guidelines](./docs/run-test-suite.md) to run the provided test suites. This should ease the replicability of the results.
- You can [create your own test suites](./docs/create-test-suite.md). Your [contribution](./CONTRIBUTING.md) is very welcome!  



## Performance

We evaluate Linprog’s execution time performance against SWI-Prolog’s CLP(Q) library. 

Besides comparing the performance of both libraries using the test suites, we also rely on running standard benchmark instances.

We use [MIPLIB 2017](https://miplib.zib.de/tag_benchmark.html)7 and [Netlib](https://www.netlib.org/lp/data/), which provide widely instances for linear programming solvers.

| Name | # Instances | Location |
|----------|----------|----------|
| MIPLIB 2017   | 23*    | ``./benchmarking/MIPLIB`` |
| Netlib        |  82*    | ``./benchmarking/netlib`` |

(*) We retained only instances that run in an affordable time (i.e. less than one hour).

### Results

The results of the benchmarking process are reported in a [dedicated page](./docs/benchmarking.md).

### Reproducibility

We provide guidelines to [reproduce](/docs/run-benchmark-instance.md) the benchmarking process.


## Notice

Linprog was created by Yaraslaw Akhramenka, Alfredo Capozucca, and Maximiliano Cristía.

It is licensed under [BSD 2-Clause](https://opensource.org/license/BSD-2-Clause).

It is currently maintained by *Yaraslaw Akhramenka*.

Support email for questions: *linprog [AT] uni.lu*.

See [CONTRIBUTING](./CONTRIBUTING.md) to know how you can contribute to the project.
