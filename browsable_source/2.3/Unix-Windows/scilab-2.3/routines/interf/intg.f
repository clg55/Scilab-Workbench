      subroutine intg
C     --------------------------------------------
c     Scilab intg 
c      implicit undefined (a-z)
      character*(4) fname
      character*6   namef
      include '../stack.h'
      integer iero 
      common/ierajf/iero
      common/cintg/namef
      external bintg,fintg
      double precision epsa,epsr,a,b,val,abserr
      logical getexternal, getscalar,type ,cremat
      integer topk,lr,katop,kydot,top2,lra,lrb,lc
      integer ipal,lpal,lw,liw,lpali,ifail
      integer iadr,sadr
      external setfintg
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      fname='intg'
      if(rhs.lt.3) then
         call error(39)
         return
      endif
      type=.false.
      top2=top
      topk=top
      if(rhs.eq.5) then
         if (.not.getscalar(fname,topk,top,lr)) return
         epsr=stk(lr)
         top=top-1
      else
         epsr=1.0d-8
      endif
      if (rhs.ge.4) then 
         if (.not.getscalar(fname,topk,top,lr)) return
         epsa=stk(lr)
         top=top-1
      else
         epsa=0.0d+0
      endif
c     cas standard
      if (.not.getexternal(fname,topk,top,namef,type,
     $     setfintg)) return
      kydot=top
      top=top-1
      if (.not.getscalar(fname,topk,top,lrb)) return
      b=stk(lrb)
      top=top-1
      katop=top
      if (.not.getscalar(fname,topk,top,lra)) return
      a=stk(lra)
c     tableaux de travail 
      top=top2+1
      lw=3000
      if (.not.cremat(fname,top,0,1,lw,lpal,lc)) return
      top=top+1
c     tableau de travail entier necessaire 
      liw=3000/8+2
      if (.not.cremat(fname,top,0,1,iadr(liw)+1,lpali,lc)) return
      top=top+1
c
c     external scilab
c
      ipal=iadr(lstk(top))
      istk(ipal)=1
      istk(ipal+1)=ipal+2
      istk(ipal+2)=kydot
      istk(ipal+3)=katop
      lstk(top+1)=sadr(ipal+4)
      if(type) then 
         call dqag0(fintg,a,b,epsa,epsr,val,abserr,
     +        stk(lpal),lw,stk(lpali),liw,ifail)
      else
         call dqag0(bintg,a,b,epsa,epsr,val,abserr,
     +        stk(lpal),lw,stk(lpali),liw,ifail)
      endif
      if(err.gt.0)return
      if(ifail.gt.0) then
         call error(24)
         return
      endif
      top=top2-rhs+1
      stk(lra)=val
      if(lhs.eq.2) then
         top=top+1
         stk(lrb)=abserr
         return
      endif
      return
      end

