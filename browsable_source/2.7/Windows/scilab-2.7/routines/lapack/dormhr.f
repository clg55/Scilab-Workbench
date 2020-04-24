      SUBROUTINE DORMHR( SIDE, TRANS, M, N, ILO, IHI, A, LDA, TAU, C,
     $                   LDC, WORK, LWORK, INFO )
*
*  -- LAPACK routine (version 2.0) --
*     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
*     Courant Institute, Argonne National Lab, and Rice University
*     September 30, 1994
*
*     .. Scalar Arguments ..
      CHARACTER          SIDE, TRANS
      INTEGER            IHI, ILO, INFO, LDA, LDC, LWORK, M, N
*     ..
*     .. Array Arguments ..
      DOUBLE PRECISION   A( LDA, * ), C( LDC, * ), TAU( * ),
     $                   WORK( LWORK )
*     ..
*
*  Purpose
*  =======
*
*  DORMHR overwrites the general real M-by-N matrix C with
*
*                  SIDE = 'L'     SIDE = 'R'
*  TRANS = 'N':      Q * C          C * Q
*  TRANS = 'T':      Q**T * C       C * Q**T
*
*  where Q is a real orthogonal matrix of order nq, with nq = m if
*  SIDE = 'L' and nq = n if SIDE = 'R'. Q is defined as the product of
*  IHI-ILO elementary reflectors, as returned by DGEHRD:
*
*  Q = H(ilo) H(ilo+1) . . . H(ihi-1).
*
*  Arguments
*  =========
*
*  SIDE    (input) CHARACTER*1
*          = 'L': apply Q or Q**T from the Left;
*          = 'R': apply Q or Q**T from the Right.
*
*  TRANS   (input) CHARACTER*1
*          = 'N':  No transpose, apply Q;
*          = 'T':  Transpose, apply Q**T.
*
*  M       (input) INTEGER
*          The number of rows of the matrix C. M >= 0.
*
*  N       (input) INTEGER
*          The number of columns of the matrix C. N >= 0.
*
*  ILO     (input) INTEGER
*  IHI     (input) INTEGER
*          ILO and IHI must have the same values as in the previous call
*          of DGEHRD. Q is equal to the unit matrix except in the
*          submatrix Q(ilo+1:ihi,ilo+1:ihi).
*          If SIDE = 'L', then 1 <= ILO <= IHI <= M, if M > 0, and
*          ILO = 1 and IHI = 0, if M = 0;
*          if SIDE = 'R', then 1 <= ILO <= IHI <= N, if N > 0, and
*          ILO = 1 and IHI = 0, if N = 0.
*
*  A       (input) DOUBLE PRECISION array, dimension
*                               (LDA,M) if SIDE = 'L'
*                               (LDA,N) if SIDE = 'R'
*          The vectors which define the elementary reflectors, as
*          returned by DGEHRD.
*
*  LDA     (input) INTEGER
*          The leading dimension of the array A.
*          LDA >= max(1,M) if SIDE = 'L'; LDA >= max(1,N) if SIDE = 'R'.
*
*  TAU     (input) DOUBLE PRECISION array, dimension
*                               (M-1) if SIDE = 'L'
*                               (N-1) if SIDE = 'R'
*          TAU(i) must contain the scalar factor of the elementary
*          reflector H(i), as returned by DGEHRD.
*
*  C       (input/output) DOUBLE PRECISION array, dimension (LDC,N)
*          On entry, the M-by-N matrix C.
*          On exit, C is overwritten by Q*C or Q**T*C or C*Q**T or C*Q.
*
*  LDC     (input) INTEGER
*          The leading dimension of the array C. LDC >= max(1,M).
*
*  WORK    (workspace/output) DOUBLE PRECISION array, dimension (LWORK)
*          On exit, if INFO = 0, WORK(1) returns the optimal LWORK.
*
*  LWORK   (input) INTEGER
*          The dimension of the array WORK.
*          If SIDE = 'L', LWORK >= max(1,N);
*          if SIDE = 'R', LWORK >= max(1,M).
*          For optimum performance LWORK >= N*NB if SIDE = 'L', and
*          LWORK >= M*NB if SIDE = 'R', where NB is the optimal
*          blocksize.
*
*  INFO    (output) INTEGER
*          = 0:  successful exit
*          < 0:  if INFO = -i, the i-th argument had an illegal value
*
*  =====================================================================
*
*     .. Local Scalars ..
      LOGICAL            LEFT
      INTEGER            I1, I2, IINFO, MI, NH, NI, NQ, NW
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. External Subroutines ..
      EXTERNAL           DORMQR, XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX, MIN
*     ..
*     .. Executable Statements ..
*
*     Test the input arguments
*
      INFO = 0
      LEFT = LSAME( SIDE, 'L' )
*
*     NQ is the order of Q and NW is the minimum dimension of WORK
*
      IF( LEFT ) THEN
         NQ = M
         NW = N
      ELSE
         NQ = N
         NW = M
      END IF
      IF( .NOT.LEFT .AND. .NOT.LSAME( SIDE, 'R' ) ) THEN
         INFO = -1
      ELSE IF( .NOT.LSAME( TRANS, 'N' ) .AND. .NOT.LSAME( TRANS, 'T' ) )
     $          THEN
         INFO = -2
      ELSE IF( M.LT.0 ) THEN
         INFO = -3
      ELSE IF( N.LT.0 ) THEN
         INFO = -4
      ELSE IF( ILO.LT.1 .OR. ILO.GT.MAX( 1, NQ ) ) THEN
         INFO = -5
      ELSE IF( IHI.LT.MIN( ILO, NQ ) .OR. IHI.GT.NQ ) THEN
         INFO = -6
      ELSE IF( LDA.LT.MAX( 1, NQ ) ) THEN
         INFO = -8
      ELSE IF( LDC.LT.MAX( 1, M ) ) THEN
         INFO = -11
      ELSE IF( LWORK.LT.MAX( 1, NW ) ) THEN
         INFO = -13
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'DORMHR', -INFO )
         RETURN
      END IF
*
*     Quick return if possible
*
      NH = IHI - ILO
      IF( M.EQ.0 .OR. N.EQ.0 .OR. NH.EQ.0 ) THEN
         WORK( 1 ) = 1
         RETURN
      END IF
*
      IF( LEFT ) THEN
         MI = NH
         NI = N
         I1 = ILO + 1
         I2 = 1
      ELSE
         MI = M
         NI = NH
         I1 = 1
         I2 = ILO + 1
      END IF
*
      CALL DORMQR( SIDE, TRANS, MI, NI, NH, A( ILO+1, ILO ), LDA,
     $             TAU( ILO ), C( I1, I2 ), LDC, WORK, LWORK, IINFO )
      RETURN
*
*     End of DORMHR
*
      END
