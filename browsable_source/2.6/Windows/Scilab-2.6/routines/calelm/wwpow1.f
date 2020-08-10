      subroutine wwpow1(n,vr,vi,iv,pr,pi,ip,rr,ri,ir,ierr)
c!purpose
c     computes V^P with V  and P complex vectors
c!calling sequence
c     subroutine wwpow1(n,vr,vi,iv,pr,pi,ip,rr,ri,ir,ierr)
c     integer n,iv,ip,ir,ierr
c     double precision vr(*),vi(*),pr(*),pi(*),rr(*),ri(*)
c
c     n    : number of elements of V and P vectors
c     vr    : array containing real part of V elements 
c            real(V(i))=vr(1+(i-1)*iv)
c     vi    : array containing imaginary part of V elements 
c            imag(V(i))=vi(1+(i-1)*iv)
c     iv   : increment between two V elements in v (may be 0)
c     pr   : array containing real part of P elements 
c            real(P(i))=pr(1+(i-1)*iv)
c     pi   : array containing imaginary part of P elements 
c            imag(P(i))=pi(1+(i-1)*iv)
c     ip   : increment between two P elements in p (may be 0)
c     rr   : array containing real part of the results vector R:
c            real(R(i))=rr(1+(i-1)*ir)
c     ri   : array containing imaginary part of the results vector R:
c            imag(R(i))=ri(1+(i-1)*ir)
c     ir   : increment between two R elements in rr and ri
c     ierr : error flag
c            ierr=0 if ok
c            ierr=1 if 0**0
c            ierr=2 if  0**k with k<0
c!origin
c Serge Steer INRIA 1996
c!
c     Copyright INRIA
      integer n,iv,ierr
      double precision vr(*),vi(*),pr(*),pi(*),rr(*),ri(*)
c
      ierr=0
      iscmpl=0
c

      ii=1
      iip=1
      iir=1
      do 20 i=1,n
         call wwpowe(vr(ii),vi(ii),pr(iip),pi(iip),rr(iir),ri(iir),ierr)
c         if(ierr.ne.0) return
         ii=ii+iv
         iip=iip+ip
         iir=iir+ir
 20   continue
c
      return
      end
