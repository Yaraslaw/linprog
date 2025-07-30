subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_ey,UNIVERALSET) &
size(C_ey,M2) &
2*M2 >= N - T + 1 &
subset(B_ex,UNIVERALSET) &
size(B_ex,M3) &
2*M3 >= N + 3*T + 1 &
subset(B_ew,UNIVERALSET) &
size(B_ew,M4) &
2*M4 >= N + 3*T + 1 &
subset(A_ev,UNIVERALSET) &
size(A_ev,M5) &
M5 >= N - T &
subset(A_eu,UNIVERALSET) &
size(A_eu,M6) &
M6 >= N - T &
diff(UNIVERALSET,F,M7) &
inters(C_ey,B_ex,M8) &
inters(M8,B_ew,M9) &
inters(M9,A_ev,M10) &
inters(M10,A_eu,M11) &
inters(M11,M7,M12) &
size(M12,0)

