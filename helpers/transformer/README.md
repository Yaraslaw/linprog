# Transformer usage

The transformer converts `.mps` problem files into Prolog files that can be executed by `clpq` or `linprog`.

## Usage

### Automated

Run transformer on any folder; it reads all files ending with `.mps` and converts them to the `.pl` format.

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

## Manual

1. Enter *`transformer`* folder

2. Start SWI-Prolog

    ```bash
    $ swipl
    ```

3. Load transformer

    ```prolog
    ?- consult('transformer.pl').
    ```

4. Translate a single file

    ```prolog
    ?- parse('/path/to/<file-mps>.mps',
    '/any/path/<file>.pl').
    ```

This creates `<file>.pl`, which you can then `consult/1` from SWI-Prolog.
