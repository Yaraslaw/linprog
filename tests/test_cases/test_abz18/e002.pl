/*
% test case: e002
% Expected: false
*/

subset(X,int(1,Maxttd)) &
size(X,Maxttd) &
un(FREET,OCCUPIEDT,X) &
disj(FREET,OCCUPIEDT) &
neg(
    un(FREET,OCCUPIEDT,X) &
    disj(FREET,OCCUPIEDT)
    )
    