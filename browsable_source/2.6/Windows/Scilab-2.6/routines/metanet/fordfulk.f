      SUBROUTINE FORDFULK(N,NA,SOURCE,SINK,U,F,STARTN,ENDN,
     +PRDCSR,FIN,FOUT,NXTIN,NXTOU,LABEL,MARK,MAXFLOW,FINALIN,
     +FINALOU,IERR)
      IMPLICIT INTEGER (A-Z)
      INTEGER U(NA),F(NA),STARTN(NA),ENDN(NA),PRDCSR(N)
      INTEGER FIN(N),FOUT(N),NXTIN(NA),NXTOU(NA),LABEL(N)
      INTEGER FINALIN(N),FINALOU(N)
      LOGICAL MARK(N)
      LARGE=500000000
      IERR=1
      CALL NINIDAT(N,NA,LARGE,STARTN,ENDN,FIN,FOUT,NXTIN,NXTOU,
     +FINALIN,FINALOU)
C SET FLOWS TO ZERO
      DO 50 ARC=1,NA
        F(ARC)=0
50    CONTINUE
      CALL FORDFU1(N,NA,LARGE,SOURCE,SINK,U,F,STARTN,ENDN,
     +PRDCSR,FIN,FOUT,NXTIN,NXTOU,MARK,LABEL)
C COMPUTE MAX-FLOW 
      MAXFLOW=0
      DO 60 ARC=1,NA
        IF (STARTN(ARC).EQ.SOURCE) MAXFLOW=MAXFLOW+F(ARC)
60    CONTINUE
      MAXFLOW2=0
      DO 70 ARC=1,NA
        IF (ENDN(ARC).EQ.SINK) MAXFLOW2=MAXFLOW2+F(ARC)
70    CONTINUE
      IF (MAXFLOW.NE.MAXFLOW2) THEN
         IERR=0
      ENDIF
      RETURN
      END
C **********************************************************************
C FORD-FULKERSON METHOD FOR MAX-FLOW.
      SUBROUTINE FORDFU1(N,NA,LARGE,SOURCE,SINK,U,F,STARTN,ENDN,
     +PRDCSR,FIN,FOUT,NXTIN,NXTOU,MARK,LABEL)
      IMPLICIT INTEGER (A-Z)
      INTEGER STARTN(1),ENDN(1),U(1),F(1),FIN(1),FOUT(1)
      INTEGER NXTIN(1),NXTOU(1),PRDCSR(1),LABEL(1)
      LOGICAL MARK(1)
      NITER=0
      DO 10 I=1,N
        MARK(I)=.FALSE.
 10   CONTINUE
C START OF NEW ITERATION
 15   NLABEL=1
      NSCAN=1
      MARK(SOURCE)=.TRUE.
      LABEL(1)=SOURCE
 20   CONTINUE
C SCAN A NEW NODE  
      NODE=LABEL(NSCAN)
C SCAN OUTGOING ARCS OF NODE
      ARC=FOUT(NODE)
 30   IF (ARC.GT.0) THEN
         NODE2=ENDN(ARC)
         IF ((.NOT.MARK(NODE2)).AND.(F(ARC).LT.U(ARC))) THEN
            PRDCSR(NODE2)=ARC
            IF (NODE2.EQ.SINK) THEN
               CALL AUGMENT(N,NA,LARGE,SOURCE,SINK,U,F,STARTN,ENDN
     $              ,PRDCSR)
               NITER=NITER+1
               DO 40 I=1,NLABEL
                  MARK(LABEL(I))=.FALSE.
 40            CONTINUE
               GOTO 15
            ELSE
               MARK(NODE2)=.TRUE.
               NLABEL=NLABEL+1
               LABEL(NLABEL)=NODE2
            END IF
         END IF
         ARC=NXTOU(ARC)
         GOTO 30
      END IF
C SCAN INCOMING ARCS OF NODE
      ARC=FIN(NODE)
 50   IF (ARC.GT.0) THEN
         NODE2=STARTN(ARC)
         IF ((.NOT.MARK(NODE2)).AND.(F(ARC).GT.0)) THEN
            PRDCSR(NODE2)=-ARC
            IF (NODE2.EQ.SINK) THEN
               CALL AUGMENT(N,NA,LARGE,SOURCE,SINK,U,F,STARTN,ENDN
     $              ,PRDCSR)
               NITER=NITER+1
               DO 60 I=1,NLABEL
                  MARK(LABEL(I))=.FALSE.
 60            CONTINUE
               GOTO 15
            ELSE
               MARK(NODE2)=.TRUE.
               NLABEL=NLABEL+1
               LABEL(NLABEL)=NODE2
            END IF
         END IF
         ARC=NXTIN(ARC)
         GOTO 50
      END IF
C CHECK FOR TERMINATION; SCAN A NEW NODE
      IF (NSCAN.EQ.NLABEL) THEN
        RETURN
      END IF
      NSCAN=NSCAN+1
      GOTO 20
      END
C************************************************************************
      SUBROUTINE AUGMENT(N,NA,LARGE,SOURCE,SINK,U,F,STARTN,ENDN,PRDCSR)
      IMPLICIT INTEGER (A-Z)
      INTEGER STARTN(1),ENDN(1),U(1),F(1),PRDCSR(1)
      DX=LARGE
      CURNODE=SINK
10    IF (CURNODE.NE.SOURCE) THEN
        ARC=PRDCSR(CURNODE)
        IF (ARC.GT.0) THEN
          INCR=U(ARC)-F(ARC)
          IF (DX.GT.INCR) DX=INCR
          CURNODE=STARTN(ARC)
        ELSE
          ARC=-ARC
          INCR=F(ARC)
          IF (DX.GT.INCR) DX=INCR
          CURNODE=ENDN(ARC)
        END IF
        GOTO 10
      END IF
      
      CURNODE=SINK
20    IF (CURNODE.NE.SOURCE) THEN
        ARC=PRDCSR(CURNODE)
        IF (ARC.GT.0) THEN
          F(ARC)=F(ARC)+DX
          CURNODE=STARTN(ARC)
        ELSE
          ARC=-ARC
          F(ARC)=F(ARC)-DX
          CURNODE=ENDN(ARC)
        END IF
        GOTO 20
      END IF
      RETURN
      END
C ********************************************************************L
      SUBROUTINE NINIDAT(N,NA,LARGE,STARTN,ENDN,FIN,FOUT,NXTIN,NXTOU,
     +FINALIN,FINALOU)
C     STARTN AND ENDN USED FOR THE CONSTRUCTION OF ARRAYS FOUT, NXTOU, 
C     FIN, AND  NXTIN.  C
C         FOUT(I)    = FIRST ARC LEAVING NODE I.
C         NXTOU(J)   = NEXT ARC LEAVING THE HEAD NODE OF ARC J.
C         FIN(I)     = FIRST ARC ENTERING NODE I.
C         NXTIN(J)   = NEXT ARC ENTERING THE TAIL NODE OF ARC J.
      IMPLICIT INTEGER (A-Z)
      INTEGER STARTN(NA),ENDN(NA),FIN(N),FOUT(N)
      INTEGER NXTIN(NA),NXTOU(NA),FINALIN(N),FINALOU(N)
      DO 20 NODE=1,N
        FIN(NODE)=0
        FOUT(NODE)=0
        FINALIN(NODE)=0
        FINALOU(NODE)=0
20    CONTINUE
      DO 30 ARC=1,NA
        START=STARTN(ARC)
        END=ENDN(ARC)
        IF (FOUT(START).NE.0) THEN
          NXTOU(FINALOU(START))=ARC
        ELSE
          FOUT(START)=ARC
        END IF
        IF (FIN(END).NE.0) THEN
          NXTIN(FINALIN(END))=ARC
        ELSE
          FIN(END)=ARC
        END IF
        FINALOU(START)=ARC
        FINALIN(END)=ARC        
        NXTIN(ARC)=0
        NXTOU(ARC)=0
30    CONTINUE  
      RETURN
      END

      
      
