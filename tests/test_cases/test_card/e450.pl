subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_eo,UNIVERALSET) &
size(B_eo,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_en,UNIVERALSET) &
size(B_en,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_em,UNIVERALSET) &
size(A_em,M4) &
M4 >= N - T &
subset(A_el,UNIVERALSET) &
size(A_el,M5) &
M5 >= N - T &
diff(UNIVERALSET,F,M6) &
inters(B_eo,B_en,M7) &
inters(M7,A_em,M8) &
inters(M8,A_el,M9) &
inters(M9,M6,M10) &
size(M10,0)

