# Transformer

## How to use (automatically)

You can run automatically transformer on any folder. This means that it will tries to read all files ended with `.mps` and try to transform them into `.pl` format.

### Usage

`./run.sh <path-to-folder>`

You will see something like:

?\
[RANGES]\
[COLUMNS]\
.....

It means, that [header] was read. And `.` is every 100 lines parser read.\
?

## How to use (manually)

An instances belonging to a benchmark before it can be executed, it needs be translated from its standard representation to a valid SWI-Prolog predicate. To do this translation you should:

**Remark**: we use the instance *dano3_3.mps* as an example.

1. Go to the *`transformer`* folder

2. Start prolog

    `$ swipl`

3. Consult the helper that implements the translation

    `?- consult('transformer.pl').`

4. Perform the translation

    `?- parse('/path/to/dano3_3.mps',
    '/any/path/dano3_3.pl').`

A new file named *dano3_3.pl'* should be available. This file can be used as indicated above as it is a valid SWI-Prolog instance.  
