subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_gb,UNIVERALSET) &
size(B_gb,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_ga,UNIVERALSET) &
size(B_ga,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_fz,UNIVERALSET) &
size(A_fz,M4) &
M4 >= N - T &
subset(A_fy,UNIVERALSET) &
size(A_fy,M5) &
M5 >= N - T &
subset(A_fx,UNIVERALSET) &
size(A_fx,M6) &
M6 >= N - T &
inters(B_gb,B_ga,M7) &
inters(M7,A_fz,M8) &
inters(M8,A_fy,M9) &
inters(M9,A_fx,M10) &
size(M10,0)

