sign(=<).
sign(=).
sign(>=).
sign(<).
sign(>).

/* This line should be uncommented if clpq returns answers different from a single call */
% :- set_prolog_flag(gc, false). 


gen_num(Y) :-
	random(X), Y is floor(X*100) - 50.


gen_pair(Y, LV) :- 
	length(LV, N),
	random_between(1, N, Pos),
	Id is floor(Pos + 0.5),
	nth1(Id, LV, V, _),
	gen_num(Num),
	Y = Num*V.
	
	
gen_expr([], _).
gen_expr([H|T], LV) :- 
	gen_pair(H, LV), 
	gen_expr(T, LV).


convert([], '').
convert([H|Tail], Res) :-
	convert(Tail, ResWas),
	(ResWas == ''
	-> 
		Res=H
	;
		Res = H+ResWas
	).


gen_sign(X) :- 
	findall(L, sign(L), Signs),
	random_between(1, 3, Pos),
	Id is floor(Pos + 0.5),
	nth1(Id, Signs, V, _),
	X = V.


gen_constraint(Y, LV) :- 
	gen_expr(X, LV), length(X, 4), convert(X, Expr), 
	gen_num(Bound), 
	gen_sign(Sign), Y =.. [Sign, Expr, Bound],
	!.
	
check(A, B) :- A == B.

swap_vars(H, [Hdif|_], [Hnew|_], Hnew) :- var(H), \+ compound(H), H == Hdif, !.
swap_vars(H, [_|Tail], [_|TailNew], Res) :-
	var(H), !,
	swap_vars(H, Tail, TailNew, Res).
	
swap_vars(C, _, _, C) :-
	integer(C), !.
	
swap_vars(S, X, Y, Res) :-
	S =..[Op, A, B],
	!,
	swap_vars(A, X, Y, ResA),
	swap_vars(B, X, Y, ResB),
	Res =..[Op, ResA, ResB].
	

gen_clpq_quary(ResLUX, ResCLPQ) :- 
    LV = [A, B, C, D],
    NV = [E, F, G, H],
	gen_constraint(XX, LV),
	gen_constraint(XY, LV),
	gen_constraint(XZ, LV),	
	gen_constraint(YX, LV),
	gen_constraint(YY, LV),
	gen_constraint(YZ, LV),
    gen_expr(CL, LV), length(CL, 4), convert(CL, CLExpr),
	gen_constraint(ENL, LV),
	
	swap_vars(XX, LV, NV, CXX),
	swap_vars(XY, LV, NV, CXY),
	swap_vars(XZ, LV, NV, CXZ),
	swap_vars(YX, LV, NV, CYX),
	swap_vars(YY, LV, NV, CYY),
	swap_vars(YZ, LV, NV, CYZ),
    swap_vars(CLExpr, LV, NV, CC),
	swap_vars(ENL, LV, NV, ENC),
	gen_num(Coef1), gen_num(Coef2), 
	ResLUX = ({XX, XY}, {XZ}, {YX, YY}, {YZ}, entailed(ENL)),
	ResCLPQ = (cons((CXX, CXY)), cons(CXZ), cons((CYX, CYY)), cons(CYZ), 
    clpq_entailed(ENC)),
    !.
	

% Initialize the counter with a starting value
init_counter :-
    nb_setval(counter, 0).
:- init_counter.
% Increment the counter by 1
increment_counter :-
    nb_getval(counter, Value),
    NewValue is Value + 1,
    nb_setval(counter, NewValue).

% Get the current counter value
get_counter(Value) :-
    nb_getval(counter, Value).


:- use_module(lux).
:- set_time_limit(3000).
% :- use_module(library(clpq), except([bb_inf/4, {}/1])).
:- use_module(library(clpq), [
	entailed/1 as clpq_entailed,
	inf/2 as clpq_inf, 
	sup/2 as clpq_sup,
	minimize/1 as clpq_minimize,
	maximize/1 as clpq_maximize,
	bb_inf/4 as clpq_bb_inf,
	dump/3 as clpq_dump,  
	{}/1 as cons]).
:- open("./logs.txt", write, _, [alias(output)]).
:- set_prolog_stack(global, limit(5*1024*1024*1024)).


checker() :- 	
    (get_counter(Count),
    (Count > 5 -> close(output), !;
    increment_counter,
    gen_clpq_quary(LUX, CLPQ), 
        write(output, '===================================== TASK ' : Count), 
        writeln(output, ' =================================== '),
	write(output, '/*\n\nOriginal query: \n\n'), 
	write(output, LUX), write(output, '\n\n*/\n\n'),

    writeln(output, 'Task ' :  LUX),
	flush_output(output),
    catch(ignore(call_with_time_limit(1, LUX) -> (L = t) ; (L = f)), 
	Error, (writeln(output, 'LUX:ERROR ': Error),print_message(error, Error))),
    %!,
    catch(ignore(call_with_time_limit(1, CLPQ) -> (C = t) ; (C = f)), 
	Error, (writeln(output, 'CLPQ:ERROR' : Error),print_message(error, Error))),

    write(output, '===================================== RES ': Count),
    writeln(output, ' ================================== '),
    (L == C -> writeln(output, 'next, ') ; 
        ((var(L);var(C)) -> writeln(output, 'nothing to compare');
        
        write(output, '\n\nDifference on LUX = '), 
		write(output, LUX),write(output, '\n\n'), 
		write(output, 'CLPQ = '), write(output, CLPQ), write(output, '\n\n'))), 
		%!,

     writeln(output, '============================================================================= '), fail))
     ;(
    checker()).
	

% catch(ignore(call_with_time_limit(1, CLPQ) -> (C = t) ; (C = f)), Error, print_message(error, Error)),
	
	
	
