      logical function compil(code,val1,val2,val3,val4)
c
c     add  compiled instruction in compiled macro structure
c
c     Copyright INRIA
      integer val1(*),val2,val3,val4,l
      include '../stack.h'
      integer code,sadr
c
      sadr(l)=(l/2)+1
c
      compil=.false.
      if (comp(1).eq.0) return
      compil=.true.
      l=comp(1)
      if(code.eq.1) then
c     put in stack  <1,nom>
         err=sadr(l+(nsiz+1))-lstk(bot)
         if(err.gt.0) goto 90
         istk(l)=code
         call putid(istk(l+1),val1)
         comp(1)=l+1+nsiz
      elseif(code.eq.2) then
c     get from stack  <2 nom fin rhs>
         err=sadr(l+(nsiz+3))-lstk(bot)
         if(err.gt.0) goto 90
         istk(l)=code
         call putid(istk(l+1),val1)
         istk(l+1+nsiz)=val2
         istk(l+2+nsiz)=val3
         comp(1)=l+3+nsiz
      elseif(code.eq.5) then
         err=sadr(l+4)-lstk(bot)
         if(err.gt.0) goto 90
         istk(l)=code
         istk(l+1)=val1(1)
         istk(l+2)=val2
         istk(l+3)=val3
         comp(1)=l+4
      elseif(code.eq.6) then
c     set num <6 ix(1),ix(2)>
         err=sadr(l+3)-lstk(bot)
         if(err.gt.0) goto 90
         istk(l)=code  
         istk(l+1)=val1(1)
         istk(l+2)=val1(2)
         comp(1)=l+3
      elseif(code.eq.16) then
c     set line number
         err=sadr(l+1)-lstk(bot)
         if(err.gt.0) goto 90
         istk(l)=code  
         istk(l+1)=val1(1)
         comp(1)=l+2
      elseif(code.eq.18) then
c     mark named argument
         err=sadr(l+nsiz+1)-lstk(bot)
         if(err.gt.0) goto 90
         istk(l)=code  
         call putid(istk(l+1),val1)
         comp(1)=l+nsiz+1
      elseif(code.eq.19) then
c     form recursive extraction list
         err=sadr(l+3)-lstk(bot)
         if(err.gt.0) goto 90
         istk(l)=code  
         istk(l+1)=val1(1)
         istk(l+2)=val2
         comp(1)=l+3
      elseif(code.ge.100) then
c     appel des fonctions <100*fun rhs lhs fin>
         err=sadr(l+(nsiz+3))-lstk(bot)
         if(err.gt.0) goto 90
         istk(l)=code
         istk(l+1)=val1(1)
         istk(l+2)=val2
         istk(l+3)=val3
         comp(1)=l+4
      else
c     pause :<12>
c     break :<13>
c     abort :<14>
c     seteol:<15>
c     quit  :<17>
c     exit  :<20>
c     return:<99>
         err=sadr(l+2)-lstk(bot)
         if(err.gt.0) goto 90
         istk(l)=code
         comp(1)=l+1
      endif

      return
 90   call error(17)
      return
      end

