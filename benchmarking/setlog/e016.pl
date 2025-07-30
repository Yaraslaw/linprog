/*
% test case: e016
% Expected: false
*/

1 =< A &
subset(X,int(1,A)) &
size(X,A) &
un(FREET,OCCUPIEDT,X) &
neg(un(FREET,OCCUPIEDT,X))
or
A < 1 & 
un(FREET,OCCUPIEDT,{}) &
neg(un(FREET,OCCUPIEDT,{}))