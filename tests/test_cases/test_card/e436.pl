subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_dm,UNIVERALSET) &
size(C_dm,M2) &
2*M2 >= N - T + 1 &
subset(A_dl,UNIVERALSET) &
size(A_dl,M3) &
M3 >= N - T &
diff(UNIVERALSET,F,M4) &
inters(C_dm,A_dl,M5) &
inters(M5,M4,M6) &
size(M6,0)

