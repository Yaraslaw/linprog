/*
% test case: e003
% Expected: false
*/

un(FREET,OCCUPIEDT,X) &
disj(FREET,OCCUPIEDT) &
neg(
    un(FREET,OCCUPIEDT,X) &
    disj(FREET,OCCUPIEDT)
    ) &
subset(X,int(1,Maxttd)) &
size(X,Maxttd) 
