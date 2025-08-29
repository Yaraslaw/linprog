# Linprog

*A tool for solving linear inequalities.*

Linprog is a linear programming (LP) library designed to replace the existing CLP(Q,R) library for linear programming within SWI-Prolog environments. Unlike CLP(Q,R), Linprog leverages the GNU Linear Programming Kit (GLPK), offering improved computational reliability and flexibility.

A key feature of Linprog is its compatibility with the CLP(Q,R) interface, allowing it to be used as a direct replacement without requiring code rewrites, along with a modular architecture that enables seamless integration of alternative LP solvers.

## Software requirements

Linprog (so far) has been proven to work in unix-based environments.

If you have a computer running a unix-based OS (e.g. Ubuntu, Debian, macOS), then you can go for the *[Set up](#set-up)

If you do not have a unix-based environment or want to give it a try in an isolated environment you may want to use the provided sandbox. Follow instructions in *[Virtual installation](#virtual-installation) to go for this alternative.

> **Remark for Windows users**
> Nothing should forbid Linprog to work on Windows environments. However, as we have not yet tested it, we cannot guarantee its replicability nor correct behavior.

You need to get installed:

- [GLPK $\geq$ v5.0](https://www.gnu.org/software/glpk/#TOCdownloading)

- [SWI-Prolog $\geq$ v9.0.x](https://www.swi-prolog.org/download/stable?show=all)

- A C/C++ toolchain:
  - Linux: [GCC (e.g., 11.x)](https://gcc.gnu.org/releases.html) if fine.
  - macOS: [Apple Clang](https://opensource.apple.com/projects/llvm-clang/) works too, so no need to install GCC.

> macOS notes:
> - Some scripts use timeout; on macOS install GNU `coreutils` to get `gtimeout`:

```bash 
$ brew install coreutils
```

## Set up

### Install dependencies

#### Linux

Use apt-get to install the required software.

```bash
$ sudo apt-get update
$ sudo apt-get install -y gcc
$ sudo apt-get install -y swi-prolog
$ sudo apt-get install -y glpk-utils
``` 

#### MacOS

Use brew to install the required software.

```bash
$ brew install swi-prolog
$ brew install glpk
```


#### Virtual installation

##### Vagrant

To use Linprog in a sandbox, we need first to install:

- [VirtualBox V7.0](https://www.virtualbox.org/)

- [Vagrant v2.4.1](https://www.vagrantup.com/)

Once you have installed the required software, open a terminal, go to the root folder where the file *Vagrantfile*  is located, and then execute the following commands:
```bash
$ vagrant up
$ vagrant ssh
```
At this point, you will be inside a virtual machine already provisioned with the required software to compile the Linprog library. The final step is to go to the folder where the source files are. This is achieved by executing the following command:
```bash
$ cd /vagrant_data
```


##### Docker


Below are steps to build an image from your [Dockerfile](./Dockerfile) and run a container. 

> You may need `sudo` rights to use docker.

1) Build the image

    ```bash
    docker build -t linprog:dev .
    ```
2) Run a container (basic)

    ```bash
    docker run -it --rm --name linprog -p 3000:3000 linprog:dev
    ```
3) New a new terminal: inspect, logs, and shell

    ```bash
    docker ps
    docker logs -f linprog
    docker exec -it linprog sh # or bash if available
    ```
4) Stop and clean up

    ```bash
    docker stop linprog
    docker rm linprog # if any image left
    docker rmi linprog:dev # if any image left
    ```





### Install linprog

#### Native (recommended)

Enter SWI-Prolog environment

```bash
$ swipl
```

Then install linprog:

```prolog
?- pack_install(linprog).
```

The output should be `true.`.

If pack installation is not available, you can build the pack locally and install it.

#### Via Packaging

First, run [packaging script](./helpers/packaging/create_package.sh) to compile linprog into an SWI-Prolog package. After this, `package/linprog` will appear in the root directory of the repository.

Then navigate to `package/linprog`, then


```bash
$ swipl
```
```prolog
?- pack_install('.').
```

> It was tested only on MacOS, but it looks like you can install package without entering SWI-Prolog by calling `swipl pack install .`.

To verify installation:

```bash
$ swipl
```
```prolog
?- use_module(library(linprog)).
```
The output should be `true.`.


> To uninstall linprog, enter `swipl`, then run `pack_remove(linprog).` 
> or you can use `swipl pack remove linprog` (tested only on MacOS).

#### Alternative: local compilation

You can compile linprog directly and load it locally.

```bash
$ cd helpers/compilation
$ ./compile_to.sh <output_folder>
```

If everything was compiled without errors, you will see:

    Compilation produced successfully. 

When using a local build inside SWI-Prolog ( `swipl`), load with: 

```prolog
?- consult(linprog).
```

## Usage

After successful installation you can use [Manual](./docs/manual.md) to see examples, available predicates and how to use them.

## Correctness

To make sure Linprog behaves as expected we have created several test suites. One part of them contains test cases implemented in SWI-Prolog, whereas others contain test cases implemented using [{log}](https://www.clpset.unipr.it/setlog.Home.html) constraint programming language, which relies on SWI-Prolog's clpq library as dedicated solver to deal with constraints over the rational numbers. This is the main motivation why {log} has been selected to assess Linprog.

### Test suites

- Location: All correctness test suites are located inside folder `tests`.
- How to run them: See guidelines about runners for Prolog and {log} test suites [link](./tests/correctness.md).
- How to create your own test suites: See [test suite creation guideline](./tests/test_cases/README.md).

> Known test cases where clpq produces incorrect results (while Linprog passes) are documented [here](./tests/test_cases/README.md#clpq-failing-test-cases).

## Performance

We want to know how Linprog stands vs. SWI-Prolog's implementation of clpq library in terms of execution time. This assessment is done using tests borrowed from the [MIPLIB 2017](https://miplib.zib.de/tag_benchmark.html) and [netlib](https://www.netlib.org/lp/data/) benchmarks.

For more information about results of executing benchmarks, and scripts to run benchmarks read [benchmarking.md](./benchmarking/benchmarking.md).



**************************************************************

## Notice

Linprog was created by Yaraslaw Akhramenka, Alfredo Capozucca, and Maximiliano Cristía.

It is licensed under [Simplified BSD license](https://opensource.org/license/BSD-2-Clause).

It is currently maintained by *yaraslaw.akhramenka.001@student.uni.lu*.

See CONTRIBUTING.md to know how you can contribute to the project.
