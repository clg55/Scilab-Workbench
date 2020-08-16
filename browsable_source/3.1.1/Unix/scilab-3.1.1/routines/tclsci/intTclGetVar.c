/*-----------------------------------------------------------------------------------*/
/* INRIA 2005 */
/* Allan CORNET */
/*-----------------------------------------------------------------------------------*/
#include "intTclGetVar.h"
/*-----------------------------------------------------------------------------------*/
int C2F(intTclGetVar) _PARAMS((char *fname))
{
	static int l1,n1,m1;
	int TypeVar1=GetType(1);

	CheckRhs(1,1);
	CheckLhs(1,1);
	
	if (TypeVar1 == sci_strings)
	{
		char *VarName=NULL;
		char *RetStr=NULL;

		GetRhsVar(1,"c",&m1,&n1,&l1);
		VarName=cstk(l1);

		if (TCLinterp == NULL)
		{
			Scierror(999,"TCL_GetVar : Error TCLinterp not Initialize\r\n");
			return 0;
		}

		RetStr= (char*)Tcl_GetVar(TCLinterp, VarName, TCL_GLOBAL_ONLY);

		if ( RetStr )
		{
			char *output=NULL ;
			output=(char*)malloc((strlen(RetStr)+1)*sizeof(char));
			sprintf(output,"%s",RetStr);
			CreateVarFromPtr( 1, "c",(m1=strlen(output), &m1),&n1,&output);
			
			LhsVar(1) = 1;
			C2F(putlhsvar)();

			if (output) {free(output);output=NULL;}
	  	}
		else
		{
			Scierror(999,"TCL_GetVar : Could not read Tcl Var \r\n");
			return 0;
		}
	}
	else
	{
		 Scierror(999,"TCL_GetVar : Argument type must be character string \r\n");
		 return 0;
	}
	
	return 0;
}
/*-----------------------------------------------------------------------------------*/
