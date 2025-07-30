subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_ek,UNIVERALSET) &
size(B_ek,M2) &
2*M2 >= N + 3*T + 1 &
subset(A_ej,UNIVERALSET) &
size(A_ej,M3) &
M3 >= N - T &
subset(A_ei,UNIVERALSET) &
size(A_ei,M4) &
M4 >= N - T &
diff(UNIVERALSET,F,M5) &
inters(B_ek,A_ej,M6) &
inters(M6,A_ei,M7) &
inters(M7,M5,M8) &
size(M8,0)

