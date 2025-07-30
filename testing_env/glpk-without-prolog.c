#include <glpk.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


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
        int *ind = malloc((size + 1) * sizeof(int));
        double *val = malloc((size + 1) * sizeof(double));
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
        printf(" %s %g\n", (type == GLP_UP || type == GLP_FX) ? "<=" : ">=", (type == GLP_UP || type == GLP_FX) ? ub : lb);

        free(ind);
        free(val);
    }
}



int main(void) {
    glp_prob *lp;
    int ia[1+1000], ja[1+1000];
    double* ar;
    ar = (double*)malloc((100+1) * sizeof(double));

    int ar_size = 30;
    int maxVarId = 10;

    lp = glp_create_prob();
    glp_set_prob_name(lp, "example");
    glp_set_obj_dir(lp, GLP_MIN); 
    glp_add_rows(lp, 13); 
    glp_add_cols(lp, 10);

    for (int i = 1; i <= 4; ++i) {
        glp_set_col_bnds(lp, i, GLP_FR, 0, 0);
    }

    glp_set_row_bnds(lp, 1, GLP_UP, -46, -46);
    glp_set_row_bnds(lp, 2, GLP_UP, 0, 0);
    glp_set_row_bnds(lp, 3, GLP_UP, -13, -13);
    glp_set_row_bnds(lp, 4, GLP_UP, 0, 0);
    glp_set_row_bnds(lp, 5, GLP_LO, -29, -29);
    glp_set_row_bnds(lp, 6, GLP_UP, 0, 0);
    glp_set_row_bnds(lp, 7, GLP_LO, -26, -26);
    glp_set_row_bnds(lp, 8, GLP_UP, 0, 0);
    glp_set_row_bnds(lp, 9, GLP_LO, 35, 35);
    glp_set_row_bnds(lp, 10, GLP_UP, 35, 35);
    glp_set_row_bnds(lp, 11, GLP_UP, 0, 0);
    glp_set_row_bnds(lp, 12, GLP_LO, 8, 8);
    glp_set_row_bnds(lp, 13, GLP_UP, 0, 0);

    
    glp_set_col_kind(lp, 1, 2);
    glp_set_col_kind(lp, 2, 1);
    glp_set_col_kind(lp, 3, 1);
    glp_set_col_kind(lp, 4, 2);

    glp_set_col_kind(lp, 5, 3);
    glp_set_col_bnds(lp, 5, GLP_DB, 0.0, 1.0);
    glp_set_col_kind(lp, 6, 3);
    glp_set_col_bnds(lp, 6, GLP_DB, 0.0, 1.0);
    glp_set_col_kind(lp, 7, 3);
    glp_set_col_bnds(lp, 7, GLP_DB, 0.0, 1.0);
    glp_set_col_kind(lp, 8, 3);
    glp_set_col_bnds(lp, 8, GLP_DB, 0.0, 1.0);
    glp_set_col_kind(lp, 9, 3);
    glp_set_col_bnds(lp, 9, GLP_DB, 0.0, 1.0);
    glp_set_col_kind(lp, 10, 3);
    glp_set_col_bnds(lp, 10, GLP_DB, 0.0, 1.0);


    const double inf = 100000;
    ia[4] = 1, ja[4] = 5, ar[4] = -inf;
    ia[3] = 1, ja[3] = 3, ar[3] = 22;
    ia[2] = 1, ja[2] = 2, ar[2] = -6;
    ia[1] = 1, ja[1] = 1, ar[1] = 6;

    ia[5] = 2, ja[5] = 5, ar[5] = 1;

    ia[8] = 3, ja[8] = 6, ar[8] = -inf;
    ia[7] = 3, ja[7] = 2, ar[7] = 11;
    ia[6] = 3, ja[6] = 1, ar[6] = 46;

    ia[9] = 4, ja[9] = 6, ar[9] = 1;

    ia[13] = 5, ja[13] = 7, ar[13] = inf;
    ia[12] = 5, ja[12] = 4, ar[12] = 63;
    ia[11] = 5, ja[11] = 3, ar[11] = -5;
    ia[10] = 5, ja[10] = 1, ar[10] = -47;

    ia[14] = 6, ja[14] = 7, ar[14] = 1;

    ia[17] = 7, ja[17] = 8, ar[17] = inf;
    ia[16] = 7, ja[16] = 1, ar[16] = 36;
    ia[15] = 7, ja[15] = 2, ar[15] = 20;

    ia[18] = 8, ja[18] = 8, ar[18] = 1;

    ia[21] = 9, ja[21] = 9, ar[21] = inf;
    ia[20] = 9, ja[20] = 4, ar[20] = -11;
    ia[19] = 9, ja[19] = 1, ar[19] = -44;

    ia[24] = 10, ja[24] = 9, ar[24] = -inf;
    ia[23] = 10, ja[23] = 4, ar[23] = -11;
    ia[22] = 10, ja[22] = 1, ar[22] = -44;

    ia[25] = 11, ja[25] = 9, ar[25] = 1;

    ia[29] = 12, ja[29] = 10, ar[29] = inf;
    ia[28] = 12, ja[28] = 4, ar[28] = 39;
    ia[27] = 12, ja[27] = 1, ar[27] = 43;
    ia[26] = 12, ja[26] = 2, ar[26] = -28;

    ia[30] = 13, ja[30] = 10, ar[30] = 1;

    glp_load_matrix(lp, ar_size, ia, ja, ar);

    int ret = glp_simplex(lp, NULL);
    glp_intopt(lp, NULL);
    glp_delete_prob(lp);
    return 0;
}
