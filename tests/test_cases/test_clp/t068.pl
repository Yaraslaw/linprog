/*

Solution: 
I = 2,
V = [10, 3, 6, 2],
{A>=10},
{B=<3},
{D>=2, C=3*D}.

V = [0, 0, 6, 2], 
is NOT a solution, because:
A >= 10
*/

( {A >= 10,
 B =< 3,
 C = 3*D,
 D >= 2},
 bb_inf([A, B, C, D], D, I, V))