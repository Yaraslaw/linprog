subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_fk,UNIVERALSET) &
size(B_fk,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_fj,UNIVERALSET) &
size(B_fj,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_fi,UNIVERALSET) &
size(A_fi,M4) &
M4 >= N - T &
subset(A_fh,UNIVERALSET) &
size(A_fh,M5) &
M5 >= N - T &
diff(UNIVERALSET,F,M7) &
inters(B_fk,B_fj,M8) &
inters(M8,A_fi,M9) &
inters(M9,A_fh,M10) &
inters(M10,M7,M11) &
size(M11,M12) &
M12 < N - T

