/*

Solution: 
I = 1,
V = [1, 1],
{X>=1},
{Y>=1}.

V = [1, 0], 
is NOT a solution, because:
Y >= 1
*/

( {X >= 1, Y >= 1},
  bb_inf([X,Y], X, I, V))