subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
B_en =< N &
B_en >= 0 &
2*B_en >= N + 3*T + 1 &
A_em =< N &
A_em >= 0 &
2*A_em >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
2*(2*B_en + 2*A_em + M3 - 4*N) < N + 3*T + 1 &
N + 3*T + 1 > 2*0

