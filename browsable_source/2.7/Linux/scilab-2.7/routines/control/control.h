#ifndef SCI_CONTROL_F
#define SCI_CONTROL_F
extern int C2F(arl2a) _PARAMS((double *f, int *nf, double *ta, int *mxsol, int *imina, int *nall, int *inf, int *ierr, int *ilog, double *w, int *iw));
extern int C2F(arl2) _PARAMS((double *f, int *nf, double *num, double *tq, int *dgmin, int *dgmax, double *errl2, double *w, int *iw, int *inf, int *ierr, int *ilog));
extern int C2F(balanc) _PARAMS((int *nm, int *n, double *a, int *low, int *igh, double *scale));
extern int C2F(balbak) _PARAMS((int *nm, int *n, int *low, int *igh, double *scale, int *m, double *z__));
extern int C2F(bdiag) _PARAMS((int *lda, int *n, double *a, double *epsshr, double *rmax, double *er, double *ei, int *bs, double *x, double *xi, double *scale, int *job, int *fail));
extern int C2F(bezous) _PARAMS((double *a, int *n, double *c__, double *w, int *ierr));
extern int C2F(calcsc) _PARAMS((int *type__));
extern int C2F(calsca) _PARAMS((int *ns, double *ts, double *tr, double *y0, double *tg, int *ng));
extern int C2F(cbal) _PARAMS((int *nm, int *n, double *ar, double *ai, int *low, int *igh, double *scale));
extern int C2F(cerr) _PARAMS((double *a, double *w, int *ia, int *n, int *ndng, int *m, int *maxc));
extern int C2F(coef) _PARAMS((int *ierr));
extern int C2F(comqr3) _PARAMS((int *nm, int *n, int *low, int *igh, double *hr, double *hi, double *wr, double *wi, double *zr, double *zi, int *ierr, int *job));
extern int C2F(corth) _PARAMS((int *nm, int *n, int *low, int *igh, double *ar, double *ai, double *ortr, double *orti));
extern int C2F(cortr) _PARAMS((int *nm, int *n, int *low, int *igh, double *hr, double *hi, double *ortr, double *orti, double *zr, double *zi));
extern int C2F(dclmat) _PARAMS((int *ia, int *n, double *a, double *b, int *ib, double *w, double *c__, int *ndng));
extern int C2F(deg1l2) _PARAMS((double *tg, int *ng, int *imin, double *ta, int *mxsol, double *w, int *iw, int *ierr));
extern int C2F(degl2) _PARAMS((double *tg, int *ng, int *neq, int *imina, int *iminb, int *iminc, double *ta, double *tb, double *tc, int *iback, int *ntback, double *tback, int *mxsol, double *w, int *iw, int *ierr));
extern int C2F(dexpm1) _PARAMS((int *ia, int *n, double *a, double *ea, int *iea, double *w, int *iw, int *ierr));
extern int C2F(dfrmg) _PARAMS((int *job, int *na, int *nb, int *nc, int *l, int *m, int *n, double *a, double *b, double *c__, double *freqr, double *freqi, double *gr, double *gi, double *rcond, double *w, int *ipvt));
extern int C2F(dgbfa) _PARAMS((double *abd, int *lda, int *n, int *ml, int *mu, int *ipvt, int *info));
extern int C2F(dgbsl) _PARAMS((double *abd, int *lda, int *n, int *ml, int *mu, int *ipvt, double *b, int *job));
extern int C2F(dgeco) _PARAMS((double *a, int *lda, int *n, int *ipvt, double *rcond, double *z__));
extern int C2F(dgedi) _PARAMS((double *a, int *lda, int *n, int *ipvt, double *det, double *work, int *job));
extern int C2F(dgefa) _PARAMS((double *a, int *lda, int *n, int *ipvt, int *info));
extern int C2F(dgesl) _PARAMS((double *a, int *lda, int *n, int *ipvt, double *b, int *job));
extern int C2F(dhetr) _PARAMS((int *na, int *nb, int *nc, int *l, int *m, int *n, int *low, int *igh, double *a, double *b, double *c__, double *ort));
extern int C2F(dlslv) _PARAMS((double *a, int *na, int *n, double *b, int *nb, int *m, double *w, double *rcond, int *ierr, int *job));
extern int C2F(dpofa) _PARAMS((double *a, int *lda, int *n, int *info));
extern int C2F(dqrdc) _PARAMS((double *x, int *ldx, int *n, int *p, double *qraux, int *jpvt, double *work, int *job));
extern int C2F(dqrsl) _PARAMS((double *x, int *ldx, int *n, int *k, double *qraux, double *y, double *qy, double *qty, double *b, double *rsd, double *xb, int *job, int *info));
extern int C2F(dqrsm) _PARAMS((double *x, int *ldx, int *n, int *p, double *y, int *ldy, int *nc, double *b, int *ldb, int *k, int *jpvt, double *qraux, double *work));
extern int C2F(drref) _PARAMS((double *a, int *lda, int *m, int *n, double *eps));
extern int C2F(dsvdc) _PARAMS((double *x, int *ldx, int *n, int *p, double *s, double *e, double *u, int *ldu, double *v, int *ldv, double *work, int *job, int *info));
extern int C2F(dzdivq) _PARAMS((int *ichoix, int *nv, double *tv, int *nq, double *tq));
extern int C2F(ereduc) _PARAMS((double *e, int *m, int *n, double *q, double *z__, int *istair, int *ranke, double *tol));
extern int C2F(exch) _PARAMS((int *nmax, int *n, double *a, double *z__, int *l, int *ls1, int *ls2));
extern int C2F(exchqz) _PARAMS((int *nmax, int *n, double *a, double *b, double *z__, int *l, int *ls1, int *ls2, double *eps, int *fail));
extern int C2F(expan) _PARAMS((double *a, int *la, double *b, int *lb, double *c__, int *nmax));
extern int C2F(feq) _PARAMS((int *neq, double *t, double *tq, double *tqdot));
extern int C2F(feqn) _PARAMS((int *neq, double *t, double *tq, double *tqdot));
extern int C2F(feq1) _PARAMS((int *nq, double *t, double *tq, double *tg, int *ng, double *tqdot, double *tr));
extern int C2F(find) _PARAMS((int *lsize, double *alpha, double *beta, double *s, double *p));
extern int C2F(folhp) _PARAMS((int *ls, double *alpha, double *beta, double *s, double *p));
extern int C2F(fout) _PARAMS((int *lsize, double *alpha, double *beta, double *s, double *p));
extern int C2F(front) _PARAMS((int *nq, double *tq, int *nbout, double *w));
extern int C2F(fstair) _PARAMS((double *a, double *e, double *q, double *z__, int *m, int *n, int *istair, int *ranke, double *tol, int *nblcks, int *imuk, int *inuk, int *imuk0, int *inuk0, int *mnei, double *wrk, int *iwrk, int *ierr));
extern int C2F(squaek) _PARAMS((double *a, int *lda, double *e, double *q, int *ldq, double *z__, int *ldz, int *m, int *n, int *nblcks, int *inuk, int *imuk, int *mnei));
extern int C2F(triaak) _PARAMS((double *a, int *lda, double *e, double *z__, int *ldz, int *n, int *nra, int *nca, int *ifira, int *ifica));
extern int C2F(triaek) _PARAMS((double *a, int *lda, double *e, double *q, int *ldq, int *m, int *n, int *nre, int *nce, int *ifire, int *ifice, int *ifica));
extern int C2F(trired) _PARAMS((double *a, int *lda, double *e, double *q, int *ldq, double *z__, int *ldz, int *m, int *n, int *nblcks, int *inuk, int *imuk, int *ierr));
extern int C2F(bae) _PARAMS((double *a, int *lda, double *e, double *q, int *ldq, double *z__, int *ldz, int *m, int *n, int *istair, int *ifira, int *ifica, int *nca, int *rank, double *wrk, int *iwrk, double *tol));
extern int C2F(dgiv) _PARAMS((double *da, double *db, double *dc, double *ds));
extern int C2F(droti) _PARAMS((int *n, double *x, int *incx, double *y, int *incy, double *c__, double *s));
extern int C2F(fxshfr) _PARAMS((int *l2, int *nz));
extern int C2F(giv) _PARAMS((double *sa, double *sb, double *sc, double *ss));
extern int C2F(hessl2) _PARAMS((int *neq, double *tq, double *pd, int *nrowpd));
extern int C2F(hl2) _PARAMS((int *nq, double *tq, double *tg, int *ng, double *pd, int *nrowpd, double *tr, double *tp, double *tv, double *tw, double *tij, double *d1aux, double *d2aux, int *maxnv, int *maxnw));
extern int C2F(hhdml) _PARAMS((int *ktrans, int *nrowa, int *ncola, int *ioff, int *joff, int *nrowbl, int *ncolbl, double *x, int *nx, double *qraux, double *a, int *na, int *mode, int *ierr));
extern int C2F(hqror2) _PARAMS((int *nm, int *n, int *low, int *igh, double *h__, double *wr, double *wi, double *z__, int *ierr, int *job));
extern int C2F(cdiv) _PARAMS((double *ar, double *ai, double *br, double *bi, double *cr, double *ci));
extern int C2F(htribk) _PARAMS((int *nm, int *n, double *ar, double *ai, double *tau, int *m, double *zr, double *zi));
extern int C2F(htridi) _PARAMS((int *nm, int *n, double *ar, double *ai, double *d__, double *e, double *e2, double *tau));
extern int C2F(imtql3) _PARAMS((int *nm, int *n, double *d__, double *e, double *z__, int *ierr, int *job));
extern int C2F(invtpl) _PARAMS((double *t, int *n, int *m, double *tm1, int *ierr));
extern int C2F(irow1) _PARAMS((int *i__, int *m));
extern int C2F(irow2) _PARAMS((int *i__, int *m));
extern int C2F(jacl2) _PARAMS((int *neq, double *t, double *tq, int *ml, int *mu, double *pd, int *nrowpd));
extern int C2F(jacl2n) _PARAMS((int *neq, double *t, double *tq, int *ml, int *mu, double *pd, int *nrowpd));
extern int C2F(lq) _PARAMS((int *nq, double *tq, double *tr, double *tg, int *ng));
extern int C2F(lrow2) _PARAMS((int *i__, int *m));
extern int C2F(lybad) _PARAMS((int *n, double *a, int *na, double *c__, double *x, double *u, double *eps, double *wrk, int *mode, int *ierr));
extern int C2F(lybsc) _PARAMS((int *n, double *a, int *na, double *c__, double *x, double *u, double *eps, double *wrk, int *mode, int *ierr));
extern int C2F(lycsr) _PARAMS((int *n, double *a, int *na, double *c__, int *ierr));
extern int C2F(lydsr) _PARAMS((int *n, double *a, int *na, double *c__, int *ierr));
extern int C2F(modul) _PARAMS((int *neq, double *zeror, double *zeroi, double *zmod));
extern int C2F(mzdivq) _PARAMS((int *ichoix, int *nv, double *tv, int *nq, double *tq));
extern int C2F(newest) _PARAMS((int *type__, double *uu, double *vv));
extern int C2F(nextk) _PARAMS((int *type__));
extern int C2F(onface) _PARAMS((int *nq, double *tq, double *tg, int *ng, int *nprox, int *ierr, double *w));
extern int C2F(orthes) _PARAMS((int *nm, int *n, int *low, int *igh, double *a, double *ort));
extern int C2F(ortran) _PARAMS((int *nm, int *n, int *low, int *igh, double *a, double *ort, double *z__));
extern int C2F(outl2) _PARAMS((int *ifich, int *neq, int *neqbac, double *tq, double *v, double *t, double *tout));
extern int C2F(pade) _PARAMS((double *a, int *ia, int *n, double *ea, int *iea, double *alpha, double *wk, int *ipvt, int *ierr));
extern double C2F(phi) _PARAMS((double *tq, int *nq, double *tg, int *ng, double *w));
extern int C2F(polmc) _PARAMS((int *nm, int *ng, int *n, int *m, double *a, double *b, double *g, double *wr, double *wi, double *z__, int *inc, int *invr, int *ierr, int *jpvt, double *rm1, double *rm2, double *rv1, double *rv2, double *rv3, double *rv4));
extern int C2F(proj2) _PARAMS((double *f, int *nn, double *am, int *n, int *np1, int *np2, double *pf, double *w));
extern int C2F(qhesz) _PARAMS((int *nm, int *n, double *a, double *b, int *matq, double *q, int *matz, double *z__));
extern int C2F(qitz) _PARAMS((int *nm, int *n, double *a, double *b, double *eps1, int *matq, double *q, int *matz, double *z__, int *ierr));
extern int C2F(quadit) _PARAMS((double *uu, double *vv, int *nz));
extern int C2F(quadsd) _PARAMS((int *nn, double *u, double *v, double *p, double *q, double *a, double *b));
extern int C2F(qvalz) _PARAMS((int *nm, int *n, double *a, double *b, double *epsb, double *alfr, double *alfi, double *beta, int *matq, double *q, int *matz, double *z__));
extern int C2F(qvecz) _PARAMS((int *nm, int *n, double *a, double *b, double *epsb, double *alfr, double *alfi, double *beta, double *z__));
extern int C2F(qzk) _PARAMS((double *q, double *a, int *n, int *kmax, double *c__));
extern int C2F(realit) _PARAMS((double *sss, int *nz, int *iflag));
extern int C2F(reduc2) _PARAMS((int *n, int *ma, double *a, int *mb, double *b, int *low, int *igh, double *cscale, double *wk));
extern int C2F(dlald2) _PARAMS((int *ltran, double *t, int *ldt, double *b, int *ldb, double *scale, double *x, int *ldx, double *xnorm, int *info));
extern int C2F(dlaly2) _PARAMS((int *ltran, double *t, int *ldt, double *b, int *ldb, double *scale, double *x, int *ldx, double *xnorm, int *info));
extern int C2F(dlasd2) _PARAMS((int *ltranl, int *ltranr, int *isgn, int *n1, int *n2, double *tl, int *ldtl, double *tr, int *ldtr, double *b, int *ldb, double *scale, double *x, int *ldx, double *xnorm, int *info));
extern int C2F(lypcfr) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *t, int *ldt, double *u, int *ldu, double *x, int *ldx, double *scale, double *ferr, double *work, int *lwork, int *iwork, int *info, int trana_len, int uplo_len));
extern int C2F(lypcrc) _PARAMS((char *fact, char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *t, int *ldt, double *u, int *ldu, double *x, int *ldx, double *scale, double *rcond, double *work, int *lwork, int *iwork, int *info, int fact_len, int trana_len, int uplo_len));
extern int C2F(lypcsl) _PARAMS((char *fact, char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *t, int *ldt, double *u, int *ldu, double *wr, double *wi, double *x, int *ldx, double *scale, double *rcond, double *ferr, double *work, int *lwork, int *iwork, int *info, int fact_len, int trana_len, int uplo_len));
extern int C2F(lypctr) _PARAMS((char *trana, int *n, double *a, int *lda, double *c__, int *ldc, double *scale, int *info, int trana_len));
extern int C2F(lypdfr) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *t, int *ldt, double *u, int *ldu, double *x, int *ldx, double *scale, double *ferr, double *work, int *lwork, int *iwork, int *info, int trana_len, int uplo_len));
extern int C2F(lypdrc) _PARAMS((char *fact, char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *t, int *ldt, double *u, int *ldu, double *x, int *ldx, double *scale, double *rcond, double *work, int *lwork, int *iwork, int *info, int fact_len, int trana_len, int uplo_len));
extern int C2F(lypdsl) _PARAMS((char *fact, char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *t, int *ldt, double *u, int *ldu, double *wr, double *wi, double *x, int *ldx, double *scale, double *rcond, double *ferr, double *work, int *lwork, int *iwork, int *info, int fact_len, int trana_len, int uplo_len));
extern int C2F(lypdtr) _PARAMS((char *trana, int *n, double *a, int *lda, double *c__, int *ldc, double *scale, double *work, int *info, int trana_len));
extern int C2F(riccfr) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *d__, int *ldd, double *x, int *ldx, double *t, int *ldt, double *u, int *ldu, double *ferr, double *work, int *lwork, int *iwork, int *info, int trana_len, int uplo_len));
extern int C2F(riccmf) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *d__, int *ldd, double *x, int *ldx, double *wr, double *wi, double *rcond, double *ferr, double *work, int *lwork, int *iwork, int *info, int trana_len, int uplo_len));
extern int C2F(riccms) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *d__, int *ldd, double *x, int *ldx, double *wr, double *wi, double *rcond, double *ferr, double *work, int *lwork, int *iwork, int *info, int trana_len, int uplo_len));
extern int C2F(riccrc) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *d__, int *ldd, double *x, int *ldx, double *rcond, double *t, int *ldt, double *u, int *ldu, double *wr, double *wi, double *work, int *lwork, int *iwork, int *info, int trana_len, int uplo_len));
extern int C2F(riccsl) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *d__, int *ldd, double *x, int *ldx, double *wr, double *wi, double *rcond, double *ferr, double *work, int *lwork, int *iwork, int *bwork, int *info, int trana_len, int uplo_len));
extern int C2F(selneg) _PARAMS((double *wr, double *wi));
extern int C2F(ricdfr) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *x, int *ldx, double *ac, int *ldac, double *t, int *ldt, double *u, int *ldu, double *wferr, double *ferr, double *work, int *lwork, int *iwork, int *info, int trana_len, int uplo_len));
extern int C2F(ricdmf) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *d__, int *ldd, double *x, int *ldx, double *wr, double *wi, double *rcond, double *ferr, double *work, int *lwork, int *iwork, int *info, int trana_len, int uplo_len));
extern int C2F(ricdrc) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *d__, int *ldd, double *x, int *ldx, double *rcond, double *ac, int *ldac, double *t, int *ldt, double *u, int *ldu, double *wr, double *wi, double *wferr, double *work, int *lwork, int *iwork, int *info, int trana_len, int uplo_len));
extern int C2F(ricdsl) _PARAMS((char *trana, int *n, double *a, int *lda, char *uplo, double *c__, int *ldc, double *d__, int *ldd, double *x, int *ldx, double *wr, double *wi, double *rcond, double *ferr, double *work, int *lwork, int *iwork, int *bwork, int *info, int trana_len, int uplo_len));
extern int C2F(selmlo) _PARAMS((double *alphar, double *alphai, double *beta));
extern int C2F(ricd) _PARAMS((int *nf, int *nn, double *f, int *n, double *h__, double *g, double *cond, double *x, double *z__, int *nz, double *w, double *eps, int *ipvt, double *wrk1, double *wrk2, int *ierr));
extern int C2F(rilac) _PARAMS((int *n, int *nn, double *a, int *na, double *c__, double *d__, double *rcond, double *x, double *w, int *nnw, double *z__, double *eps, int *iwrk, double *wrk1, double *wrk2, int *ierr));
extern int C2F(rootgp) _PARAMS((int *ngp, double *gpp, int *nbeta, double *beta, int *ierr, double *w));
extern int C2F(rpoly) _PARAMS((double *op, int *degree, double *zeror, double *zeroi, int *fail));
extern int C2F(rtitr) _PARAMS((int *nin, int *nout, int *nu, double *num, int *inum, int *dgnum, double *den, int *iden, int *dgden, double *up, double *u, int *iu, double *yp, double *y, int *iy, int *job, int *iw, double *w, int *ierr));
extern int C2F(scaleg) _PARAMS((int *n, int *ma, double *a, int *mb, double *b, int *low, int *igh, double *cscale, double *cperm, double *wk));
extern int C2F(scapol) _PARAMS((int *na, double *a, int *nb, double *b, double *y));
extern int C2F(shrslv) _PARAMS((double *a, double *b, double *c__, int *m, int *n, int *na, int *nb, int *nc, double *eps, double *cond, double *rmax, int *fail));
extern int C2F(split) _PARAMS((double *a, double *v, int *n, int *l, double *e1, double *e2, int *na, int *nv));
extern int C2F(ssxmc) _PARAMS((int *n, int *m, double *a, int *na, double *b, int *ncont, int *indcon, int *nblk, double *z__, double *wrka, double *wrk1, double *wrk2, int *iwrk, double *tol, int *mode));
extern int C2F(sszer) _PARAMS((int *n, int *m, int *p, double *a, int *na, double *b, double *c__, int *nc, double *d__, double *eps, double *zeror, double *zeroi, int *nu, int *irank, double *af, int *naf, double *bf, int *mplusn, double *wrka, double *wrk1, int *nwrk1, double *wrk2, int *nwrk2, int *ierr));
extern int C2F(preduc) _PARAMS((double *abf, int *naf, int *mplusn, int *m, int *n, int *p, double *heps, int *iro, int *isigma, int *mu, int *nu, double *wrk1, int *nwrk1, double *wrk2, int *nwrk2));
extern int C2F(house) _PARAMS((double *wrk2, int *k, int *j, double *heps, int *zero, double *s));
extern int C2F(tr1) _PARAMS((double *a, int *na, int *n, double *u, double *s, int *i1, int *i2, int *j1, int *j2));
extern int C2F(tr2) _PARAMS((double *a, int *na, int *n, double *u, double *s, int *i1, int *i2, int *j1, int *j2));
extern int C2F(pivot) _PARAMS((double *vec, double *vmax, int *ibar, int *i1, int *i2));
extern int C2F(storl2) _PARAMS((int *neq, double *tq, double *tg, int *ng, int *imin, double *tabc, int *iback, int *ntback, double *tback, int *nch, int *mxsol, double *w, int *ierr));
/* comlen sortie_ 12 */
extern int C2F(sybad) _PARAMS((int *n, int *m, double *a, int *na, double *b, int *nb, double *c__, int *nc, double *u, double *v, double *eps, double *wrk, int *mode, int *ierr));
extern int C2F(sydsr) _PARAMS((int *n, int *m, double *a, int *na, double *b, int *nb, double *c__, int *nc, int *ierr));
extern int C2F(syhsc) _PARAMS((int *n, int *m, double *a, int *na, double *b, int *mb, double *c__, double *z__, double *eps, double *wrk1, int *nwrk1, double *wrk2, int *nwrk2, int *iwrk, int *niwrk, int *ierr));
extern int C2F(transf) _PARAMS((double *a, double *ort, int *it1, double *c__, double *v, int *it2, int *m, int *n, int *mdim, int *ndim, double *d__, int *nwrk1));
extern int C2F(nsolve) _PARAMS((double *a, double *b, double *c__, double *d__, int *nwrk1, int *ndim, int *n, int *mdim, int *m, int *ind, int *ipr, int *niwrk, double *reps, int *ierr));
extern int C2F(hesolv) _PARAMS((double *d__, int *nwrk1, int *ipr, int *niwrk, int *m, double *reps, int *ierr));
extern int C2F(backsb) _PARAMS((double *c__, double *b, int *ind, int *n, int *m, int *mdim, int *ndim));
extern int C2F(n2solv) _PARAMS((double *a, double *b, double *c__, double *d__, int *nwrk1, int *ndim, int *n, int *mdim, int *m, int *ind, int *ipr, int *niwrk, double *reps, int *ierr));
extern int C2F(h2solv) _PARAMS((double *d__, int *nwrk1, int *ipr, int *niwrk, int *m, double *reps, int *ierr));
extern int C2F(backs2) _PARAMS((double *c__, double *b, int *ind, int *n, int *m, int *mdim, int *ndim));
extern int C2F(tild) _PARAMS((int *n, double *tp, double *tpti));
extern int C2F(tql2) _PARAMS((int *nm, int *n, double *d__, double *e, double *z__, int *job, int *ierr));
extern int C2F(tred2) _PARAMS((int *nm, int *n, double *a, double *d__, double *e, double *z__));
extern int C2F(watfac) _PARAMS((int *nq, double *tq, int *nface, int *newrap, double *w));
extern int C2F(wbalin) _PARAMS((int *max__, int *n, int *low, int *igh, double *scale, double *ear, double *eai));
extern int C2F(wbdiag) _PARAMS((int *lda, int *n, double *ar, double *ai, double *rmax, double *er, double *ei, int *bs, double *xr, double *xi, double *yr, double *yi, double *scale, int *job, int *fail));
extern int C2F(wcerr) _PARAMS((double *ar, double *ai, double *w, int *ia, int *n, int *ndng, int *m, int *maxc));
extern int C2F(wclmat) _PARAMS((int *ia, int *n, double *ar, double *ai, double *br, double *bi, int *ib, double *w, double *c__, int *ndng));
extern int C2F(wdegre) _PARAMS((double *ar, double *ai, int *majo, int *nvrai));
extern int C2F(wesidu) _PARAMS((double *pr, double *pi, int *np, double *ar, double *ai, int *na, double *br, double *bi, int *nb, double *vr, double *vi, double *tol, int *ierr));
extern int C2F(wexchn) _PARAMS((double *ar, double *ai, double *vr, double *vi, int *n, int *l, int *fail, int *na, int *nv));
extern int C2F(wexpm1) _PARAMS((int *n, double *ar, double *ai, int *ia, double *ear, double *eai, int *iea, double *w, int *iw, int *ierr));
extern int C2F(wgeco) _PARAMS((double *ar, double *ai, int *lda, int *n, int *ipvt, double *rcond, double *zr, double *zi));
extern int C2F(wgedi) _PARAMS((double *ar, double *ai, int *lda, int *n, int *ipvt, double *detr, double *deti, double *workr, double *worki, int *job));
extern int C2F(wgefa) _PARAMS((double *ar, double *ai, int *lda, int *n, int *ipvt, int *info));
extern int C2F(wgesl) _PARAMS((double *ar, double *ai, int *lda, int *n, int *ipvt, double *br, double *bi, int *job));
extern int C2F(wlslv) _PARAMS((double *ar, double *ai, int *na, int *n, double *br, double *bi, int *nb, int *m, double *w, double *rcond, int *ierr, int *job));
extern int C2F(wpade) _PARAMS((double *ar, double *ai, int *ia, int *n, double *ear, double *eai, int *iea, double *alpha, double *w, int *ipvt, int *ierr));
extern int C2F(wpofa) _PARAMS((double *ar, double *ai, int *lda, int *n, int *info));
extern int C2F(wqrdc) _PARAMS((double *xr, double *xi, int *ldx, int *n, int *p, double *qrauxr, double *qrauxi, int *jpvt, double *workr, double *worki, int *job));
extern int C2F(wqrsl) _PARAMS((double *xr, double *xi, int *ldx, int *n, int *k, double *qrauxr, double *qrauxi, double *yr, double *yi, double *qyr, double *qyi, double *qtyr, double *qtyi, double *br, double *bi, double *rsdr, double *rsdi, double *xbr, double *xbi, int *job, int *info));
extern int C2F(wrref) _PARAMS((double *ar, double *ai, int *lda, int *m, int *n, double *eps));
extern int C2F(wshrsl) _PARAMS((double *ar, double *ai, double *br, double *bi, double *cr, double *ci, int *m, int *n, int *na, int *nb, int *nc, double *eps, double *rmax, int *fail));
extern int C2F(wsvdc) _PARAMS((double *xr, double *xi, int *ldx, int *n, int *p, double *sr, double *si, double *er, double *ei, double *ur, double *ui, int *ldu, double *vr, double *vi, int *ldv, double *workr, double *worki, int *job, int *info));
#endif /** SCI_   **/
