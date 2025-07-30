subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(A_eh,UNIVERALSET) &
size(A_eh,M2) &
M2 >= N - T &
subset(A_eg,UNIVERALSET) &
size(A_eg,M3) &
M3 >= N - T &
subset(A_ef,UNIVERALSET) &
size(A_ef,M4) &
M4 >= N - T &
diff(UNIVERALSET,F,M5) &
inters(A_eh,A_eg,M6) &
inters(M6,A_ef,M7) &
inters(M7,M5,M8) &
size(M8,0)

