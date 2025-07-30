/*
% test case: e010
% Expected: false
*/

_N3 nin FREET &
_N3 nin OCCUPIEDT &
subset(_N6,int(1,Maxttd)) &
un(FREET,OCCUPIEDT,_N6) &
_N3>=1 &
_N3=<Maxttd &
1=<Maxttd &
size(_N6,_N5) &
_N5>=0 &
_N5 is Maxttd-1+1
