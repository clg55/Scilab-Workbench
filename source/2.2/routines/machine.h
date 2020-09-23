/* routines/machine.h.  Generated automatically by configure.  */
/* Define for using dld for sunos */
/* #undef SUNOSDLD */

/* Define if leading underscores */
/* #undef WLU */

/* Define if trailing underscores */
#define WTU 1

/* Define if use sharpsigns */
#define USE_SHARP_SIGN 1

/* Define if have exp10 */
/* #undef HAVE_EXP10 */

/* Define if have getwd */
#define HAVE_GETWD 1

/* Define  C2F and F2C entry point conversion */
#if defined(WTU)
#if defined(USE_SHARP_SIGN)
#define C2F(name) name##_
#define F2C(name) name##_
#else 
#define C2F(name) name/**/_
#define F2C(name) name/**/_
#endif
#else
#define C2F(name) name
#define F2C(name) name
#endif

/* Define some functions */

#if !defined(HAVE_EXP10)
#define exp10(x) pow((double) 10.0,x)
#endif

#if !defined(HAVE_GETWD)
#define getwd(x) getcwd(x,1024) /* you must define char x[1024] */
#endif

/* A completer pour les diverses architecture */
/* c'est important pour interfacer C et Fortran */
/* Fortran integer -> C integer */
/* avec C integer = int sur alpha */
/* avec C integer = long int sur sun 4.1.3 */

#if defined(__alpha)
typedef int integer;
#else 
typedef long int integer;
#endif
