      subroutine intexecstr
c     Copyright INRIA/ENPC
      INCLUDE '../stack.h'
c     
      integer retu(6),comma,eol,topk
      logical eptover,getsmat,checklhs,checkrhs,checkval
      integer iadr,sadr
c
      save opened,lunit,job,icomp
c     
      data retu/27,14,29,30,27,23/,comma/52/,eol/99/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      if(rstk(pt).eq.903) goto 24


      rhs=max(0,rhs)
      topk=top

      if(.not.checklhs('execstr',0,1)) return
      if(.not.checkrhs('execstr',1,3)) return

      imess=1
      if(rhs.eq.3) then
         if(.not.getsmat('execstr',topk,top,m,n,1,1,il1,n1)) return
         if(.not.checkval('execstr',m*n,1) ) return
         l=abs(istk(il1))
         if(l.eq.22) imess=0
         top=top-1
      endif
      if(rhs.ge.2) then
         if(.not.getsmat('execstr',topk,top,m,n,1,1,il1,n1)) return
         if(.not.checkval('execstr',m*n,1) ) return
         top=top-1
         icheck=1
      else
         icheck=0
      endif
      rhs=1
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      if(istk(il).ne.10) then 
         if(istk(il).eq.1.and.istk(il+1).eq.0) then
            istk(il)=0
            lstk(top+1)=lstk(top)+1
            return
         endif
         err=1
         call error(55)
         return
      endif
      n=istk(il+1)*istk(il+2)
      l=il+5+n
      if(n.gt.1) then
c     .  add <eol> at the end of the first n-1 lines
         i1=n-1
         do 21 i=n,2,-1
            ld=l+istk(il+3+i)-1
            ln=istk(il+4+i)-istk(il+3+i)
            call icopy(ln,istk(ld),-1,istk(ld+i1),-1)
            i1=i1-1
            istk(ld+i1)=eol
            istk(il+4+i)=istk(il+4+i)+i-1
 21      continue 
      endif
c     add ",return,<eol>,<eol>" at the end of the last line
      l1=l-1+istk(l-1)
      istk(l1)=comma
      l1=l1+1
      call icopy(6,retu,1,istk(l1),1)
      l1=l1+6
      istk(l1)=comma
      l1=l1+1
      istk(l1)=eol
      l1=l1+1
      istk(l1)=eol
      istk(l-1)=istk(l-1)+10
      lstk(top+1)=sadr(l1)+1
c     
      fin=lstk(top)
      pt=pt+1
      pstk(pt)=top
      rstk(pt)=903
c     error control
      ids(2,pt)=errct
      ids(3,pt)=err2
      ids(4,pt)=err1
      ids(5,pt)=errpt
      if(icheck.eq.0) then
         ids(1,pt)=0
      else
         errpt=pt
         ids(1,pt)=1
         imode=1
c         imess=1
         num=-1
         errct=(8*imess+imode)*100000+abs(num)
         if(num.lt.0) errct=-errct
      endif
      icall=5
c     *call*  macro
      go to 999
 24   continue
      if(ids(1,pt).eq.1) then
c     return error number
         il=iadr(lstk(top))
         istk(il)=1
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         l=sadr(il+4)
         stk(l)=err1
         lstk(top+1)=l+1
         errct=ids(2,pt)
         err2=ids(3,pt)
         err1=ids(4,pt)
         fun=0
      else
         if(errct.ne.0.and.err1.gt.0) then
            top=top-1
         else
            errpt=ids(5,pt)
            il=iadr(lstk(top))
            istk(il)=0
            lstk(top+1)=lstk(top)+1
            err1=0
         endif
      endif

      pt=pt-1

      goto 999
 999  return
      end
