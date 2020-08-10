#ifndef METANET_GRAPHICS_H 
#define METANET_GRAPHICS_H 

#include "machine.h" 

#define NODISP 999

#define INT_NODEDISP 0
#define NAME_NODEDISP 1
#define DEMAND_NODEDISP 2
#define LABEL_NODEDISP 3
#define CANCEL_NODEDISP 4

#define INT_ARCDISP 0
#define NAME_ARCDISP 1
#define COST_ARCDISP 2
#define MINCAP_ARCDISP 3
#define MAXCAP_ARCDISP 4
#define LENGTH_ARCDISP 5
#define QWEIGHT_ARCDISP 6
#define QORIG_ARCDISP 7
#define WEIGHT_ARCDISP 8
#define LABEL_ARCDISP 9
#define CANCEL_ARCDISP 4


/* used to remove Rec driver in a set of code */

#define REMOVE_REC_DRIVER() char old_rec[4]; int rem_flag ; rem_flag = scig_driverX11(old_rec); 
#define RESTORE_DRIVER() if (rem_flag == 1) C2F(SetDriver)(old_rec,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);


#endif 
