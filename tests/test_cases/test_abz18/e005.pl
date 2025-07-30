/*
% test case: e005
% Expected: false
*/

un(FREET,OCCUPIEDT,int(1,Maxttd)) &
disj(FREET,OCCUPIEDT) &
neg(
    un(FREET,OCCUPIEDT,int(1,Maxttd)) &
    disj(FREET,OCCUPIEDT)
    )  

