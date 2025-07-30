subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_cf,UNIVERALSET) &
size(C_cf,M2) &
2*M2 >= N - T + 1 & 
subset(A_Ce,UNIVERALSET) &
size(A_Ce,M3) &
M3 >= N - T & 
diff(UNIVERALSET,F,M4) &
inters(C_cf,A_Ce,M5) &
inters(M5,M4,M6) &
size(M6,0)

