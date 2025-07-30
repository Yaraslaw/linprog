/*
% test case: e008
% Expected: false
*/

1=<Maxttd &
subset(X,int(1,Maxttd)) &
size(X,Maxttd) &
un(FREET,OCCUPIEDT,int(1,Maxttd)) &
disj(FREET,OCCUPIEDT) &
neg(
    un(FREET,OCCUPIEDT,int(1,Maxttd)) &
    disj(FREET,OCCUPIEDT)
    )  
