      subroutine bgetx(x, incr, istart)
c ======================================================================
c     macros or list externals for corr 
c ======================================================================

      INCLUDE '../stack.h'
      integer iadr,sadr
      double precision x(*)
      character*24 namex,namey
      common / corrname / namex,namey
      common / corradr  / kgxtop,kgytop,ksec,kisc
      common / corrtyp /  itxcorr,itycorr
      common/  iercorr /iero

      data mlhs/1/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     number of arguments of the external 
      mrhs=2
c     Putting Fortran arguments on Scilab stack 
c+    
      call ftob(dble(incr),1,ksec)
      call ftob(dble(istart),1,kisc)
c+    
      if(itxcorr.ne.15) then
         fin=lstk(kgxtop)
      else
         ils=iadr(lstk(kgxtop))
         nelt=istk(ils+1)
         l=sadr(ils+3+nelt)
         ils=ils+2
c     external adress 
         fin=l
c     Extra arguments in calling list that we store on the Scilab stack
         call extlarg(l,ils,nelt,mrhs)
         if (err.gt.0) goto 9999
      endif
c     Macro execution 
      pt=pt+1
      if(pt.gt.psiz) then
         call error(26)
         goto 9999
      endif
      ids(1,pt)=lhs
      ids(2,pt)=rhs
      rstk(pt)=1001
      lhs=mlhs
      rhs=mrhs
      niv=niv+1
      fun=0
c     
c     
      icall=5
      krec=18
      include '../callinter.h'
c     
 200  lhs=ids(1,pt)
      rhs=ids(2,pt)
      pt=pt-1
c+    
c     transfert des variables  de sortie vers fortran
      call btof(x,incr)
      if(err.gt.0) goto 9999
c+    
      niv=niv-1
      return
c     
 9999 continue
      iero=1
      niv=niv-1
      return
      end


