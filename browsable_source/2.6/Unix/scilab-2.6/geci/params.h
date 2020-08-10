#ifndef PARAMS_DEF_
#define PARAMS_DEF_

#ifdef __STDC__
#ifndef  __PARAMS
#define  __PARAMS(paramlist)		paramlist
#endif
#else	
#ifndef  __PARAMS
#define  __PARAMS(paramlist)		()
#endif
#endif

#endif


