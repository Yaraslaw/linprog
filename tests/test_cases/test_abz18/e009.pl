/*
% test case: e009
% Expected: false
*/

1=<Maxttd &
subset(_N6,int(1,Maxttd)) &
size(_N6,_N5) &
_N5>=0 &
_N5 is Maxttd-1+1 &
un(FREET,OCCUPIEDT,_N6) &
disj(FREET,OCCUPIEDT) &
_N3>=1 &
_N3=<Maxttd & 
_N3 nin FREET & 
_N3 nin OCCUPIEDT 
