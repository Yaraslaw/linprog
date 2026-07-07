# User manual

Here we presented all available predicates in Linprog and how each of them can be used. 

Unless explicitly stated, each predicate is available both in **linprogq** and **linprogr** libraries. 

Note: The examples assume that library **linprogq** is loaded.

## Predicates

- **{+Constraints}** :
       Adds the constraints given by Constraints to the constraint store.
       Example

     ```prolog
     ?- {Y >= 5}. 
     True.
     ?- {X >= 5, X =< 5}.
     X = 5.
     ```

- **entailed(+Constraints)** :
       Succeeds if adding the negation of the constraint to the store results in failure.

- **inf(+E, -Inf)** :
       Computes the infimum of Expression within the current state of the constraint store and returns that infimum in Inf.

     ```prolog
     ?- {X >= 5}, inf(2*X, I).
     I = 10.
     ?- {X > 5}, inf(X, I).
     I = 5.
     ```

- **sup(+E, -Sup)** :
       Computes the supremum of Expression within the current state of the constraint store and returns that supremum in Sup.

     ```prolog
     ?- {X =< 5}, sup(2*X, I).
     I = 10.
     ?- {X < 5}, sup(X, I).
     I = 5.
     ```

- **minimize(+E)** :
       Minimizes Expression within the current constraint store. This is the same as computing the infimum and equating the expression to that infimum.

     ```prolog
     ?- {X >= 5}, minimize(X).
     X = 5.
     ?- {X >= 5}, minimize(2*X).
     X = 5.
     ```

- **maximize(+E)** :
       Maximizes Expression within the current constraint store. This is the same as computing the supremum and equating the expression to that supremum.

     ```prolog
     ?- {X =< 5}, maximize(X).
     X = 5.
     ?- {X =< 5}, maximize(2*X).
     X = 5.
     ```

- **bb_inf(+Ints, +E, -Inf, -Vertex, +Eps)** :
       It computes the infimum of Expression within the current constraint store, with the additional constraint that in that infimum, all variables in Ints have integral values. Vertex will contain the values of Ints in the infimum. Eps denotes how much a value may differ from an integer to be considered an integer. E.g. when Eps = 0.001, then X = 4.999 will be considered as an integer (5 in this case). See set_eps/get_eps.

     ```prolog
     ?- {A >= 5, B >= 4, 2*A+2*C >= 15}, bb_inf([A, B], A+B+C, I, V, 0.001).
     I = 11.5, V = [5, 4].

     ?- {A >= 5, B >= 4, 2*A+2*C >= 15}, bb_inf([A, B, C], A+B+C, I, V, 0.001).
     I = 12, V = [5, 4, 3].
     ```

- **bb_inf(+Ints, +E, -Inf, -Vertex)** :
       It behaves the same as bb_inf/5. Built-in error margin is used (see set_eps/get_eps).

     ```prolog
     ?- {A >= 5, B >= 4, 2*A+2*C >= 15}, bb_inf([A, B], A+B+C, I, V).
     I = 11.5, V = [5, 4].

     ?- {A >= 5, B >= 4, 2*A+2*C >= 15}, bb_inf([A, B, C], A+B+C, I, V).
     I = 12, V = [5, 4, 3].
     ```

- **bb_inf(+Ints, +E, -Inf)** :
       The same as bb_inf/5 or bb_inf/4 but without returning the values of the integers. Built-in error margin is used (see set_eps/get_eps).

     ```prolog
     ?- {A >= 5, B >= 4, 2*A+2*C >= 15}, bb_inf([A, B], A+B+C, I).
     I = 11.5.

     ?- {A >= 5, B >= 4, 2*A+2*C >= 15}, bb_inf([A, B, C], A+B+C, I).
     I = 12.
     ```

- **dump(+Target, +Newvars, -CodedAnswer)** :
       Returns the constraints on Target in the list CodedAnswer where all variables of Target have been replaced by NewVars. This operation does not change the constraint store.

     ```prolog
     ?- {X >= 5, X >= 6, Y >= 12, X+Y >= 13, C+Y >= 11}, dump([X, Y], [x, y], R).
     R = [1*x+1*y>=13, 1*y>=12, 1*x>=6, 1*x>=5],
     ```

- **bb_inf_b(+Ints, +E, -Inf, -Vertex, +Eps, -St)** : 
       It behaves the same as bb_inf/5, but failure only means unfeasibility. 
  - If the system is unfeasible St is 4
  - If the system is feasible and bounded St is 5
  - If the system is feasible and unbounded St is 6
  - If the time limit was reached St is 1

     ```prolog
     ?- {A >= 5, B >= 4, 2*A+2*C >= 15}, bb_inf_b([A, B], A+B+C, I, V, 0.001, St).
     I = 11.5, V = [5, 4], St = 5.

     ?- {A >= 5, 2*A+2*C >= 15}, bb_inf_b([A, B, C], A+B+C, I, V, 0.001, St).
     I = -100000, St = 6.
     ```
  
- **bb_inf_b(+Ints, +E, -Inf, -Vertex, -St)** :
       It behaves the same as bb_inf_b/6. Built-in error margin is used (see set_eps/get_eps).

     ```prolog
     ?- {A >= 5, B >= 4, 2*A+2*C >= 15}, bb_inf_b([A, B], A+B+C, I, V, St).
     I = 11.5, V = [5, 4], St = 5.
     
     ?- {A >= 5, 2*A+2*C >= 15}, bb_inf_b([A, B, C], A+B+C, I, V, St).
     I = -100000, St = 6.
     ```

- **bb_inf_b(+Ints, +E, -Inf, -St)** :
       The same as bb_inf_b/6 or bb_inf_b/5 but without returning the values of the integers. An error margin is used (see set_eps/get_eps).

     ```prolog
     ?- {A >= 5, B >= 4, 2*A+2*C >= 15}, bb_inf_b([A, B], A+B+C, I, St).
     I = 11.5, St = 5.
     
     ?- {A >= 5, 2*A+2*C >= 15}, bb_inf_b([A, B, C], A+B+C, I, St).
     I = -100000, St = 6.
     ```

- **set_time_limit(+TL)** :
       Changes the time limit for a solver to TL (expressed in milliseconds). By default time limit is 1000s.

     ```prolog
     ?- set_time_limit(100).
     true.
     ```

- **get_time_limit(-TL)** :
       Returns the current time limit for a solver.

     ```prolog
     ?- get_time_limit(T).
     T = 1000000.
     ?- set_time_limit(100).
     true.
     ?- get_time_limit(T).
     T = 100.
     ```

- **set_eps(+Eps)** :
       Changes an error margin. By default an error margin of 0.001 is used. Eps should be between 0 and 0.5.

     ```prolog
     ?- set_eps(0.01).
     true.
     ```       

- **get_eps(-Eps)** :
       Returns an error margin. 

     ```prolog
     ?- get_eps(E).
     E = 0.001.
     ?- set_eps(0.01).
     true.
     ?- get_eps(E).
     E = 0.01.
     ```

- **set_solver(+Solver)** :
       Changes the solver to use. Solver is a member of the list [linprog_glpk].

     ```prolog
     ?- set_solver(linprog_glpk).
     true.
     ```

- **get_solver(-Solver)** :
       Returns current solver. Solver is a member of the list [linprog_glpk].

     ```prolog
     ?- get_solver(R).
     R = linprog_glpk.
     ```

## Syntax of the predicate arguments

       Constraints =:=      <Constraint>                       %single constraint
                            <Constraint>,<Constraint>          %conjunction
                            <Constraint>;<Constraint>          %disjunction
------------------------------
       Constraint =:=       <Expression> < <Expression>        %less than
                            <Expression> =< <Expression>       %less or equal
                            <=(<Expression>, <Expression>)     %less or equal	
                            <Expression> > <Expression>        %greater than
                            <Expression> >= <Expression>       %greater or equal
                            >=(<Expression>, <Expression>)     %greater or equal	
                            <Expression> = <Expression>        %equal
                            <Expression> =\= <Expression>      %not equal
                            <Expression> =:= <Expression>      %equal

-------------------------------
       Expression =:=       <Variable>                         %Prolog variable
                            <Number>                           %Prolog number
                            +<Expression>                      %unary plus 
                            -<Expression>                      %unary minus 	
                            <Expression> + <Expression>        %addition
                            <Expression> - <Expression>        %substraction
                            <Expression> * <Expression>        %multiplication

