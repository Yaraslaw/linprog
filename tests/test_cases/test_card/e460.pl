subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_gg,UNIVERALSET) &
size(B_gg,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_gf,UNIVERALSET) &
size(B_gf,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_ge,UNIVERALSET) &
size(A_ge,M4) &
M4 >= N - T &
subset(A_gd,UNIVERALSET) &
size(A_gd,M5) &
M5 >= N - T &
subset(A_gc,UNIVERALSET) &
size(A_gc,M6) &
M6 >= N - T &
inters(B_gg,B_gf,M7) &
inters(M7,A_ge,M8) &
inters(M8,A_gd,M9) &
inters(M9,A_gc,M10) &
diff(UNIVERALSET,M10,M11) &
size(M11,M12) &
M12 < 1

