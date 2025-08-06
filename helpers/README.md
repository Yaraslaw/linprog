# Content

We present scripts and programs that can be helpful in this folder. For more information read the corresponding README file.

## transformer

Translate `.mps` files to `.pl` (readable by clpq and linprog). \
For more information checkout transformer [README](./transformer/README.md)

## packaging

This folder contain a single script, that is used to create SWI-Prolog package.

### Steps to install linprog pack

1. Enter current directory and run `./create_package.sh`
2. This will create package folder. You need to go `package/linprog` and execute `swipl pack install .`
3. linprog is ready to use. To check it: enter `swipl` and execute `use_module(library(linprog))`
4. To delete linprog, use `swipl pack remove linprog`

## compilation

Inside `compilation` folder you can find a script `./compile_to.sh <folder>` that can be used to compile linprog's source code to `<folder>`

Note: you need to use\
`:- consult(linprog).`\
if you want to use manually compiled (*local*) version. And you need to use

`:- use_module(library(linprog)).`\
if you installed linprog as an SWI-Prolog package.
