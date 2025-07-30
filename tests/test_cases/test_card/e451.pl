subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_et,UNIVERALSET) &
size(B_et,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_es,UNIVERALSET) &
size(B_es,M3) &
2*M3 >= N + 3*T + 1 &
subset(B_er,UNIVERALSET) &
size(B_er,M4) &
2*M4 >= N + 3*T + 1 &
subset(A_eq,UNIVERALSET) &
size(A_eq,M5) &
M5 >= N - T &
subset(A_ep,UNIVERALSET) &
size(A_ep,M6) &
M6 >= N - T &
diff(UNIVERALSET,F,M7) &
inters(B_et,B_es,M8) &
inters(M8,B_er,M9) &
inters(M9,A_eq,M10) &
inters(M10,A_ep,M11) &
inters(M11,M7,M12) &
size(M12,0)

