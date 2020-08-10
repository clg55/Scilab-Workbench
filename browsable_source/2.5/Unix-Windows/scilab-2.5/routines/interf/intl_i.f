      subroutine intl_i
c =============================================================
c     list insertions arg3(arg1)=arg2
c =============================================================
c
c     Copyright INRIA
      include '../stack.h'
c
      integer vol1,vol2,vol3,volv
      integer top3,top2,top1

      integer strpos
      external strpos
      logical ptover
      integer id(nsiz)
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
 01   icall=0
c     handle recursion
      if(rstk(pt).eq.406.or.rstk(pt).eq.407) then
         ilrec=pstk(pt)
         il1i=istk(ilrec+1)
         ilind=istk(ilrec+2)
         icount=istk(ilrec+3)
         top1=istk(ilrec+4)
         il3i=istk(ilrec+5)
         vol3=istk(ilrec+6)
         goto(35,45,65,55) istk(ilrec)
      endif
      fun=0
c
      if (ddt .eq. 4) then
         call basout(io,wte,' intl_i')
      endif
c
 05   lw=lstk(top+1)
c
      if(rhs.ge.4) then
c     .  l(i,j,..) 
         fin=-fin
         return
      endif
      ltop=lstk(top+1)



c     get arg3
      top3=top
      il3=iadr(lstk(top))
      if(abs(istk(il3)).lt.14.or.abs(istk(il3)).gt.17) then
c     .  arg3 is not a list
         fin=-fin
         return
      endif
c
c     get arg2
      top=top-1
      top2=top
      il2=iadr(lstk(top))
      il2r=il2
      if(istk(il2).lt.0) then
         k=istk(il2+2)
         if(k.ne.0) then
            vol2=lstk(k+1)-lstk(k)
         else
            vol2=istk(il2+3)
         endif
         il2=iadr(istk(il2+1))
      else
         vol2=lstk(top+1)-lstk(top)
      endif
c
c     get arg1
      top=top-1
      top1=top
      il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)

      ilind=iadr(lw)
c
c     get room for index list
      if(istk(il1).ne.15) then
         lw=lw+1
      else
         lw=sadr(ilind+m1)
      endif
c     protect index list
      lstk(top3+1)=lw

c     go ahead along the path
      icount=0
      call followpath(top1,top3,il1ir,vol1,il3ir,vol3,
     $     istk(ilind),icount,info,lw)
      if(err.gt.0) return
      il1i=il1ir
      if(istk(il1i).lt.0) il1i=iadr(istk(il1i+1))
      il3i=il3ir
      if(istk(il3i).lt.0) il3i=iadr(istk(il3i+1))

c     get room for recursion data
      ilrec=iadr(lw)
      lw=sadr(ilrec+7)
c     protect recursion data
      lstk(top3+1)=lw

      istk(ilrec+1)=il1i
      istk(ilrec+2)=ilind
      istk(ilrec+3)=icount
      istk(ilrec+4)=top1
      istk(ilrec+5)=il3i
      istk(ilrec+6)=vol3

      if(info.eq.5.or.info.eq.6) then
c     .  end of arg1 list reached 
c     .  replace designed sublist of arg3 by arg2
         call insertfield(il2,vol2,il3,istk(ilind),icount,lrn,lw,info)
         if(err.gt.0) return
         goto 90
      elseif(info.eq.3) then
c     .  current list index is not a single index (multiple insertion)
         call error(43)
         return
      elseif(info.eq.2.or.info.eq.4) then
c     .  syntax is arg3(...)(i,j,..)(...)=arg2
c     .  matrix index (i,..) syntax
         if(istk(il3i).eq.17.or.istk(il3i).eq.16) then
            if(icount.eq.1.and.m1.eq.1) then
c     .     syntax is arg3('xxx')=arg2
               fin=-fin
               top=top3
               rhs=3
               lstk(top+1)=ltop
               return
            else
               goto 40
            endif
         else
            goto 30
         endif
      elseif(info.eq.1) then
c     .  current index is a name which is not an explicit field name
         top=top3
         rhs=3
         if(icount.eq.1.and.m1.eq.1) then
c     .     syntax is arg3('xxx')=arg2
            fin=-fin
            lstk(top+1)=ltop
            return
         else
c     .     syntax is arg3(...)('xxx')(...)=arg1
c     .     set the index
            call copyvar(il1ir,vol1)
            if(err.gt.0) return
            goto 30
         endif
      endif

 30   continue
c     last index points on a matrix, use standard matrix insertion
c     to finish 
      top=top3
      if (istk(il1i).eq.15) then
c     .  more than one index
c     .  transform index list(i,j,...) in the list in sequence of
c     .  variables at the top of the stack
         call lst2vars(il1i,m1i)
         if(err.gt.0) return
         rhs=2+m1i
      else
c     .  a matrix single  index 
c     .  copy it at the top of the stack (may possible to put a pointer)
         call copyvar(il1ir,vol1)
         if(err.gt.0) return
         rhs=3
      endif

c     create a pointer on arg2
      call createref(il2,top2,vol2)
      if(err.gt.0) return

c     create a pointer on the designed matrix (part of arg3)
      call createref(il3i,0,vol3)
      if(err.gt.0) return

c     call allops for  standard insertion
      fin=2
      if (ptover(1,psiz)) return
      
      icall=4
      istk(ilrec)=1

      pstk(pt)=ilrec
      rstk(pt)=406
c     *call* allops
      return
 35   continue
      ilv=iadr(lstk(top))
      if(istk(ilv).lt.0) then
c     .  matrix has been modified in place, nothing more to be done
         top=top-3
         pt=pt-1
         info=0
         goto 90
      else
c     .  insert the matrix in main list
         volv=lstk(top+1)-lstk(top)
         lw=lstk(top+1)
         il3=iadr(lstk(top1+2))
         call insertfield(ilv,volv,il3,istk(ilind),icount-1,lrn,lw,info)
         if(err.gt.0) return
         pt=pt-1
         top=top-3
         goto 90
      endif


 40   continue
c     mlist or tlist coded matrix insertion or other method
c     if k+1<n then
c     A3(i1)..(ik)(ik+1)(ik+2)..(in)=A2 is decomposed as follow
c     .  Temp1=A3(i1)..(ik)
c     .  Temp2=Temp1(ik+1)
c     .  Temp2(ik+2)..(in)=A2
c     .  Temp1(ik+1)=Temp2
c     .  A3(i1)..(ik)=Temp1
c     else
c     A3(i1)..(ik)(ik+1)=A2 is decomposed as follow
c     .  Temp1=A3(i1)..(ik)
c     .  Temp1(ik+1)=A2
c     .  A3(i1)..(ik)=Temp1

c     top of stack contains [A1, A2, A3]
      k=icount-1
      top=top3
c     put ik+1 in the stack for further use
      if (istk(il1i).ne.15) then
         ill=iadr(sadr(il1+3+m1)+istk(il1+1+(k+1))-1)
         call copyvar(ill,istk(il1+2+(k+1))-istk(il1+1+(k+1)))
         if(err.gt.0) return
         rhs=3
      else
c     .  more than one index
c     .  transform index list(i,j,...) in the list in sequence of
c     .  variables at the top of the stack
         call lst2vars(il1i,m1i)
         if(err.gt.0) return
         rhs=2+m1i
      endif

      if(k+1.lt.m1) then
c     put (ik+2)..(in) in the stack for further use
         ll=sadr(il1+3+m1)+istk(il1+1+(k+2))-1
         volv=istk(il1+2+m1)-istk(il1+3+k)
         if(k+2.eq.m1) then
c     il suffirait de mettre un ptr ici
            call copyvar(iadr(ll),volv)
            if(err.gt.0) return
         else
            top=top+1
            ilv=iadr(lstk(top))
            istk(ilv)=15
            istk(ilv+1)=m1-(k+1)
            istk(ilv+2)=1
            ilv=ilv+2
            do 42 i=1,m1-(k+1)
               ilv=ilv+1
               istk(ilv)=istk(ilv-1)+istk(il1+3+k+i)-istk(il1+2+k+i)
 42         continue
            call dcopy(volv,stk(ll),1,stk(sadr(ilv+1)),1)
            lstk(top+1)=sadr(ilv+1)+volv
         endif
      endif

c     put a pointer to A2 in the stack for further use
      call createref(il2,top2,vol2)
      if(err.gt.0) return

      if(k+1.eq.m1) goto 56

c     Temp2=Temp1(ik+1) extraction:

c     - form index ik+1
      if (istk(il1i).ne.15) then
         ill=iadr(sadr(il1+3+m1)+istk(il1+1+(k+1))-1)
         call copyvar(ill,istk(il1+2+(k+1))-istk(il1+1+(k+1)))
         if(err.gt.0) return
         rhs=2
      else
c     .  more than one index
c     .  transform index list(i,j,...) in the list in sequence of
c     .  variables at the top of the stack
         call lst2vars(il1i,m1i)
         if(err.gt.0) return
         rhs=1+m1i
      endif
c     - form the sublist Temp1=A3(i1)..(ik) 
      call copyvar(il3i,vol3)
      if(err.gt.0) return
c     top of stack contains [A1, A2, A3,ik+1, (ik+2)..(in),&a2,ik+1,Temp1]
c     - save context for recursion
      if (ptover(1,psiz)) return
      pstk(pt)=ilrec
      istk(ilrec)=2

      fun=0
      fin=-3
      rstk(pt)=406
c     *call* allops
      return

 45   continue
c     - top variable  contains Temp2

c     - restore context
      lw=lstk(top+1)

      k=icount-1
      il1=iadr(lstk(top1))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
c     
c     re-enter intl_i to realize Temp2(ik+2)..(in)=A2 insertion
c     top of stack contains : [A1, A2, A3,ik+1,(ik+2)..(in), &A2, Temp2]
c     
c      pt=pt-1
c      if (ptover(1,psiz)) return
c     save context for recursion
      istk(ilrec)=4
      rstk(pt)=407
      rhs=3
c     *call* intl_i
      goto 05
 55   continue

c     top variable  contains new Temp2 value
      pt=pt-1
c     put Temp1=A3(i1)..(ik)  at the top of the stack
 56   call copyvar(il3i,vol3)
      if(err.gt.0) return
c     top of stack contains : [A1, A2, A3, ik+1,Temp2,Temp1]

c     return to parser for Temp1(ik+1)=Temp2 insertion

      if (ptover(1,psiz)) return
c     save context for recursion
      pstk(pt)=ilrec
      istk(ilrec)=3
      rhs=3
      if (istk(il1i).eq.15) rhs=2+istk(il1i+1)
c     *call* intl_i
      fun=0
      fin=-2
      rstk(pt)=406
c     *call* macro or matfns
      return

 65   continue
c     top of stack contains : [A1, A2, A3, Temp1]
c     restore context
      pt=pt-1
      lw=lstk(top+1)
      k=icount-1
      if(k.eq.0) then
c     .  temp1 contains the result
         lrn=lstk(top)
         top=top-3
         info=1
         goto 90
      endif

c     
c     realize insertion A3(i1)..(ik)=Temp1
      ilv=iadr(lstk(top))
      volv=lstk(top+1)-lstk(top)
      il3=iadr(lstk(top1+2))
      call insertfield(ilv,volv,il3,istk(ilind),icount-1,lrn,lw,info)
      if(err.gt.0) return
      top=top-3
      goto 90


 90   continue

      if(info.eq.0) then
c     .  insertion has been done in place, 
         top3=top1+2
         if(rstk(pt).eq.407) then
            top=top-1
            call copyvar(il3,lstk(top3+1)-lstk(top3))
            if(err.gt.0) return
            goto 01
         else
c     .  notify that result has already been stored
            k1=istk(iadr(lstk(top3))+2)
            top=top-1
            call setref(k1)
            fin=2
            return
         endif
      elseif(info.eq.1) then
c     .  insertfield has created the result at adress lrn. stored it
         if(rstk(pt).eq.407) then
            il1=iadr(lrn)
            m=istk(il1+1)
            top=top-1
            call copyvar(il1,sadr(4+m)+(istk(il1+2+m)-1))
            if(err.gt.0) return
            goto 01
         else
c     .  set lstk pointers to the newly created variable
            
            lt=lstk(top)
            lstk(top)=lrn
            il1=iadr(lrn)
            m=istk(il1+1)
            lstk(top+1)=sadr(il1+3+m)+(istk(il1+2+m)-1)
c     .  store it
            lhs=1
            call stackp(ids(1,pt),0)

            if(err.gt.0) return
            lstk(top+1)=lt
c     .  notify that result has already been stored
            call setref(fin)
            return
         endif

      endif
c
 99   return

      end


