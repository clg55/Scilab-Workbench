/* This Software is ( Copyright INRIA . 1998  1 )                    */
/*                                                                   */
/* INRIA  holds all the ownership rights on the Software.            */
/* The scientific community is asked to use the SOFTWARE             */
/* in order to test and evaluate it.                                 */
/*                                                                   */
/* INRIA freely grants the right to use modify the Software,         */
/* integrate it in another Software.                                 */
/* Any use or reproduction of this Software to obtain profit or      */
/* for commercial ends being subject to obtaining the prior express  */
/* authorization of INRIA.                                           */
/*                                                                   */
/* INRIA authorizes any reproduction of this Software.               */
/*                                                                   */
/*    - in limits defined in clauses 9 and 10 of the Berne           */
/*    agreement for the protection of literary and artistic works    */
/*    respectively specify in their paragraphs 2 and 3 authorizing   */
/*    only the reproduction and quoting of works on the condition    */
/*    that :                                                         */
/*                                                                   */
/*    - "this reproduction does not adversely affect the normal      */
/*    exploitation of the work or cause any unjustified prejudice    */
/*    to the legitimate interests of the author".                    */
/*                                                                   */
/*    - that the quotations given by way of illustration and/or      */
/*    tuition conform to the proper uses and that it mentions        */
/*    the source and name of the author if this name features        */
/*    in the source",                                                */
/*                                                                   */
/*    - under the condition that this file is included with          */
/*    any reproduction.                                              */
/*                                                                   */
/* Any commercial use made without obtaining the prior express       */
/* agreement of INRIA would therefore constitute a fraudulent        */
/* imitation.                                                        */
/*                                                                   */
/* The Software beeing currently developed, INRIA is assuming no     */
/* liability, and should not be responsible, in any manner or any    */
/* case, for any direct or indirect dammages sustained by the user.  */
/*                                                                   */
/* Any user of the software shall notify at INRIA any comments       */
/* concerning the use of the Sofware (e-mail : FracLab@inria.fr)     */
/*                                                                   */
/* This file is part of FracLab, a Fractal Analysis Software         */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "stable_sm.h"
#ifndef sign
#define sign(z) (z<0 ? (-1.0) : (1.0))
#endif
/****************************************************************************/

#ifndef __STDC__
void stable_root(tab, size, v, mindiff, posmin)
     double *tab;
     int size;
     double v;
     double *mindiff;
     int *posmin;
#else /* __STDC__ */
void stable_root(double *tab, int size, double v, double *mindiff, int *posmin)
#endif /* __STDC__ */
{
  int i;
  *posmin = 0;
  *mindiff = fabs(*tab-v);
  for(i=0;i<size;i++){
    if(fabs(tab[i]-v)< *mindiff){
      *mindiff = fabs(tab[i]-v);
      *posmin = i;
    }
  }
} 
/****************************************************************************/

#ifndef __STDC__
double     stable_alpha(tab, k, size)
     double *tab;
     int k;
     int size;
#else /* __STDC__ */
double     stable_alpha(double *tab, int k, int size)
#endif /* __STDC__ */
 
{
        return((double) log(2.0)/(log(tab[size-k+1])
                        - log(tab[size-2*k+1])) );

}

/*************************************************************************/
/**********************calcul des coordonn�s polaires*************************/

#ifndef __STDC__
double        stable_modu(X, Y, i)
     double *X;
     double *Y;
     int i;
#else /* __STDC__ */
double        stable_modu(double *X,double *Y,int i)
#endif /* __STDC__ */
{
        return((double) sqrt(pow(X[i],  2.0)+pow(Y[i],  2.0)));
}

                         /******************/

#ifndef __STDC__
double        stable_arg(X, Y, i)
     double *X;
     double *Y;
     int i;
#else /* __STDC__ */
double        stable_arg(double *X,double *Y,int i)
#endif /* __STDC__ */

{
  if (Y[i] >= 0)
    return((double) acos(X[i]/stable_modu(X,Y,i)));
  else
    return((double) (2.0*M_PI)-acos(X[i]/stable_modu(X,Y,i)));

}
/*************************************************************************/
#ifndef __STDC__
double  stable_mspect(X, Y, size, t, Z, k)
     double *X;
     double *Y;
     int size;
     double t;
     double *Z;
     int k;
#else /* __STDC__ */
double  stable_mspect(double *X,double *Y, int size, double t, double *Z,int k)
#endif /* __STDC__ */

{
	int        i;
	double     som=0.0;
	
	for (i = 0; i < size; i++){
	  if ((stable_arg(X,Y,i) <= t)
	      && (stable_modu(X,Y,i) >= Z[size-k+1]))
		   
	    som +=1.0 ;
		
	}
	
	return ((double) som / k);
}
/*************************************************************************/





