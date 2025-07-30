subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
C_el =< N &
C_el >= 0 &
2*C_el >= N - T + 1 &
B_ek =< N &
B_ek >= 0 &
2*B_ek >= N + 3*T + 1 &
A_ej =< N &
A_ej >= 0 &
A_ej >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
C_el + B_ek + 2*A_ej + M3 - 4*N < 1 &
1 > 0

