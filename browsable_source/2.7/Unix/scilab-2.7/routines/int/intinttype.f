      subroutine intinttype
      include '../stack.h'
      logical checkrhs,checklhs
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if(.not.checkrhs('inttype',1,1)) return
      if(.not.checklhs('inttype',1,1)) return

      il=iadr(lstk(top))
      if(istk(il).ne.8) then
         call error(44)
         return
      endif
      is=istk(il+3)
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      l=sadr(il+4)
      stk(l)=is
      lstk(top+1)=l+1
      end
