/****************************************************************
Copyright 1990, 1992 - 1996 by AT&T, Lucent Technologies and Bellcore.

Permission to use, copy, modify, and distribute this software
and its documentation for any purpose and without fee is hereby
granted, provided that the above copyright notice appear in all
copies and that both that the copyright notice and this
permission notice and warranty disclaimer appear in supporting
documentation, and that the names of AT&T, Bell Laboratories,
Lucent or Bellcore or any of their entities not be used in
advertising or publicity pertaining to distribution of the
software without specific, written prior permission.

AT&T, Lucent and Bellcore disclaim all warranties with regard to
this software, including all implied warranties of
merchantability and fitness.  In no event shall AT&T, Lucent or
Bellcore be liable for any special, indirect or consequential
damages or any damages whatsoever resulting from loss of use,
data or profits, whether in an action of contract, negligence or
other tortious action, arising out of or in connection with the
use or performance of this software.
****************************************************************/

#include "defs.h"
#include "output.h"
#include "names.h"
#include "iob.h"


/* Names generated by the translator are guaranteed to be unique from the
   Fortan names because Fortran does not allow underscores in identifiers,
   and all of the system generated names do have underscores.  The various
   naming conventions are outlined below:

	FORMAT		APPLICATION
   ----------------------------------------------------------------------
	io_#		temporaries generated by IO calls; these will
			contain the device number (e.g. 5, 6, 0)
	ret_val		function return value, required for complex and
			character functions.
	ret_val_len	length of the return value in character functions

	ssss_len	length of character argument "ssss"

	c_#		member of the literal pool, where # is an
			arbitrary label assigned by the system
	cs_#		short integer constant in the literal pool
	t_#		expression temporary, # is the depth of arguments
			on the stack.
	L#		label "#", given by user in the Fortran program.
			This is unique because Fortran labels are numeric
	pad_#		label on an init field required for alignment
	xxx_init	label on a common block union, if a block data
			requires a separate declaration
*/

/* generate variable references */

 char *
#ifdef KR_headers
c_type_decl(type, is_extern)
	int type;
	int is_extern;
#else
c_type_decl(int type, int is_extern)
#endif
{
    static char buff[100];

    switch (type) {
	case TYREAL:	if (!is_extern || !forcedouble)
				{ strcpy (buff, "real");break; }
	case TYDREAL:	strcpy (buff, "doublereal");	break;
	case TYCOMPLEX:	if (is_extern)
			    strcpy (buff, "/* Complex */ VOID");
			else
			    strcpy (buff, "complex");
			break;
	case TYDCOMPLEX:if (is_extern)
			    strcpy (buff, "/* Double Complex */ VOID");
			else
			    strcpy (buff, "doublecomplex");
			break;
	case TYADDR:
	case TYINT1:
	case TYSHORT:
	case TYLONG:
#ifdef TYQUAD
	case TYQUAD:
#endif
	case TYLOGICAL1:
	case TYLOGICAL2:
	case TYLOGICAL:	strcpy(buff, typename[type]);
			break;
	case TYCHAR:	if (is_extern)
			    strcpy (buff, "/* Character */ VOID");
			else
			    strcpy (buff, "char");
			break;

        case TYUNKNOWN:	strcpy (buff, "UNKNOWN");

/* If a procedure's type is unknown, assume it's a subroutine */

			if (!is_extern)
			    break;

/* Subroutines must return an INT, because they might return a label
   value.  Even if one doesn't, the caller will EXPECT it to. */

	case TYSUBR:	strcpy (buff, "/* Subroutine */ int");
							break;
	case TYERROR:	strcpy (buff, "ERROR");		break;
	case TYVOID:	strcpy (buff, "void");		break;
	case TYCILIST:	strcpy (buff, "cilist");	break;
	case TYICILIST:	strcpy (buff, "icilist");	break;
	case TYOLIST:	strcpy (buff, "olist");		break;
	case TYCLLIST:	strcpy (buff, "cllist");	break;
	case TYALIST:	strcpy (buff, "alist");		break;
	case TYINLIST:	strcpy (buff, "inlist");	break;
	case TYFTNLEN:	strcpy (buff, "ftnlen");	break;
	default:	sprintf (buff, "BAD DECL '%d'", type);
							break;
    } /* switch */

    return buff;
} /* c_type_decl */


 char *
new_func_length(Void)
{ return "ret_val_len"; }

 char *
#ifdef KR_headers
new_arg_length(arg)
	Namep arg;
#else
new_arg_length(Namep arg)
#endif
{
	static char buf[64];
	char *fmt = "%s_len", *s = arg->fvarname;
	switch(*s) {
	  case 'r':
		if (!strcmp(s+1, "et_val"))
			goto adjust_fmt;
		break;
	  case 'h':
	  case 'i':
		if (!s[1]) {
 adjust_fmt:
			fmt = "%s_length"; /* avoid conflict with libF77 */
			}
	  }
	sprintf (buf, fmt, s);
	return buf;
} /* new_arg_length */


/* declare_new_addr -- Add a new local variable to the function, given a
   pointer to an Addrblock structure (which must have the uname_tag set)
   This list of idents will be printed in reverse (i.e., chronological)
   order */

 void
#ifdef KR_headers
declare_new_addr(addrp)
	struct Addrblock *addrp;
#else
declare_new_addr(struct Addrblock *addrp)
#endif
{
    extern chainp new_vars;

    new_vars = mkchain((char *)cpexpr((expptr)addrp), new_vars);
} /* declare_new_addr */


 void
#ifdef KR_headers
wr_nv_ident_help(outfile, addrp)
	FILE *outfile;
	struct Addrblock *addrp;
#else
wr_nv_ident_help(FILE *outfile, struct Addrblock *addrp)
#endif
{
    int eltcount = 0;

    if (addrp == (struct Addrblock *) NULL)
	return;

    if (addrp -> isarray) {
	frexpr (addrp -> memoffset);
	addrp -> memoffset = ICON(0);
	eltcount = addrp -> ntempelt;
	addrp -> ntempelt = 0;
	addrp -> isarray = 0;
    } /* if */
    out_addr (outfile, addrp);
    if (eltcount)
	nice_printf (outfile, "[%d]", eltcount);
} /* wr_nv_ident_help */

 int
#ifdef KR_headers
nv_type_help(addrp)
	struct Addrblock *addrp;
#else
nv_type_help(struct Addrblock *addrp)
#endif
{
    if (addrp == (struct Addrblock *) NULL)
	return -1;

    return addrp -> vtype;
} /* nv_type_help */


/* lit_name -- returns a unique identifier for the given literal.  Make
   the label useful, when possible.  For example:

	1 -> c_1		(constant 1)
	2 -> c_2		(constant 2)
	1000 -> c_1000		(constant 1000)
	1000000 -> c_b<memno>	(big constant number)
	1.2 -> c_1_2		(constant 1.2)
	1.234345 -> c_b<memno>	(big constant number)
	-1 -> c_n1		(constant -1)
	-1.0 -> c_n1_0		(constant -1.0)
	.true. -> c_true	(constant true)
	.false. -> c_false	(constant false)
	default -> c_b<memno>	(default label)
*/

 char *
#ifdef KR_headers
lit_name(litp)
	struct Literal *litp;
#else
lit_name(struct Literal *litp)
#endif
{
	static char buf[CONST_IDENT_MAX];
	ftnint val;
	char *fmt;

	if (litp == (struct Literal *) NULL)
		return NULL;

	switch (litp -> littype) {
	case TYINT1:
		val = litp -> litval.litival;
		if (val >= 256 || val < -255)
			sprintf (buf, "ci1_b%ld", litp -> litnum);
		else if (val < 0)
			sprintf (buf, "ci1_n%ld", -val);
		else
			sprintf(buf, "ci1__%ld", val);
		break;
        case TYSHORT:
		val = litp -> litval.litival;
		if (val >= 32768 || val <= -32769)
			sprintf (buf, "cs_b%ld", litp -> litnum);
		else if (val < 0)
			sprintf (buf, "cs_n%ld", -val);
		else
			sprintf (buf, "cs__%ld", val);
		break;
	case TYLONG:
#ifdef TYQUAD
	case TYQUAD:
#endif
		val = litp -> litval.litival;
		if (val >= 100000 || val <= -10000)
			sprintf (buf, "c_b%ld", litp -> litnum);
		else if (val < 0)
			sprintf (buf, "c_n%ld", -val);
		else
			sprintf (buf, "c__%ld", val);
		break;
	case TYLOGICAL1:
		fmt = "cl1_%s";
		goto spr_logical;
	case TYLOGICAL2:
		fmt = "cl2_%s";
		goto spr_logical;
	case TYLOGICAL:
		fmt = "c_%s";
	spr_logical:
		sprintf (buf, fmt, (litp -> litval.litival
					? "true" : "false"));
		break;
	case TYREAL:
	case TYDREAL:
		/* Given a limit of 6 or 8 character on external names,	*/
		/* few f.p. values can be meaningfully encoded in the	*/
		/* constant name.  Just going with the default cb_#	*/
		/* seems to be the best course for floating-point	*/
		/* constants.	*/
	case TYCHAR:
		/* Shouldn't be any of these */
	case TYADDR:
	case TYCOMPLEX:
	case TYDCOMPLEX:
	case TYSUBR:
	default:
		sprintf (buf, "c_b%ld", litp -> litnum);
    } /* switch */
    return buf;
} /* lit_name */



 char *
#ifdef KR_headers
comm_union_name(count)
	int count;
#else
comm_union_name(int count)
#endif
{
	static char buf[12];

	sprintf(buf, "%d", count);
	return buf;
	}




/* wr_globals -- after every function has been translated, we need to
   output the global declarations, such as the static table of constant
   values */

 void
#ifdef KR_headers
wr_globals(outfile)
	FILE *outfile;
#else
wr_globals(FILE *outfile)
#endif
{
    struct Literal *litp, *lastlit;
    extern int hsize;
    char *litname;
    int did_one, t;
    struct Constblock cb;
    ftnint x, y;

    if (nliterals == 0)
	return;

    lastlit = litpool + nliterals;
    did_one = 0;
    for (litp = litpool; litp < lastlit; litp++) {
	if (!litp->lituse)
		continue;
	litname = lit_name(litp);
	if (!did_one) {
		margin_printf(outfile, "/* Table of constant values */\n\n");
		did_one = 1;
		}
	cb.vtype = litp->littype;
	if (litp->littype == TYCHAR) {
		x = litp->litval.litival2[0] + litp->litval.litival2[1];
		if (y = x % hsize)
			x += y = hsize - y;
		nice_printf(outfile,
			"static struct { %s fill; char val[%ld+1];", halign, x);
		nice_printf(outfile, " char fill2[%ld];", hsize - 1);
		nice_printf(outfile, " } %s_st = { 0,", litname);
		cb.vleng = ICON(litp->litval.litival2[0]);
		cb.Const.ccp = litp->cds[0];
		cb.Const.ccp1.blanks = litp->litval.litival2[1] + y;
		cb.vtype = TYCHAR;
		out_const(outfile, &cb);
		frexpr(cb.vleng);
		nice_printf(outfile, " };\n");
		nice_printf(outfile, "#define %s %s_st.val\n", litname, litname);
		continue;
		}
	nice_printf(outfile, "static %s %s = ",
		c_type_decl(litp->littype,0), litname);

	t = litp->littype;
	if (ONEOF(t, MSKREAL|MSKCOMPLEX)) {
		cb.vstg = 1;
		cb.Const.cds[0] = litp->cds[0];
		cb.Const.cds[1] = litp->cds[1];
		}
	else {
		memcpy((char *)&cb.Const, (char *)&litp->litval,
			sizeof(cb.Const));
		cb.vstg = 0;
		}
	out_const(outfile, &cb);

	nice_printf (outfile, ";\n");
    } /* for */
    if (did_one)
    	nice_printf (outfile, "\n");
} /* wr_globals */

 ftnint
#ifdef KR_headers
commlen(vl)
	register chainp vl;
#else
commlen(register chainp vl)
#endif
{
	ftnint size;
	int type;
	struct Dimblock *t;
	Namep v;

	while(vl->nextp)
		vl = vl->nextp;
	v = (Namep)vl->datap;
	type = v->vtype;
	if (type == TYCHAR)
		size = v->vleng->constblock.Const.ci;
	else
		size = typesize[type];
	if ((t = v->vdim) && ISCONST(t->nelt))
		size *= t->nelt->constblock.Const.ci;
	return size + v->voffset;
	}

 static void	/* Pad common block if an EQUIVALENCE extended it. */
#ifdef KR_headers
pad_common(c)
	Extsym *c;
#else
pad_common(Extsym *c)
#endif
{
	register chainp cvl;
	register Namep v;
	long L = c->maxleng;
	int type;
	struct Dimblock *t;
	int szshort = typesize[TYSHORT];

	for(cvl = c->allextp; cvl; cvl = cvl->nextp)
		if (commlen((chainp)cvl->datap) >= L)
			return;
	v = ALLOC(Nameblock);
	v->vtype = type = L % szshort ? TYCHAR
				      : type_choice[L/szshort % 4];
	v->vstg = STGCOMMON;
	v->vclass = CLVAR;
	v->tag = TNAME;
	v->vdim = t = ALLOC(Dimblock);
	t->ndim = 1;
	t->dims[0].dimsize = ICON(L / typesize[type]);
	v->fvarname = v->cvarname = "eqv_pad";
	if (type == TYCHAR)
		v->vleng = ICON(1);
	c->allextp = mkchain((char *)mkchain((char *)v, CHNULL), c->allextp);
	}


/* wr_common_decls -- outputs the common declarations in one of three
   formats.  If all references to a common block look the same (field
   names and types agree), only one actual declaration will appear.
   Otherwise, the same block will require many structs.  If there is no
   block data, these structs will be union'ed together (so the linker
   knows the size of the largest one).  If there IS a block data, only
   that version will be associated with the variable, others will only be
   defined as types, so the pointer can be cast to it.  e.g.

	FORTRAN				C
----------------------------------------------------------------------
	common /com1/ a, b, c		struct { real a, b, c; } com1_;

	common /com1/ a, b, c		union {
	common /com1/ i, j, k		    struct { real a, b, c; } _1;
					    struct { integer i, j, k; } _2;
					} com1_;

	common /com1/ a, b, c		struct com1_1_ { real a, b, c; };
	block data			struct { integer i, j, k; } com1_ =
	common /com1/ i, j, k		  { 1, 2, 3 };
	data i/1/, j/2/, k/3/


   All of these versions will be followed by #defines, since the code in
   the function bodies can't know ahead of time which of these options
   will be taken */

/* Macros for deciding the output type */

#define ONE_STRUCT 1
#define UNION_STRUCT 2
#define INIT_STRUCT 3

 void
#ifdef KR_headers
wr_common_decls(outfile)
	FILE *outfile;
#else
wr_common_decls(FILE *outfile)
#endif
{
    Extsym *ext;
    extern int extcomm;
    static char *Extern[4] = {"", "Extern ", "extern "};
    char *E, *E0 = Extern[extcomm];
    int did_one = 0;

    for (ext = extsymtab; ext < nextext; ext++) {
	if (ext -> extstg == STGCOMMON && ext->allextp) {
	    chainp comm;
	    int count = 1;
	    int which;			/* which display to use;
					   ONE_STRUCT, UNION or INIT */

	    if (!did_one)
		nice_printf (outfile, "/* Common Block Declarations */\n\n");

	    pad_common(ext);

/* Construct the proper, condensed list of structs; eliminate duplicates
   from the initial list   ext -> allextp   */

	    comm = ext->allextp = revchain(ext->allextp);

	    if (ext -> extinit)
		which = INIT_STRUCT;
	    else if (comm->nextp) {
		which = UNION_STRUCT;
		nice_printf (outfile, "%sunion {\n", E0);
		next_tab (outfile);
		E = "";
		}
	    else {
		which = ONE_STRUCT;
		E = E0;
		}

	    for (; comm; comm = comm -> nextp, count++) {

		if (which == INIT_STRUCT)
		    nice_printf (outfile, "struct %s%d_ {\n",
			    ext->cextname, count);
		else
		  {
		    /** jpc 1998 **/
		    if ( strcmp(ext->cextname,"stack_")==0 || 
			 strcmp(ext->cextname,"vstk_")==0 || 
			 strcmp(ext->cextname,"recu_")==0 || 
			 strcmp(ext->cextname,"iop_")==0 || 
			 strcmp(ext->cextname,"errgst_")==0  ||
			 strcmp(ext->cextname,"com_")==0 ||
			 strcmp(ext->cextname,"adre_")==0 ||
			 strcmp(ext->cextname,"intersci_")==0 ||
			 strcmp(ext->cextname,"cha1_")==0 
			 )
		      nice_printf (outfile, "IMPORT struct {\n");
		    else
		      nice_printf (outfile, "%sstruct {\n", E);
		  }
		next_tab (c_file);

		wr_struct (outfile, (chainp) comm -> datap);

		prev_tab (c_file);
		if (which == UNION_STRUCT)
		    nice_printf (outfile, "} _%d;\n", count);
		else if (which == ONE_STRUCT)
		    nice_printf (outfile, "} %s;\n", ext->cextname);
		else
		    nice_printf (outfile, "};\n");
	    } /* for */

	    if (which == UNION_STRUCT) {
		prev_tab (c_file);
		nice_printf (outfile, "} %s;\n", ext->cextname);
	    } /* if */
	    did_one = 1;
	    nice_printf (outfile, "\n");

	    for (count = 1, comm = ext -> allextp; comm;
		    comm = comm -> nextp, count++) {
		def_start(outfile, ext->cextname,
			comm_union_name(count), "");
		switch (which) {
		    case ONE_STRUCT:
		        extern_out (outfile, ext);
		        break;
		    case UNION_STRUCT:
		        nice_printf (outfile, "(");
			extern_out (outfile, ext);
			nice_printf(outfile, "._%d)", count);
		        break;
		    case INIT_STRUCT:
			nice_printf (outfile, "(*(struct ");
			extern_out (outfile, ext);
			nice_printf (outfile, "%d_ *) &", count);
			extern_out (outfile, ext);
			nice_printf (outfile, ")");
		        break;
		} /* switch */
		nice_printf (outfile, "\n");
	    } /* for count = 1, comm = ext -> allextp */
	    nice_printf (outfile, "\n");
	} /* if ext -> extstg == STGCOMMON */
    } /* for ext = extsymtab */
} /* wr_common_decls */

 void
#ifdef KR_headers
wr_struct(outfile, var_list)
	FILE *outfile;
	chainp var_list;
#else
wr_struct(FILE *outfile, chainp var_list)
#endif
{
    int last_type = -1;
    int did_one = 0;
    chainp this_var;

    for (this_var = var_list; this_var; this_var = this_var -> nextp) {
	Namep var = (Namep) this_var -> datap;
	int type;
	char *comment = NULL;

	if (var == (Namep) NULL)
	    err ("wr_struct:  null variable");
	else if (var -> tag != TNAME)
	    erri ("wr_struct:  bad tag on variable '%d'",
		    var -> tag);

	type = var -> vtype;

	if (last_type == type && did_one)
	    nice_printf (outfile, ", ");
	else {
	    if (did_one)
		nice_printf (outfile, ";\n");
	    nice_printf (outfile, "%s ",
		    c_type_decl (type, var -> vclass == CLPROC));
	} /* else */

/* Character type is really a string type.  Put out a '*' for parameters
   with unknown length and functions returning character */

	if (var -> vtype == TYCHAR && (!ISICON ((var -> vleng))
		|| var -> vclass == CLPROC))
	    nice_printf (outfile, "*");

	var -> vstg = STGAUTO;
	out_name (outfile, var);
	if (var -> vclass == CLPROC)
	    nice_printf (outfile, "()");
	else if (var -> vdim)
	    comment = wr_ardecls(outfile, var->vdim,
				var->vtype == TYCHAR && ISICON(var->vleng)
				? var->vleng->constblock.Const.ci : 1L);
	else if (var -> vtype == TYCHAR && var -> vclass != CLPROC &&
	    ISICON ((var -> vleng)))
	    nice_printf (outfile, "[%ld]",
		    var -> vleng -> constblock.Const.ci);

	if (comment)
	    nice_printf (outfile, "%s", comment);
	did_one = 1;
	last_type = type;
    } /* for this_var */

    if (did_one)
	nice_printf (outfile, ";\n");
} /* wr_struct */


 char *
#ifdef KR_headers
user_label(stateno)
	ftnint stateno;
#else
user_label(ftnint stateno)
#endif
{
	static char buf[USER_LABEL_MAX + 1];
	static char *Lfmt[2] = { "L_%ld", "L%ld" };

	if (stateno >= 0)
		sprintf(buf, Lfmt[shiftcase], stateno);
	else
		sprintf(buf, "L_%s", extsymtab[-1-stateno].fextname);
	return buf;
} /* user_label */


 char *
#ifdef KR_headers
temp_name(starter, num, storage)
	char *starter;
	int num;
	char *storage;
#else
temp_name(char *starter, int num, char *storage)
#endif
{
    static char buf[IDENT_LEN];
    char *pointer = buf;
    char *prefix = "t";

    if (storage)
	pointer = storage;

    if (starter && *starter)
	prefix = starter;

    sprintf (pointer, "%s__%d", prefix, num);
    return pointer;
} /* temp_name */


 char *
#ifdef KR_headers
equiv_name(memno, store)
	int memno;
	char *store;
#else
equiv_name(int memno, char *store)
#endif
{
    static char buf[IDENT_LEN];
    char *pointer = buf;

    if (store)
	pointer = store;

    sprintf (pointer, "%s_%d", EQUIV_INIT_NAME, memno);
    return pointer;
} /* equiv_name */

 void
#ifdef KR_headers
def_commons(of)
	FILE *of;
#else
def_commons(FILE *of)
#endif
{
	Extsym *ext;
	int c, onefile, Union;
	chainp comm;
	extern int ext1comm;
	FILE *c_filesave = c_file;

	if (ext1comm == 1) {
		onefile = 1;
		c_file = of;
		fprintf(of, "/*>>>'/dev/null'<<<*/\n\
#ifdef Define_COMMONs\n\
/*<<</dev/null>>>*/\n");
		}
	else
		onefile = 0;
	for(ext = extsymtab; ext < nextext; ext++)
		if (ext->extstg == STGCOMMON
		&& !ext->extinit && (comm = ext->allextp)) {
			sprintf(outbtail, "%scom.c", ext->cextname);
			if (onefile)
				fprintf(of, "/*>>>'%s'<<<*/\n",
					outbtail);
			else {
				c_file = of = fopen(outbuf,textwrite);
				if (!of)
					fatalstr("can't open %s", outbuf);
				}
			fprintf(of, "#include \"f2c.h\"\n");
			if (Ansi == 2)
				fprintf(of,
			 "\n#ifdef __cplusplus\nextern \"C\" {\n#endif\n\n");
			if (comm->nextp) {
				Union = 1;
				nice_printf(of, "union {\n");
				next_tab(of);
				}
			else
				Union = 0;
			for(c = 1; comm; comm = comm->nextp) {
				nice_printf(of, "struct {\n");
				next_tab(of);
				wr_struct(of, (chainp)comm->datap);
				prev_tab(of);
				if (Union)
					nice_printf(of, "} _%d;\n", c++);
				}
			if (Union)
				prev_tab(of);
			nice_printf(of, "} %s;\n", ext->cextname);
			if (Ansi == 2)
				fprintf(of,
			 "\n#ifdef __cplusplus\n}\n#endif\n");
			if (onefile)
				fprintf(of, "/*<<<%s>>>*/\n", outbtail);
			else
				fclose(of);
			}
	if (onefile)
		fprintf(of, "/*>>>'/dev/null'<<<*/\n#endif\n\
/*<<</dev/null>>>*/\n");
	c_file = c_filesave;
	}

/* C Language keywords.  Needed to filter unwanted fortran identifiers like
 * "int", etc.  Source:  Kernighan & Ritchie, eds. 1 and 2; Stroustrup.
 * Also includes C++ keywords and types used for I/O in f2c.h .
 * These keywords must be in alphabetical order (as defined by strcmp()).
 */

char *c_keywords[] = {
	"Long", "Multitype", "Namelist", "Vardesc", "abs", "acos",
	"addr", "address", "aerr", "alist", "asin", "asm", "atan",
	"atan2", "aunit", "auto", "break", "c", "case", "catch", "cerr",
	"char", "ciend", "cierr", "cifmt", "cilist", "cirec", "ciunit",
	"class", "cllist", "complex", "const", "continue", "cos",
	"cosh", "csta", "cunit", "d", "dabs", "default", "defined",
	"delete", "dims", "dmax", "dmin", "do", "double",
	"doublecomplex", "doublereal", "else", "entry", "enum", "exp",
	"extern", "far", "flag", "float", "for", "friend", "ftnint",
	"ftnlen", "goto", "h", "huge", "i", "iciend", "icierr",
	"icifmt", "icilist", "icirlen", "icirnum", "iciunit", "if",
	"inacc", "inacclen", "inblank", "inblanklen", "include",
	"indir", "indirlen", "inerr", "inex", "infile", "infilen",
	"infmt", "infmtlen", "inform", "informlen", "inline", "inlist",
	"inname", "innamed", "innamlen", "innrec", "innum", "inopen",
	"inrecl", "inseq", "inseqlen", "int", "integer", "integer1",
	"inunf", "inunflen", "inunit", "log", "logical", "logical1",
	"long", "longint", "max", "min", "name", "near", "new", "nvars",
	"oacc", "oblnk", "oerr", "ofm", "ofnm", "ofnmlen", "olist",
	"operator", "orl", "osta", "ounit", "overload", "private",
	"protected", "public", "r", "real", "register", "return",
	"short", "shortint", "shortlogical", "signed", "sin", "sinh",
	"sizeof", "sqrt", "static", "struct", "switch", "tan", "tanh",
	"template", "this", "try", "type", "typedef", "uinteger",
	"ulongint", "union", "unsigned", "vars", "virtual", "void",
	"volatile", "while", "z"
	}; /* c_keywords */

int n_keywords = sizeof(c_keywords)/sizeof(char *);
