# Transformer

We provide a SWI-Prolog program that transforms mathematical optimization problems described in [MPS format](https://en.wikipedia.org/wiki/MPS_(format)).

This transformer converts a `.mps` file into a SWI-Prolog file that can be solved using either `CLP(Q,R)` or `Linprog`.

This transformer has been used to convert the .mps files available in the [MIPLIB 2017](https://miplib.zib.de/tag_benchmark.html) and [netlib](https://www.netlib.org/lp/data/) benchmarks.

Nothing should forbid you to use this transformer to convert any other .mps file into a SWI-Prolog file.

## Usage

### Interactive mode

1. Go to *`transformer`* folder

2. Start SWI-Prolog

    ```bash
    $ swipl
    ```

3. Load transformer

    ```prolog
    ?- consult('transformer.pl').
    ```

4. Translate `<file>.mps` 

    ```prolog
    ?- parse('/path/to/<file>.mps','/any/path/<file>.pl').
    ```

This creates `<file>.pl`, which you can then consult from SWI-Prolog.
 ```prolog
?- consult('<file>.pl').
```


### Batch mode

It translates all `.mps` files placed in a same folder. 

```bash
$ ./run.sh <path-to-folder>
```

While running you will see progress like:
```
[NAME]
[ROWS]
[COLUMNS]
..........
..... (a dot every ~100 parsed lines)
```


Once the process ends, you will find a `.pl` file for each available `.mps`.