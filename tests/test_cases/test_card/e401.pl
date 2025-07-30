subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_bd,UNIVERALSET) &
size(C_bd,M2) &
2*M2 >= N - T + 1 &
subset(B_bc,UNIVERALSET) &
size(B_bc,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_bb,UNIVERALSET) &
size(A_bb,M4) &
M4 >= N - T &
diff(UNIVERALSET,F,M5) &
inters(C_bd,B_bc,M6) &
inters(M6,A_bb,M7) &
inters(M7,M5,M8) &
size(M8,M9) &
2*M9 < N - T + 1

