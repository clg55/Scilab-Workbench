      subroutine i_logic(op)
      include '../stack.h'
      integer less,great,equal
      integer op,is1
      external memused
      integer memused
      integer iadr,sadr
      data less/59/,great/60/,equal/50/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      lw=iadr(lstk(top+1))
c
      il2=iadr(lstk(top))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      l2=il2+4
      mn2=m2*n2
      top=top-1
c     
      il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      l1=il1+4
      mn1=m1*n1

      it=min(int(it1/10),int(it2/10))*10+max(mod(it1,10),mod(it2,10))

c     comparaisons
      if(m1.eq.-1) then
c     .  eye op b
         call error(43)
         return
      elseif(m2.eq.-1) then
c     . b op  eye 
         call error(43)
         return
      elseif(mn1.eq.1.and.mn2.gt.1) then
         istk(il1)=4
         istk(il1+1)=m2
         istk(il1+2)=n2

         lw=max(il1+3+memused(it,mn2),lw)
         err=sadr(lw+memused(it,mn2))-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call tpconv(it1,it,1,istk(l1),1,is1,1)
         call tpconv(it2,it,mn2,istk(l2),1,istk(lw),1)
         call gencheck(it,op,mn2,istk(l1),0,istk(l2),1,istk(il1+3))
         lstk(top+1)=sadr(il1+3+mn2)
      elseif(mn2.eq.1.and.mn1.gt.1) then
         istk(il1)=4
         lw=max(il1+3+memused(it,mn1),lw)
         err=sadr(lw+memused(it,mn1))-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call tpconv(it1,it,mn1,istk(l1),1,istk(lw),1)
         call gencheck(it,op,mn1,istk(lw),1,istk(l2),0,istk(il1+3))
         lstk(top+1)=sadr(il1+3+mn1)
      elseif(n1.ne.n2.or.m1.ne.m2) then
         if(op.eq.equal.or.op.eq.less+great) then
            istk(il1)=4
            istk(il1+1)=1
            istk(il1+2)=1
            istk(il1+3)=0
            if(op.eq.less+great) istk(il1+3)=1
            lstk(top+1)=sadr(il1+4)
         else
            call error(60)
            return
         endif
      else
         istk(il1)=4

         lw1=max(lw,il1+3+mn1)
         lw2=lw1+memused(it,mn1)
         lw=lw2+memused(it,mn2)
         err=sadr(lw)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif 
         call tpconv(it1,it,mn1,istk(l1),1,istk(lw1),1)
         call tpconv(it2,it,mn2,istk(l2),1,istk(lw2),1)
         call gencheck(it,op,mn1,istk(lw1),1,istk(lw2),1,istk(il1+3))
         lstk(top+1)=sadr(il1+3+mn1)
      endif
c
c    
      return
      end

