#include <stdio.h>
#include "hocdec.h"
#define IMPORT extern __declspec(dllimport)
IMPORT int nrnmpi_myid, nrn_nobanner_;

extern void _K_cluster_ub_reg();
extern void _K_fast_ub_reg();
extern void _Na_cluster_ub_reg();
extern void _Na_fast_ub_reg();
extern void _fvpre_gabaerg_cluster_reg();
extern void _fvpre_gabaerg_fast_reg();
extern void _fvpre_glutamaterg_ongaba_reg();
extern void _fvpre_glutamaterg_onglut_reg();

modl_reg(){
	//nrn_mswindll_stdio(stdin, stdout, stderr);
    if (!nrn_nobanner_) if (nrnmpi_myid < 1) {
	fprintf(stderr, "Additional mechanisms from files\n");

fprintf(stderr," K_cluster_ub.mod");
fprintf(stderr," K_fast_ub.mod");
fprintf(stderr," Na_cluster_ub.mod");
fprintf(stderr," Na_fast_ub.mod");
fprintf(stderr," fvpre_gabaerg_cluster.mod");
fprintf(stderr," fvpre_gabaerg_fast.mod");
fprintf(stderr," fvpre_glutamaterg_ongaba.mod");
fprintf(stderr," fvpre_glutamaterg_onglut.mod");
fprintf(stderr, "\n");
    }
_K_cluster_ub_reg();
_K_fast_ub_reg();
_Na_cluster_ub_reg();
_Na_fast_ub_reg();
_fvpre_gabaerg_cluster_reg();
_fvpre_gabaerg_fast_reg();
_fvpre_glutamaterg_ongaba_reg();
_fvpre_glutamaterg_onglut_reg();
}
