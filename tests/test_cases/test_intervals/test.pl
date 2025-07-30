consult('setlog.pl').
set_prolog_flag(answer_write_options,[max_depth(0)]).
set_prolog_flag(toplevel_print_options, [quoted(true), portray(true), spacing(next_argument)]).
time(once(rsetlog(
setmin(S,Min) &
setmax(S,Max) &
ssucc(S,Min,Max) &
size(S,N) &
2 < N

,2000,__C,__R,[]))).


