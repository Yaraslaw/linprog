/*  Linprog: Linear and Mixed-Integer Programming Library for SWI-Prolog

    Author:        Yaraslaw Akhramenka
                   Alfredo Capozucca
                   Maximiliano Cristiá

    Copyright (c) 2025-2026, Yaraslaw Akhramenka,
                        Alfredo Capozucca,
                        Maximiliano Cristiá
    All rights reserved.

    This file is part of Linprog package.

    linprog_glpk_file is the C interface that connects the SWI-Prolog libraries linprogq and linprogr with the GNU Linear Programming Kit
    (GLPK), which serves as a backend solver to ensure robust and efficient optimisation.
*/

#include <SWI-Prolog.h>
#include <stdio.h>
#include <string.h>
#include <glpk.h>
#include <math.h>
#include <stdbool.h>


#define FUNCTOR_plus2       PL_new_functor(PL_new_atom("+"), 2)
#define FUNCTOR_minus2      PL_new_functor(PL_new_atom("-"), 2)
#define FUNCTOR_minus1      PL_new_functor(PL_new_atom("-"), 1)
#define FUNCTOR_times2      PL_new_functor(PL_new_atom("*"), 2)
#define FUNCTOR_divide2     PL_new_functor(PL_new_atom("/"), 2)
#define FUNCTOR_pow2	    PL_new_functor(PL_new_atom("^"), 2)
#define FUNCTOR_LO	    PL_new_functor(PL_new_atom(">="), 2)
#define FUNCTOR_UP	    PL_new_functor(PL_new_atom("=<"), 2)
#define FUNCTOR_BD 	    PL_new_functor(PL_new_atom("="), 2)
#define FUNCTOR_LOS	    PL_new_functor(PL_new_atom(">"), 2)
#define FUNCTOR_UPS	    PL_new_functor(PL_new_atom("<"), 2)





void print_lp_info(glp_prob *lp) {
    int i, j;
    printf("Binary is %d\n", GLP_BV);
    
    int num_vars = glp_get_num_cols(lp);
    printf("Variables:\n");
    for (i = 1; i <= num_vars; i++) {
        printf("Variable %d (%s): Objective coefficient = %g, Type : %d\n", 
        i, glp_get_col_name(lp, i), glp_get_obj_coef(lp, i), glp_get_col_kind(lp, i));
    }

    int num_rows = glp_get_num_rows(lp);
    printf("\nConstraints:\n");
    for (i = 1; i <= num_rows; i++) {
        printf("Constraint %d (%s):\n", i, glp_get_row_name(lp, i));

        int type = glp_get_row_type(lp, i);
        switch (type) {
            case GLP_FX:
                printf("  Type: Fixed\n");
                break;
            case GLP_LO:
                printf("  Type: Lower bound\n");
                break;
            case GLP_UP:
                printf("  Type: Upper bound\n");
                break;
            case GLP_DB:
                printf("  Type: Double bound\n");
                break;
            default:
                printf("  Type: Unknown\n");
                break;
        }

        int size = glp_get_mat_row(lp, i, NULL, NULL); 
        int *ind = malloc((size + 10) * sizeof(int));
        double *val = malloc((size + 10) * sizeof(double));
        glp_get_mat_row(lp, i, ind, val);

        printf("  Equation[%d]: ", size);
        for (j = 1; j <= size; j++) {
            if (val[j] > 0 && j > 1) {
                printf(" + ");
            } else if (val[j] < 0) {
                printf(" - ");
            }
            if (val[j] != 0) {
                printf("%g * %s", fabs(val[j]), glp_get_col_name(lp, ind[j]));
            }
        }

        double lb = glp_get_row_lb(lp, i);
        double ub = glp_get_row_ub(lp, i);
        if (type == GLP_FX) {
            printf(" = %g = %g\n", lb, ub);
        } else {
            printf(" %s %.6f\n", (type == GLP_UP) ? "<=" : ">=", (type == GLP_UP) ? ub : lb);

        }
        
        free(ind);
        free(val);
    }
}


void ErrorStatusChecker(int ret, int type) {
if (ret) {
    printf("\n\n");
    printf("Error genereted by ");
    if (type) {
        printf("GLP_INTOPT");
    } else {
        printf("GLP_SIMPLEX");
    }
    printf("\n");
}
switch(ret) {
    case GLP_EBADB : {
        printf("\nERROR[c]\n");
        printf("Unable to start the search, "
        "because the initial basis specified in the problem object "
        "is invalid - the number of basic (auxiliary and structural) variables "
        "is not the same as the number of row in the problem object.");
        break;
    }
    case GLP_ESING : {
        printf("\nERROR[c]\n");
        printf("Unable to start the search, because the basis matrix "
        "corresponding to the initial "
        "basis is singular within the working precision.");
        break;
    }
    case GLP_ECOND : {
        printf("\nERROR[c]\n");
        printf("Unable to start the search, because the basis matrix "
        "corresponfing to the initial "
        "basis is ill-conditioned, i.e. its condition number is too large");
        break;
    }
    case GLP_EBOUND : {
        printf("\nERROR[c]\n");
        printf("Unable to start the search, because some double-bounded (auxiliary or "
        "structural) variables have incorrect bounds.");
        break;
    }
    case GLP_EFAIL : {
        printf("\nERROR[c]\n");
        printf("The search was prematurely terminated due to the solver failure.");
        break;
    }
    case GLP_EOBJLL : {
        printf("\nERROR[c]\n");
        printf("The search was prematurely terminated, because of the objective function "
        "being maximized has reached its lower limit and continues decreasing "
        "(the dual simplex only)");
        break;
    }
    case GLP_EOBJUL : {
        printf("\nERROR[c]\n");
        printf("The search was prematurely terminated, because of the objective function "
        "being minimized has reached its upper limit and continues increasing "
        "(the dual simplex only)");
        break;
    }
    case GLP_EITLIM : {
        printf("\nERROR[c]\n");
        printf("The search was prematurely terminated, because the simplex iteration limit "
        "has been exceeded.");
        break;
    }
    case GLP_ETMLIM : {
        printf("\nERROR[c]\n");
        printf("The search was prematurely terminated, because the time limit "
        "has been excceeded.");
        break;
    }
    case GLP_ENOPFS : {
        printf("\nERROR[c]\n");
        printf("The LP problem instance has no primal feasible solution "
        "(only if the LP presolver is used)");
        break;
    }
    case GLP_ENODFS : {
        printf("\nERROR[c]\n");
        printf("The LP problem instance has no dual feasible solution "
        "(only if the LP presolver is used)");
        break;
    }
    case GLP_EROOT : {
        printf("\nERROR[c]\n");
        printf("Unable to start the search, because some double-bounded variables "
        "have incorrect bounds or some integer variables have non-integer "
        "(fractional) bounds.");
        break;
    }
    case GLP_EMIPGAP : {
        printf("\nERROR[c]\n");
        printf("The search was prematurely terminated, because "
        "the relative mip gap tolerance has been reached.");
        break;
    }
    case GLP_ESTOP : {
        printf("\nERROR[c]\n");
        printf("The serach was prematurely terminated by application "
        "(This code may appear only if the advanced solver interface is used)");
        break; 
    }
    case 0 : 
        break;
    default : 
        printf("WARNING: Unknown code recived from GLPK : %d\n", ret);
    
}
fflush(stdout);
}




// ------------------------------------- Trie part -----------------------------------------------------------------
// node structure
typedef struct node {
    int is_terminal; // 1 if the node is terminal, 0 otherwise
    int j; // column number in the matrix
    struct node* edges[10]; // edges to the next nodes with digits from 0 to 9
} node;

const double inf = 0; // infinity TODO: remove usage of inf
const double INF = 1e5;
node* root = NULL; // root of the Trie
size_t maxVarId = 0; // number of variables apeared in the problem
size_t ar_size = 0; // number of non-zero coeficents in the matrix
size_t row_number = 0; // number of rows in the matrix
double* ar; // array of non-zero coeficents
int* ia; // array of row indexes
int* ja; // array of column indexes 
glp_prob *lp; // problem
size_t last_symbol = 1; // iterator for ar, ia, ja
size_t len; // length of the string TODE: move to the functions

/* function to create a new node */
node* newNode() {
    node* ans = (node*)calloc(1, sizeof(node));
    if (ans == NULL) {
        printf("There's no memory");
	fflush(stdout);
        PL_fail;
    }
    return ans;
}

/* function to initialize the Trie and the global variables */
void init() {
    root = newNode();
    maxVarId = 0;
    ar_size = 0;
    last_symbol = 1;
    row_number = 0;
    return;
}

/* function to free the memory of the Trie */
void FreeNodes(node* x) {
    if (x == NULL)
        return;
    for (int i = 0; i < 10; ++i) {
        FreeNodes(x->edges[i]);
    }
    free(x);
}



/* function to get the column number of the variable with the name nameInProlog */
int GetColId(char* nameInProlog) {
    node* itr = root;
    /* The first symbol of the name in prolog is '_' */
    for (size_t i = 1; i < strlen(nameInProlog); ++i) {
        /* The prolog's name must be an integer (excepte the first symble) */
        if (nameInProlog[i]-'0' < 0 || nameInProlog[i]-'0' > 9) {
            printf("Error in nameInProlog. Got %s\n", nameInProlog);
            PL_fail;
        }
        /* If there is no edge with the nameInProlog[i] - create one */
        if (itr->edges[nameInProlog[i]-'0'] == NULL) {
            itr->edges[nameInProlog[i]-'0'] = newNode();
    	}
    	itr = itr->edges[nameInProlog[i]-'0'];
    }
    /* If the node is not terminal - make it terminal and assign the number of the column */
    if (itr->is_terminal == 0) {
        itr->is_terminal = 1;   
        itr->j = ++maxVarId;   
    }
    // printf("Got index %d\n", itr->j);
    return itr->j;
}


/* function to get the name of the variable */
char* GetName(term_t term) {
    /* Prolog's names are in format of _1234 (means first symbol is '_' and then an integer)*/
    char* name_for_now;
    if (PL_get_chars(term, &name_for_now, CVT_VARIABLE | CVT_WRITE | REP_UTF8)) {
        return name_for_now;
    } else {
        printf("\nFailed to get variable name.\n");
        PL_fail;
    }
}

/* function to check if the symbol is a digit */
bool is_digit(char x) {
    return ('0' <= x && x <= '9');
} 

/* function to get the absolute value of a double/integer from the string */
double GetDoubleFromS_ABS(size_t *i, char* s) {
    double ans = 0;
    /* Scanning an integer part */
    while ((*i) < len && is_digit(s[(*i)])) {
        ans *= 10;
        ans += s[(*i)] - '0';
        ++(*i);
    }
    /* Scanning a fractional part (if exist) */
    if ((*i) < len && s[(*i)] == '.') {
        ++(*i);
        double pw = 1./10;
        while ((*i) < len && is_digit(s[(*i)])) {
            ans += pw * (s[(*i)] - '0');
            pw *= 1./10;
            ++(*i);
        }
    }
    return ans;
}


/* Garbage collector - must be called before return. */
void GC() {
    // free lp problem
    glp_delete_prob(lp);
    // free Trie;
    for (int i = 0; i < 10; ++i) 
        FreeNodes(root->edges[i]);
    if (ia != NULL)
    	free(ia);
    if (ja != NULL) 
       free(ja);
    if (ar != NULL) 
        free(ar);
    if (root != NULL)
        free(root);
}

term_t get_answer(term_t, glp_prob*, int);

/** 	                list of integers vars       Min Value (return)		  Status from glpk
                list of constrains    |  objective func    | List of asked vars (return)  |
                         |            |         |            |             |		  |
                         V            V         V            V             V              V
*/
foreign_t pl_expr(term_t cons, term_t ints, term_t obj, term_t _mn, term_t _ans, term_t _status, term_t eps, term_t isIntOptTERM, term_t timeLimit) {
// ------------------------------------- Initial part -----------------------------------------------------------------
    // printf("HELLO WORLD!\n"), fflush(stdout);
    init();
    char* s;
    int isIntOpt; // 1 if the problem should be optimized to MIP, 0 otherwise
    if(!PL_get_integer(isIntOptTERM, &isIntOpt)) {
        printf("ERROR[c] -> unable to get isIntOpt\n");
        GC();
        PL_fail;
    }

    int timeLim; // time limit for the integer optimization
    if (!PL_get_integer(timeLimit, &timeLim)) {
        printf("ERROR[c] -> unable to get timeLimit\n");
        GC();
        PL_fail;
    }

    double intTolerance; // tolerance for the integer optimization
    if(PL_is_float(eps)) {
        if (!PL_get_float(eps, &intTolerance)) {
            printf("ERROR[c] -> unable to get eps[float]\n");
            GC();
            PL_fail;
        }
    } else {
        printf("ERROR[c] -> EPS must be float\n");
        GC();
        PL_fail;
    }
    const double EPS = intTolerance;

    glp_term_out(GLP_OFF); // turn off the output
    term_t head = PL_new_term_ref(); // The list (head) TODO: move to the functions
    term_t tail = PL_new_term_ref(); // The list (tail) TODO: move to the functions
    
    lp = glp_create_prob(); // create the problem
    glp_set_prob_name(lp, "linprog"); // set the name of the problem
    glp_set_obj_dir(lp, GLP_MIN); // set the direction of the optimization

// ------------------------------------- Reading Cons and counting #variables and #rows -------------------------------
    // printf("Reading Cons Begin\n"), fflush(stdout);

    tail = PL_copy_term_ref(cons); // copy the list of constraints
    while (PL_get_list(tail, head, tail)) {
        if(!PL_get_string(head, &s, &len)) {
            printf("Non-string element in CONS was found\n");
            continue;
        }
        int cons_counter = 0; // number of variables in the constraint
        for (int i = 0; i < len; ++i) {
            if (s[i] == '=' || s[i] == '>') {
                if (s[i] == '>') {
                    ++i; // LO
                }
                else if (s[i] == '=' && (i + 1 < len && s[i + 1] == '<')) {
                    ++i; // UP
                }
                // else FX
            } else if (s[i] == '_') {
                // Find a variable!
                ++ar_size; 
                ++cons_counter;
                int beg = i; // Mark '_' as the beginning of the Variavble name
                ++i; // Skip '_'
                while (i < len && is_digit(s[i])) { // Read the Variable name
                    ++i;
                }
                // Creating a string that contains the Variable name
                char *var = (char*)malloc((i - beg + 10) * sizeof(char));
                
                if (var == NULL) {
                    fprintf(stderr, "Memory allocation faild for var\n");
                    GC();
                    PL_fail;
                }
                // Putting the Variable name
                strncpy(var, s + beg, (i - beg));
                var[i - beg] = '\0'; // Add null terminator
                // Calling the Trie
                GetColId(var);
		        free(var);
                // Make i be the pointer to the last read symbol.
                --i;
            } else if (s[i] == ',' || s[i] == ';') {
                ++row_number;
                cons_counter = 0;
            }
        }
        ++row_number;
    }
// ------------------------------------- Reading Ints/Obj and counting #variables -------------------------------------
    // printf("Reading Ints Begin\n"), fflush(stdout);
    
     /* TODO: THIS NOTATION ONLY ACCEPTS +/-Var */
    // tail = PL_copy_term_ref(ints);
    if (PL_is_string(obj)) {/* READING OBJ */
        if (!PL_get_string(obj, &s, &len)) {
            printf("ERROR: UB");
        }
        // printf("String for obj is %s\n", s);
        
        for (int i = 0; i < len; ++i) {
            if (s[i] == '_') {
                // Find a variable!
                int beg = i; // Mark '_' as the beginning of the Variavble name
                ++i; // Skip '_'
                while (i < len && is_digit(s[i])) { // Read the Variable name
                    ++i;
                }
                // Creating a string that contains the Variable name
                char *var = (char*)malloc((i - beg + 10) * sizeof(char));
                if (var == NULL) {
                    fprintf(stderr, "Memory allocation faild for var\n");
                    GC();
                    PL_fail;
                }
                // Putting the Variable name
                strncpy(var, s + beg, (i - beg));
                var[i - beg] = '\0'; // Add null terminator
                // Calling the Trie
                // printf("Read var [obj]: %s\n", var);
                int id = GetColId(var);
		        free(var);
                // glp_set_col_kind(lp, id, GLP_IV);
                // Make i be the pointer to the last read symbol.
                --i;
            }        
        }

    }
    bool isInts_TODEL = false;
    /* Readin variable from Ints */
    tail = PL_copy_term_ref(ints);
    while (PL_get_list(tail, head, tail)) {
            isInts_TODEL = true;
        // printf("[ints]Lets see who you really are..\n");
        // Type(head);
        if (!PL_get_string(head, &s, &len)) {
            printf("non-string element in INTS was found");
            continue;
        }
        // printf("String for ints is %s\n", s);
        
        for (int i = 0; i < len; ++i) {
            if (s[i] == '_') {
                // Find a variable!
                int beg = i; // Mark '_' as the beginning of the Variavble name
                ++i; // Skip '_'
                while (i < len && is_digit(s[i])) { // Read the Variable name
                    ++i;
                }
                // Creating a string that contains the Variable name
                char *var = (char*)malloc((i - beg + 10) * sizeof(char));
                if (var == NULL) {
                    fprintf(stderr, "Memory allocation faild for var\n");
                    GC();
                    PL_fail;
                }
                // Putting the Variable name
                strncpy(var, s + beg, (i - beg));
                var[i - beg] = '\0'; // Add null terminator
                // Calling the Trie
                // printf("Read var [ints]: %s\n", var);
                int id = GetColId(var);
		        free(var);
                // lp_set_col_kind(lp, id, GLP_IV);
                // Make i be the pointer to the last read symbol.
                --i;
            }        
        }
    }
// ------------------------------------- Reading and init disjunction part --------------------------------------------

/* This one has to be independent reading part */

    // printf("Reading and init dsj begin\n"), fflush(stdout);
    tail = PL_copy_term_ref(cons);
    while (PL_get_list(tail, head, tail)) {
        if (!PL_get_string(head, &s, &len)) {
            printf("non-string element in CONS was found");
            PL_fail;
        }
    }


// ------------------------------------- Initial part of GLPK ----------------------TODO : check ar_size -------------------------------

    // printf("Init part of GLPK begin\n"), fflush(stdout);
    // This needs to create a problem.
    row_number = (row_number == 0) ? 1 : row_number;
    maxVarId = (maxVarId == 0) ?  1 : maxVarId;
    
        
    // printf("Row number: %ld\n Array size: %ld\n, Column size: %ld", 
    //     row_number, ar_size, maxVarId);
    glp_add_rows(lp, row_number);
    
    
    size_t row_id = 1;
    glp_add_cols(lp, maxVarId);
    ia = (int*)malloc((100+ar_size) * sizeof(int));
    if (ia == NULL) {
       fprintf(stderr, "Memory allocation faild for ia\n");
       GC();
       PL_fail;
    }
    ja = (int*)malloc((100+ar_size) * sizeof(int));
    if (ja == NULL) {
       fprintf(stderr, "Memory allocation faild for ja\n");
       GC();
       PL_fail;
    }
    ar = (double*)malloc((100+ar_size) * sizeof(double));
    if (ar == NULL) {
       fprintf(stderr, "Memory allocation faild for ar\n");
       GC();
       PL_fail;
    }

    /* Setting the names of the variables (not nessesary) */
    for (int i = 1; i <= maxVarId; ++i) {
        char buffer[50];
        sprintf(buffer, "[%d]", i);
        glp_set_col_name(lp, i, buffer);
        glp_set_col_bnds(lp, i, GLP_FR, 0.0, 0.0);
    }

// ------------------------------------- Going through Cons and Add them to GLPK --------------------------------------

    // printf("Going through Cons and Add them to GLPK begin\n"), fflush(stdout);
    tail = PL_copy_term_ref(cons);
    while (PL_get_list(tail, head, tail)) {
        bool negative = false; // flag for negative number
        int flag = 42; /* In case of Bounds: FX, LO, UP */
        double bound = 0; /* Constant */
        bool is_RHS = false; // flag for the right-hand side of the constraint
        if (!PL_get_string(head, &s, &len)) {
            printf("non-string element in CONS was found\n");
            continue;
        }        
	    // printf("Next station is : %s\n", s), fflush(stdout);
        for (size_t i = 0; i <= len; ++i) {
            
	    // printf("step %d\n", i), fflush(stdout);

            // If a new term of a constrint: 
            if (i != len && (s[i] == '+' || s[i] == '-' || is_digit(s[i]) || s[i] == '_')) {
                if (s[i] == '-')
                    negative = true;
                else 
                    negative = false;
                if (s[i] == '+' || s[i] == '-')
                    ++i; // skipping the sign of the number / variable
                // num is -1 if it is on RHS (don't forget, that it could be -_xxx)
                double num = (is_RHS ? -1.0 : 1.0) * (negative ? -1.0 : 1.0);
                // printf("After init num is %.6lf\n", num), fflush(stdout);
                if (s[i] != '_') {
                    // Skipping space from sign till number 
                    while (i < len && !is_digit(s[i])) {
                        ++i;
                    }
                    // Parsing the number
                    num = GetDoubleFromS_ABS(&i, s);
                    // Applying sign and moving to LHS
                    num *= (negative ? -1 : 1);
                    num *= (is_RHS ? -1 : 1);
                    // Skipping space from number till next char
                    while (i < len && s[i] == ' ') {
                        ++i;
                    }
                    // means if we met number without further multiplied variable 
                    if (s[i] != '*') {
                        // As number now in LHS, to return it to RHS, it's needed to multiply with (-1).
                        num *= (-1);
                        bound += num;
                        --i; // pointing to the last read symbol
                        continue;
                    }
                    ++i; // skipping '*'
                    // Skipping chars till '_'
                    while (i < len && s[i] != '_') {
                        ++i;
                    }
                }
                // printf("After parcing num is %.6lf\n", num), fflush(stdout);
                int beg = i; // Mark '_' as the beginning of the Variavble name
                ++i; // Skip '_'		
                while (i < len && is_digit(s[i])) { // Read the Variable name
                            ++i;
                }
                // Creating a string that contains the Variable name
                char *var = (char*)malloc((i - beg + 10) * sizeof(char));
                if (var == NULL) {
                    fprintf(stderr, "Memory allocation faild for var\n");
                    fflush(stderr);
                        GC();
                        PL_fail;
                }
		
                // Putting the Variable name
                strncpy(var, s + beg, (i - beg));
                var[i - beg] = '\0'; // Add null terminator
                // printf("Var is %s\n", var), fflush(stdout);
                // Calling the Trie
                int id = GetColId(var);
                // printf("Before freeing var\n"), fflush(stdout);
                glp_set_col_name(lp, id, var);
                if (var != NULL)
                    free(var);
                // printf("Id is %d\n", id), fflush(stdout);
                
                ia[last_symbol] = row_id;
                ja[last_symbol] = id;
                ar[last_symbol] = num;
                
                
                ++last_symbol;

                // Make i be the pointer to the last read symbol.
                --i;
            } else if (i != len && (s[i] == '=' || s[i] == '>' || s[i] == '<')) {
                is_RHS = true;
                if (s[i] == '>') {
                    if (i + 1 < len && s[i + 1] == '=') {
                        flag = GLP_LO; // LO
                        ++i;
                    } else {
                        // LO or LOS (if it is integer optimization)
                        flag = (isIntOpt ? 1 : -1) * GLP_LO; 
                    }
                }
                else if (s[i] == '=' && (i + 1 < len && s[i + 1] == '<')) {
                    flag = GLP_UP; // UP
                    ++i;
                } else if (s[i] == '<') {
                    // UP or UPS (if it is integer optimization)
                    flag = (isIntOpt ? 1 : -1) * GLP_UP;
                } else {
                    flag = GLP_FX; // FX
                }
            /* If for constraints ending */
            } else if (i == len) {
                // If no sign was found
                if (flag == 42) {
                    printf("No constraint sign (in constraint no. %ld) was found.", row_id);
                    GC();
                    PL_fail;
                }
                // Setting the bounds in the GLPK
                // if the sign is FX
                if (flag < 0) { // if the sign is strict 
                    if(flag == -GLP_LO) {
                        glp_set_row_bnds(lp, row_id, -flag, bound + EPS, bound + EPS);
                        // printf("+");
                    } else {
                        glp_set_row_bnds(lp, row_id, -flag, bound - EPS, bound - EPS);
                        // printf("-");
                    }
                    // printf("%f\n", EPS);
                } else { // if the sign is not strict
                    // printf("Bound was set to %lf\n", bound);
                    glp_set_row_bnds(lp, row_id, flag, bound, bound);
                }
                ++row_id; // next row
                negative = false; // reset flags
                flag = 42; // reset flags
                bound = 0; // reset bound
                is_RHS = false; // reset flags
            } else if (s[i] != ' ' && s[i] != '\'' && s[i] != '\"') {
                printf("The constraints are incorrect entered! Faced a char (%c)", s[i]);
                GC();
                PL_fail;
            }
        }
	// printf("Row Added\n\n"), fflush(stdout);
    }



// ------------------------------------- Setting Ints kind, Obj adding ------------------------------------------------
    
    /* Making variable from Ints to be ints */
    // printf("Setting Ints kind, Obj adding\n"), fflush(stdout);
    tail = PL_copy_term_ref(ints);
    while (PL_get_list(tail, head, tail)) {
        if (!PL_get_string(head, &s, &len)) {
            printf("non-string element in ints was found");
            continue;
        }
        
        for (int i = 0; i < len; ++i) {
            if (s[i] == '_') {
                // Find a variable!
                int beg = i; // Mark '_' as the beginning of the Variavble name
                ++i; // Skip '_'
                while (i < len && is_digit(s[i])) { // Read the Variable name
                    ++i;
                }
                // Creating a string that contains the Variable name
                char *var = (char*)malloc((i - beg + 10) * sizeof(char));
    		if (ia == NULL) {
		    fprintf(stderr, "Memory allocation faild for ia\n");
	     	    GC();
	     	    PL_fail;
	    	}
                // Putting the Variable name
                strncpy(var, s + beg, (i - beg));
                var[i - beg] = '\0'; // Add null terminator
                // Calling the Trie
                int id = GetColId(var);
		free(var);
                glp_set_col_kind(lp, id, GLP_IV);
                // Make i be the pointer to the last read symbol.
                --i;
            }        
        }
    }
    
    bool obj_used = false;
    if (PL_is_string(obj)) { 
        /* Adding Obj to GLPK */
        bool negative = false; // flag for negative number
        int flag = 42; // flag for the sign of the number
        double bound = 0; // bound
        bool is_RHS = false; // flag for the right-hand side of the constraint
        if (!PL_get_string(obj, &s, &len)) {
            printf("ERROR: UB obj is both string and not string");
        }
        for (size_t i = 0; i < len; ++i) {
            // If a new term of a constrint: 
            if (s[i] == '+' || s[i] == '-' || is_digit(s[i]) || s[i] == '_') {
                if (s[i] == '-')
                    negative = true;
                else 
                    negative = false;
                if (s[i] == '+' || s[i] == '-')
                    ++i; // skipping the sign of the number / variable
                // num is -1 if it is on RHS (don't forget, that it could be -_xxx)
                double num = (is_RHS ? -1 : 1) * (negative ? -1 : 1);
                if (s[i] != '_') {
                    // Skipping space from sign till number 
                    while (i < len && !is_digit(s[i])) {
                        ++i;
                    }
                    // Parsing the number
                    num = GetDoubleFromS_ABS(&i, s);
                    // Applying sign and moving to LHS
                    num *= (negative ? -1 : 1);
                    num *= (is_RHS ? -1 : 1);
                    // Skipping space from number till next char
                    while (i < len && s[i] == ' ') {
                        ++i;
                    }
                    // means if we met number without further multiplied variable 
                    if (s[i] != '*') {
                        // As number now in LHS, to return it to RHS, it's needed to multiply with (-1).
                        num *= (-1);
                        bound += num;
                        --i; // pointing to the last read symbol
                        continue;
                    }
                    ++i; // skipping '*'
                    // Skipping chars till '_'
                    while (i < len && s[i] != '_') {
                        ++i;
                    }
                }
                int beg = i; // Mark '_' as the beginning of the Variavble name
                ++i; // Skip '_'
                while (i < len && is_digit(s[i])) { // Read the Variable name
                    ++i;
                }
                // Creating a string that contains the Variable name
                char *var = (char*)malloc((i - beg + 10) * sizeof(char));
    		if (ia == NULL) {
		    fprintf(stderr, "Memory allocation faild for ia\n");
	     	    GC();
	     	    PL_fail;
	    	}
                // Putting the Variable name
                strncpy(var, s + beg, (i - beg));
                var[i - beg] = '\0'; // Add null terminator
                // Calling the Trie
                int id = GetColId(var);
                free(var); 
                glp_set_obj_coef(lp, id, num);
                obj_used = true;
                // Make i be the pointer to the last read symbol.
                --i;
            } else if (s[i] != ' ' && s[i] != '\'' && s[i] != '\"') {
                printf("The Objective Functions is incorrect entered!");
                GC();
                PL_fail;
            }
        }
    }
    
    
    // ------------------------------------- Load, Run and Check status of GLPK->Simplex work -----------------------------
    // printf("Before loading matrix\n"), fflush(stdout);
    glp_load_matrix(lp, ar_size, ia, ja, ar);

// ------------------------------------- Simplex part -----------------------------------------------------------------
    // Parameters for the simplex method
    glp_smcp parm;
    glp_init_smcp(&parm);
    parm.msg_lev = GLP_MSG_ALL;  
    // parm.presolve = GLP_ON;
    // parm.tol_bnd = 1e-15; // tolerance for the bounds
    // parm.tol_piv = 1e-15; // tolerance for the pivots
    // parm.tol_dj =  1e-15; // tolerance for the dual feasible 
    parm.tm_lim = timeLim; // 100 sec by default     
    // printf("Before Simplex Call\n"), fflush(stdout);

    int ret = glp_simplex(lp, &parm);

    // print_lp_info(lp);

    // printf("After Simplex Call\n"), fflush(stdout);
    // Check the status of the simplex method
    ErrorStatusChecker(ret, 0);
    // printf("After Error Status Check\n"), fflush(stdout);
    if (ret != 0) {
        printf("Simplex finished with non-zero code. Return Fail.");
	fflush(stdout);
        GC();
    	PL_fail;
    }
    int st = glp_get_status(lp);

    // printf("Status [Simplex] is %d\n", st), fflush(stdout);

    if (st == 4) {
        // LP has No feasuble solution.
        if (!PL_unify_integer(_status, st)) {
            printf("Failed to unify status");
        }
        fflush(stdout);
	GC();
        PL_succeed;
    }
    // printf("Status is not 4\n"), fflush(stdout);
    if (st == 6) {
        // LP has unbounded solution.
        if (!PL_unify_integer(_status, st)) {
            printf("Failed to unify status");
        }
        if(!PL_unify_float(_mn, -INF)) {
        	printf("Failed to unify objective function");
        }
	fflush(stdout);
	GC();
        PL_succeed; // failness means unboundness 
        // But failness of GLPK means that the problem execution failed
    }
    // printf("Before int opt"), fflush(stdout);
    if (!isIntOpt) {
        if (st != 5) {
            printf("ERROR[c] -> unknown status of simplex method\n");
	    fflush(stdout);
        }
        int frozenMxVar = maxVarId; // frozen politic
        if(!PL_unify_integer(_status, st)) {
            printf("Failed to unify status\n");
        }
        if (!PL_unify_float(_mn, glp_get_obj_val(lp))) {
            printf("Failed to unify objective value\n");
        }
        term_t list_new = get_answer(ints, lp, 0);
        if (!PL_unify(_ans, list_new)) {
            printf("Failed to unify objective numbers");
        }

    } else if (st == 5) {
        // printf("glp_intopt begin"), fflush(stdout);
        glp_iocp paramInt;
        glp_init_iocp(&paramInt);
        paramInt.tm_lim = timeLim; // some sec by default
        // paramInt.fp_heur = GLP_ON;
        // paramInt.gmi_cuts = GLP_ON; // ??? [usage proved in TC1-2]
        // paramInt.mir_cuts = GLP_ON;
        // paramInt.cov_cuts = GLP_ON;
        paramInt.tol_int = intTolerance;
        // paramInt.binarize = GLP_ON;
        
        // paramInt.presolve = GLP_ON; 
        // paramInt.bt_tech = GLP_BT_BPH;
        // ?? [usage proved in TC5]
        // [unusage proved in TC11 :( ]


        // paramInt.binarize = GLP_ON; // only with presolve


        // printf("Time limit is %d\n", timeLim);
        // fflush(stdout);
	// printf("Before intopt\n"), fflush(stdout);
        ret = glp_intopt(lp, &paramInt);
        // printf("int opt ended with %d\n", ret);
        fflush(stdout);
        ErrorStatusChecker(ret, 1);

    	
        int status_mip = glp_mip_status(lp);
        if (status_mip == 1) {
            if (!PL_unify_integer(_status, status_mip)) {
                printf("Failed to unify status");
            }
	    fflush(stdout);
	    GC();
            PL_succeed;
        }
        double val = glp_get_obj_val(lp);
        if (status_mip == 4) {
            if (!PL_unify_integer(_status, status_mip)) {
                printf("Failed to unify status");
            }
            if (!PL_unify_float(_mn, val)) {
                printf("Failed to unify objective value");
            }
	    fflush(stdout);
	    GC();
            PL_succeed;
        }

    	val = glp_mip_obj_val(lp);
        term_t list_new = get_answer(ints, lp, 1);
    	if (!PL_unify_float(_mn, val)) {
            printf("Failed to unify objective value");
        }
        if (!PL_unify(_ans, list_new)) {
            printf("Failed to unify integer values");
        }
        if (!PL_unify_integer(_status, glp_mip_status(lp))) {
            printf("Failed to unify status");
        }


    } else {
        if (!PL_unify_integer(_status, st)) {
            printf("Failed to unify status");
        }
    }
    
    // printf("GOODBYE WORLD!\n");
    GC(); 
    fflush(stdout);
    PL_succeed;
    
}

term_t get_answer(term_t ints, glp_prob *lp, int isIntOpt) {
    int frozenMxVar = maxVarId; // frozen politic
    term_t tail = PL_copy_term_ref(ints); // copy the list of variables that must be integers
    term_t head = PL_new_term_ref();  // iterator through the list of variables
    term_t list = PL_new_term_ref();  // the list of values
    term_t list_new = PL_new_term_ref(); // the reversed list of values (to return)
    PL_put_nil(list);
    char* str; // the string that contains the variable names
    size_t len; // the length of the string
    while (PL_get_list(tail, head, tail)) {
        if (!PL_get_string(head, &str, &len)) {
            printf("non-string element in INTS was found");
            continue;
        }
        
        for (int i = 0; i < len; ++i) {
            if (str[i] == '_') {
                // Find a variable!
                int beg = i; // Mark '_' as the beginning of the Variavble name
                ++i; // Skip '_'
                while (i < len && is_digit(str[i])) { // Read the Variable name
                    ++i;
                }
                // Creating a string that contains the Variable name
                char *var = (char*)malloc((i - beg + 10) * sizeof(char));
    		if (ia == NULL) {
		    fprintf(stderr, "Memory allocation faild for ia\n");
	     	    GC();
	     	    PL_fail;
	    	}
                // Putting the Variable name
                strncpy(var, str + beg, (i - beg));
                var[i - beg] = '\0'; // Add null terminator
                // Calling the Trie
                // printf("Read var: %s\n", var);
                int id = GetColId(var);
		free(var);
                term_t value = PL_new_term_ref();
                if (isIntOpt) {
                    int node_val = 0;
                    if (id > frozenMxVar) {
                        printf("OUT OF RANGE [using frozen politic]\n");
                        node_val = 0;
                    } else {
                        node_val = floor(glp_mip_col_val(lp, id)+0.5);
                    }
                    if (!PL_put_integer(value, node_val)) {
                        printf("Failed to unify objective value");
                    }
                } else {
                    double node_val = 0;
                    if (id > frozenMxVar) {
                        printf("OUT OF RANGE [using frozen politic]\n");
                        node_val = 0;
                    } else {
                        node_val = glp_get_col_prim(lp, id);
                    }
                    if (!PL_put_float(value, node_val)) {
                        printf("Failed to unify objective value");
                    }
                }
                                
                if (!PL_cons_list(list, value, list)) {
                    printf("Failed to construct the list of values");
                }
                --i;
            }        
        }
    }
    PL_put_nil(list_new);
    tail = PL_copy_term_ref(list);
    while (PL_get_list(tail, head, tail)) {
        if (!PL_cons_list(list_new, head, list_new)) {
            printf("Failed to construct the reverced list");
        }
    }
    return list_new;
}


install_t install() {
    PL_register_foreign("linprog_glpk", 9, (pl_function_t)pl_expr, 0);
}


int main(void) {
    return 0;
}
