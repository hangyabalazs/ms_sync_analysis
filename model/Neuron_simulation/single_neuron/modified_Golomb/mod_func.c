#include <stdio.h>
#include "hocdec.h"
#define IMPORT extern __declspec(dllimport)
IMPORT int nrnmpi_myid, nrn_nobanner_;

extern void _IH_params_reg();
extern void _kd_reg();
extern void _kdr_reg();
extern void _nas_reg();

modl_reg(){
	//nrn_mswindll_stdio(stdin, stdout, stderr);
    if (!nrn_nobanner_) if (nrnmpi_myid < 1) {
	fprintf(stderr, "Additional mechanisms from files\n");

fprintf(stderr," IH_params.mod");
fprintf(stderr," kd.mod");
fprintf(stderr," kdr.mod");
fprintf(stderr," nas.mod");
fprintf(stderr, "\n");
    }
_IH_params_reg();
_kd_reg();
_kdr_reg();
_nas_reg();
}
