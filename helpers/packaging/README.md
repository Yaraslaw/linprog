### Content

This folder contain a single script, that is used to create SWI-Prolog package. 

### What you need to install linprog pack? 
1. Enter current directory and run `./create_package.sh` 
2. This will create package folder. You need to go `package/linprog` and execute `swipl pack install .`
3. linprog is ready to use. To check it: enter `swipl` and execute `use_module(library(linprog))`
4. To delete linprog, use `swipl pack remove linprog`