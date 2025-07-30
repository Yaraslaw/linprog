subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_fo,UNIVERALSET) &
size(C_fo,M2) &
2*M2 >= N - T + 1 &
subset(B_fn,UNIVERALSET) &
size(B_fn,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_fm,UNIVERALSET) &
size(A_fm,M4) &
M4 >= N - T &
subset(A_fl,UNIVERALSET) &
size(A_fl,M5) &
M5 >= N - T &
diff(UNIVERALSET,F,M6) &
inters(C_fo,B_fn,M7) &
inters(M7,A_fm,M8) &
inters(M8,A_fl,M9) &
inters(M9,M6,M10) &
size(M10,0)

