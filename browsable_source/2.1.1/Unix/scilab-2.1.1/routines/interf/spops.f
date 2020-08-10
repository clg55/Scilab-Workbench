      subroutine spops
c     
c     operations on sparse matrices
c     
      include '../stack.h'
      integer op
c     
      integer iadr,sadr
c     
      double precision sr,si,e1,powr,powi
      integer plus,minus,star,dstar,slash,bslash,dot,colon,concat
      integer quote,extrac,insert,less,great,equal,ou,et,non
      integer top0
      data plus/45/,minus/46/,star/47/,dstar/62/,slash/48/
      data bslash/49/,dot/51/,colon/44/,concat/1/,quote/53/
      data extrac/3/,insert/2/,less/59/,great/60/,equal/50/
      data ou/57/,et/58/,non/61/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      op=fin
c     
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' spops op: '//buf(1:4))
      endif
c     
      top0=top
      lw=lstk(top+1)+1
      it2=0
      goto (04,03,02,01) rhs
      call error(39)
      return
c     
 01   il4=iadr(lstk(top))
      if(istk(il4).lt.0) il4=iadr(istk(il4+1))
      m4=istk(il4+1)
      n4=istk(il4+2)
      it4=istk(il4+3)
      if(istk(il4).eq.5) then
         nel4=istk(il4+4)
         irc4=il4+5
         l4=sadr(irc4+m4+nel4)
      elseif(istk(il4).eq.1) then
         nel4=m4*n4
         l4=sadr(il4+4)
      else
         top=top0
         fin=-fin
         return
      endif
      mn4=m4*n4
      top=top-1
c     
 02   il3=iadr(lstk(top))
      if(istk(il3).lt.0) il3=iadr(istk(il3+1))
      m3=istk(il3+1)
      n3=istk(il3+2)
      it3=istk(il3+3)
      if(istk(il3).eq.5) then
         nel3=istk(il3+4)
         irc3=il3+5
         l3=sadr(irc3+m3+nel3)
      elseif(istk(il3).eq.1) then
         l3=sadr(il3+4)
         nel3=m3*n3
      else
         top=top0
         fin=-fin
         return
      endif
      mn3=m3*n3
      top=top-1
c     
 03   il2=iadr(lstk(top))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      if(istk(il2).eq.5) then
         nel2=istk(il2+4)
         irc2=il2+5
         l2=sadr(irc2+m2+nel2)
      elseif(istk(il2).eq.1) then
         l2=sadr(il2+4)
         nel2=m2*n2
      else
         top=top0
         fin=-fin
         return
      endif
      mn2=m2*n2
      top=top-1
c     
 04   il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      if(istk(il1).eq.5) then
         nel1=istk(il1+4)
         irc1=il1+5
         l1=sadr(irc1+m1+nel1)
      elseif(istk(il1).eq.1) then
         l1=sadr(il1+4)
         nel1=m1*n1
      else
         top=top0
         fin=-fin
         return
      endif
      mn1=m1*n1
      top=top-1
c     
c     operations binaires et ternaires
c     --------------------------------
c     
      top=top+1
      itr=max(it1,it2)
c     
      fun = 0
c     
c     cconc  extrac insert rconc
      goto(75  ,  85  ,  80   ,78) op
c     
c           :  +  -  * /  \  =          '
      goto(06,07,08,10,20,25,130,05,05,70) op+1-colon
c     
 05   if(op.eq.dstar) goto 30
      if(op.ge.3*dot+star) goto 65
      if(op.ge.2*dot+star) goto 120
      if(op.ge.less+equal) goto 130
      if(op.ge.dot+star) goto 55
      if(op.ge.less) goto 130

 06   call error(43)
      return

c     
c     addition
 07   continue

c       []+a
      if (mn1.eq.0) then
         call icopy(5+m2+nel2,istk(il2),1,istk(il1),1)
         l1=sadr(il1+5+m2+nel2)
         call dcopy(nel2*(it2+1),stk(l2),1,stk(l1),1)
         lstk(top+1)=l1+nel2*(it2+1)
         goto 999
      elseif(mn2.eq.0) then
c     a+[]
         goto 999
      endif
      if (m1 .lt. 0) then
c     eye+a
         top=top0
         fin=-fin
         return
      endif
      if (m2 .lt. 0) then
c     a+eye
         top=top0
         fin=-fin
         return
      endif
      if (mn2.eq.1.and.mn1.gt.1) then
c        a+cst
         top=top0
         fin=-fin
         return
      endif
      if (mn1.eq.1.and.mn2.gt.1) then
c        cst+a
         top=top0
         fin=-fin
         return
      endif
      if (m1 .ne. m2.or.n1 .ne. n2) then
         call error(8)
         return
      endif
      if(istk(il1).ne.5.or.istk(il2).ne.5) then
c     addition avec une matrice non creuse
         top=top0
         fin=-fin
         return
      endif
 171  irc=iadr(lw)
      if(itr.eq.1) then
         nelmx=(iadr(lstk(bot))-irc-m1-10)/5
      else
         nelmx=(iadr(lstk(bot))-irc-m1-10)/3
      endif
      lc=sadr(irc+m1+nelmx)
      lw=lc+nelmx*(itr+1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif  
      nel=nelmx
      if(itr.eq.1) then
         call wspasp(m1,n1,stk(l1),stk(l1+nel1),nel1,istk(irc1),
     $        stk(l2),stk(l2+nel2),nel2,istk(irc2),stk(lc),stk(lc+nel),
     $        nel,istk(irc),it1,it2,ierr)
      else
         call dspasp(m1,n1,stk(l1),nel1,istk(irc1),stk(l2),nel2,
     $        istk(irc2),stk(lc),nel,istk(irc),ierr)
      endif
      if(ierr.ne.0) then
         call error(17)
         return
      endif
      istk(il1+3)=itr
      istk(il1+4)=nel
      call icopy(m1+nel,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+m1+nel)
      call dcopy(nel,stk(lc),1,stk(l1),1)
      if(itr.eq.1) call dcopy(nel,stk(lc+nelmx),1,stk(l1+nel),1)
      lstk(top+1)=l1+nel*(itr+1)
      go to 999
c     
c     soustraction
 08   if(rhs.eq.2) goto 09
      if(mn1.le.0) goto 999
      call dscal(nel1*(it1+1),-1.0d+0,stk(l1),1)
      goto 999
 09   continue
      if (mn1.eq.0) then
c        []-a
         call icopy(5+m2+nel2,istk(il2),1,istk(il1),1)
         l1=sadr(il1+5+m2+nel2)
         call dscal(nel2*(it2+1),-1.0d0,stk(l1),1)
         call dcopy(nel2*(it2+1),stk(l2),1,stk(l1),1)
         lstk(top+1)=l1+nel2*(it2+1)
         goto 999
      elseif(mn2.eq.0) then
c         a-[]
         goto 999
      endif
      if (m1 .lt. 0.or.m2 .lt. 0) then
c     soustraction a-eye*b
         top=top0
         fin=-fin
         return
      endif

      if (mn2.eq.1.and.mn1.gt.1) then
c        a-cst
         top=top0
         fin=-fin
         return
      endif
      if (mn1.eq.1.and.mn2.gt.1) then
c        cst-a
         top=top0
         fin=-fin
         return
      endif

c       check dimensions
      if (m1 .ne. m2.or.n1 .ne. n2) then
         call error(9)
         return
      endif
      if(istk(il1).ne.5.or.istk(il2).ne.5) then
c     soustraction avec une matrice non creuse
         top=top0
         fin=-fin
         return
      endif
      irc=iadr(lw)
      if(itr.eq.1) then
         nelmx=(iadr(lstk(bot))-irc-m1-10)/5
      else
         nelmx=(iadr(lstk(bot))-irc-m1-10)/3
      endif
      lc=sadr(irc+m1+nelmx)
      lw=lc+nelmx*(itr+1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif  
      nel=nelmx
      if(itr.eq.1) then
         call wspssp(m1,n1,stk(l1),stk(l1+nel1),nel1,istk(irc1),
     $        stk(l2),stk(l2+nel2),nel2,istk(irc2),stk(lc),stk(lc+nel),
     $        nel,istk(irc),it1,it2,ierr)
      else
         call dspssp(m1,n1,stk(l1),nel1,istk(irc1),stk(l2),nel2,
     $        istk(irc2),stk(lc),nel,istk(irc),ierr)
      endif
      if(ierr.ne.0) then
         call error(17)
         return
      endif
      istk(il1+3)=itr
      istk(il1+4)=nel
      call icopy(m1+nel,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+m1+nel)
      call dcopy(nel,stk(lc),1,stk(l1),1)
      if(itr.eq.1) call dcopy(nel,stk(lc+nelmx),1,stk(l1+nel),1)
      lstk(top+1)=l1+nel*(itr+1)
      go to 999

c     multiplication
 10   continue
      if (m2*mn2 .eq. 1) go to 12
      if (mn1 .eq. 1 ) go to 13
      if (mn2 .eq. 1 ) go to 12
      m1=abs(m1)
      n1=abs(n1)
      m2=abs(m2)
      n2=abs(n2)
      if(mn1.eq.0.or.mn2.eq.0) then
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         istk(il1+3)=0
         lstk(top+1)=sadr(il1+4)+1
         goto 999
      endif
      if (n1 .ne. m2) then
         call error(10)
         return
      endif
c     
      if(istk(il1).eq.1.or.istk(il2).eq.1) then
c     full x sparse or sparse x full
         lc=lw
         lw=lw+m1*n2*(itr+1)
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         if(istk(il1).eq.1) then
c     full x sparse
            if(itr.eq.1) then
               call wsmsp(m1,n1,n2,stk(l1),stk(l1+m1*n1),m1,
     $              stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $              stk(lc),stk(lc+m1*n2),m1,it1,it2)
            else
               call dsmsp(m1,n1,n2,stk(l1),m1,stk(l2),nel2,
     $              istk(irc2),stk(lc),m1)
            endif
         else
c     sparse x full
            if(itr.eq.1) then
               call wspms(m1,n1,n2,stk(l1),stk(l1+nel1),nel1,istk(irc1),
     $              stk(l2),stk(l2+m2*n2),m2,stk(lc),stk(lc+m1*n2),m1,
     $              it1,it2)
            else
               call dspms(m1,n1,n2,stk(l1),nel1,istk(irc1),
     $              stk(l2),m2,stk(lc),m1)
            endif
         endif
         istk(il1)=1
         istk(il1+1)=m1
         istk(il1+2)=n2
         istk(il1+3)=itr
         l1=sadr(il1+4)
         call dcopy(m1*n2*(itr+1),stk(lc),1,stk(l1),1)
         lstk(top+1)=l1+m1*n2*(itr+1)
         return
      endif
      ib=iadr(lw)
      ic=ib+m2+1
      ixb=ic+m1+1
      lx=sadr(ixb+n2)
      lc=lx+n2*(itr+1)
      nel=(iadr(lstk(bot))-iadr(lc)-m1-10)/(1+2*(itr+1))
      irc=iadr(lc+nel*(itr+1))
      lw=sadr(irc+m1+nel)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      nelc=nel
      if(itr.eq.1) then
         call wspmsp(m1,n1,n2,stk(l1),stk(l1+nel1),nel1,istk(irc1),
     $        stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $        stk(lc),stk(lc+nel),nelc,istk(irc),
     $        istk(ib),istk(ic),stk(lx),stk(lx+n2),istk(ixb),
     $        it1,it2,ierr)
      else
         call dspmsp(m1,n1,n2,stk(l1),nel1,istk(irc1),
     $        stk(l2),nel2,istk(irc2),stk(lc),nelc,istk(irc),
     $        istk(ib),istk(ic),stk(lx),istk(ixb),ierr)
      endif
      if(ierr.eq.1) then
         buf='not enough memory'
         call error(9999)
         return
      endif
      istk(il1+2)=n2
      istk(il1+3)=itr
      istk(il1+4)=nelc
      call icopy(nelc+m1,istk(irc),1,istk(il1+5),1)
      l1=sadr(il1+5+m1+nelc)
      call dcopy(nelc,stk(lc),1,stk(l1),1)
      if(itr.eq.1) call dcopy(nelc,stk(lc+nel),1,stk(l1+nelc),1)
      lstk(top+1)=l1+nelc*(itr+1)
      go to 999
c     
 12   continue
c     a*cst
      if(istk(il2).eq.1) then
         si = 0.0d0
         sr = stk(l2)
         if(it2.eq.1) si = stk(l2+1)
      elseif(istk(il2).eq.5) then
         if(nel2.eq.0) then
            sr = 0.0d0
            si = 0.0d0
         else
            si = 0.0d0
            sr = stk(l2)
            if(it2.eq.1) si = stk(l2+1)
         endif
      endif
      if(abs(sr)+abs(si).eq.0.0d0) then
         if(istk(il1).eq.1) then
            istk(il1+3)=0
            call dset(m1*n1,0.0d0,stk(l1),1)
            lstk(top+1)=l1+m1*n1
         else
            istk(il1+3)=0
            istk(il1+4)=0
            call iset(abs(m1),0,stk(il1+5),1)
            lstk(top+1)=sadr(il1+5+abs(m1))+1
         endif
         return
      endif
      go to 14

 13   continue
c     cst*a
      if(istk(il1).eq.1) then
         si = 0.0d0
         sr = stk(l1)
         if(it1.eq.1) si = stk(l1+1)
      elseif(istk(il1).eq.5) then
         if(nel1.eq.0) then
            sr = 0.0d0
            si = 0.0d0
         else
            si = 0.0d0
            sr = stk(l1)
            if(it1.eq.1) si = stk(l1+1)
         endif
      endif
      if(abs(sr)+abs(si).eq.0.0d0) then
         if(istk(il2).eq.1) then
            istk(il1)=1
            istk(il1+1)=m2
            istk(il1+2)=n2
            istk(il1+3)=0
            l1=sadr(il1+4)
            call dset(m2*n2,0.0d0,stk(l1),1)
            lstk(top+1)=l1+m2*n2
         else
            istk(il1)=5
            istk(il1+1)=m2
            istk(il1+2)=n2
            istk(il1+3)=0
            istk(il1+4)=0
            call iset(abs(m2),0,stk(il1+5),1)
            lstk(top+1)=sadr(il1+5+abs(m2))+1
         endif
         return
      endif

      if(istk(il2).eq.5) then
         call icopy(5+m2+nel2,istk(il2),1,istk(il1),1)
         l1=sadr(il1+5+m2+nel2)
         call dcopy(nel2*(it2+1),stk(l2),1,stk(l1),1)
      elseif(istk(il2).eq.1) then
         call icopy(4,istk(il2),1,istk(il1),1)
         l1=sadr(il1+4)
         call dcopy(mn2*(it2+1),stk(l2),1,stk(l1),1)
      endif
      m1=m2
      n1=n2
      mn1=it1
      it1=it2
      it2=mn1
      mn1=mn2
      nel1=nel2
c     
 14   continue
      istk(il1+1)=m1
      istk(il1+2)=n1
      istk(il1+3)=itr
      lstk(top+1)=l1+nel1*(itr+1)
c     
      err=lstk(top+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c     
      goto (15,16,17),it2+2*it1
c     la matrice et le scalaire sont reel
      call dscal(nel1,sr,stk(l1),1)
      goto 999
 15   continue
c     la matrice est reelle le scalaire est complexe
      err=l1+2*nel1-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dcopy(nel1,stk(l1),1,stk(l1+nel1),1)
      call dscal(nel1,sr,stk(l1),1)
      call dscal(nel1,si,stk(l1+nel1),1)
      lstk(top+1)=l1+2*nel1
      goto 999
 16   continue
c     la matrice est complexe, le scalaire est reel
      call dscal(nel1,sr,stk(l1),1)
      call dscal(nel1,sr,stk(l1+nel1),1)
      goto 999
 17   continue
c     la matrice et le scalaire sont complexes
      call wscal(nel1,sr,si,stk(l1),stk(l1+mn1),1)
      goto 999
c     
c     division a droite
 20   if (mn2 .eq. 1) go to 21
      fin = -fin
      top = top0
      rhs = 2
      go to 999
 21   continue
      sr=stk(l2)
      si=0.0d+0
      if(it2.eq.1) si=stk(l2+1)
 22   e1=max(abs(sr),abs(si))
      if(e1.eq.0.0d+0) then
         call error(27)
         return
      endif
      sr=sr/e1
      si=si/e1
      e1=e1*(sr*sr+si*si)
      sr=sr/e1
      si=-si/e1
      goto 14
c     on appele la multiplication avec l'inverse du scalaire
c     
c     division a gauche
 25   if (m1*n1 .eq. 1) go to 26
      top=top0
      fin=-fin
      return
 26   continue
      m1=m2
      n1=n2
      sr=stk(l1)
      si=0.0d+0
      if(it1.eq.1) si=stk(l1+1)
      call icopy(5+2*nel2,istk(il2),1,istk(il1),1)
      l1=sadr(il1+5+2*nel2)
      call dcopy(mn2*(it2+1),stk(l2),1,stk(l1),1)
      m1=m2
      n1=n2
      mn1=it1
      it1=it2
      it2=mn1
      mn1=mn2
      goto 22
c     
c     puissance
 30   if (mn2 .ne. 1) then
         call error(30)
         return
      endif
      if(m1.eq.n1.and.m1*n1.gt.1) goto 31
c     element wise
      if(it2.eq.0) then
         powr=stk(l2)
         if(it1.eq.0) then
            call ddpow(nel1,stk(l1),1,powr,err)
         else
            call wdpow(nel1,stk(l1),stk(l1+nel1),1,powr,err)
         endif
      else
         powr=stk(l2)
         powi=stk(l2+1)
         if(it1.eq.0) then
            call dwpow(nel1,stk(l1),stk(l1+nel1),1,
     &           powr,powi,err)
         else
            call wwpow(nel1,stk(l1),stk(l1+nel1),1,
     &           powr,powi,err)
         endif
      endif
      if(err.eq.1) then
         call error(30)
         return
      endif
      if(err.eq.2) then
         call error(27)
         return
      endif
      istk(il1+3)=itr
      lstk(top+1)=l1+nel1*(itr+1)
      goto 999
c     
c     elevation d'une matrice carree a une puissance
 31   continue
      top=top0
      fin=-fin
      return
c     

c     operations elements a elements
 55   continue
      i1=1
      i2=1
      op = op - dot
      if(mn1.eq.0.or.mn2.eq.0) then
c     [].*a     a.*[]  -->[]
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         istk(il1+3)=0
         lstk(top+1)=sadr(il1+4)+1
         goto 999
      endif
      if(mn1.eq.1) then
         if(op.eq.star) goto 13
         if(op.eq.bslash) goto 26
      else if(mn2.eq.1) then
         if(op.eq.star) goto 12
         if(op.eq.slash) goto 21
      endif
c     check dimensions
      if (m1.ne.m2 .or. n1.ne.n2) then
         call error(6)
         return
      endif
      if(op.eq.slash) then
         if(istk(il2).eq.1) then
            if(it2.eq.0) then
               do 56 i=0,mn1-1
                  if(stk(l2+i).eq.0.0d0) then
                     call error(27)
                     return
                  endif
                  stk(l2+i)=1.0d0/stk(l2+i)
 56            continue
            else          
               do 57 i=0,mn2-1
                  sr=stk(l2+i)
                  si=stk(l2+mn2+i)
                  e1=abs(sr)+abs(si)
                  if(e1.eq.0.0d+0) then
                     call error(27)
                     return
                  endif
                  sr=sr/e1
                  si=si/e1
                  e1=e1*(sr*sr+si*si)
                  stk(l2+i)=sr/e1
                  stk(l2+mn2+i)=-si/e1
 57            continue
            endif
         else
            top=top0
            fin=-fin
            return
         endif
      elseif(op.eq.bslash) then
         if(istk(il1).eq.1) then
            if(it1.eq.0) then
               do 58 i=0,mn1-1
                  if(stk(l1+i).eq.0.0d0) then
                     call error(27)
                     return
                  endif
                  stk(l1+i)=1.0d0/stk(l1+i)
 58            continue
            else          
               do 59 i=0,mn1-1
                  sr=stk(l1+i)
                  si=stk(l1+mn1+i)
                  e1=abs(sr)+abs(si)
                  if(e1.eq.0.0d+0) then
                     call error(27)
                     return
                  endif
                  sr=sr/e1
                  si=si/e1
                  e1=e1*(sr*sr+si*si)
                  stk(l1+i)=sr/e1
                  stk(l1+mn1+i)=-si/e1
 59            continue
            endif
         else
            top=top0
            fin=-fin
            return
         endif
      endif
      if(nel1.eq.0.or.nel2.eq.0) then
         istk(il1+3)=0
         istk(il1+4)=0
         call iset(m1,0,istk(il1+5),1)
         lstk(top+1)=sadr(il1+5+m1)
         return
      endif
      if(istk(il1).eq.1) then
c     full.*sparse
         nel=nel2
         if(it1.eq.0.and.it2.eq.0) then
            call dspxs(m1,n1,stk(l2),nel2,istk(irc2),stk(l1),m1,
     $           stk(l2),nel,istk(irc2),ierr)
         else
            if(it2.eq.0) then
               err=l2+2*nel2-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
            endif
            call wspxs(m1,n1,stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $           stk(l1),stk(l1+nel1),m1,
     $           stk(l2),stk(l2+nel2),nel,istk(irc2),ierr,it2,it1)
         endif
         istk(il1)=5
         istk(il1+3)=itr
         istk(il1+4)=nel
         l=sadr(il1+5+m1+nel)
         call icopy(m1+nel,istk(irc2),1,istk(il1+5),1)
         call dcopy(nel,stk(l2),1,stk(l),1)
         if(itr.eq.1) call dcopy(nel,stk(l2+nel2),1,stk(l+nel),1)
         lstk(top+1)=l+nel*(itr+1)
         return
      elseif(istk(il2).eq.1) then
c     sparse.*full
         nel=nel1
         if(it1.eq.0.and.it2.eq.0) then
            call dspxs(m1,n1,stk(l1),nel1,istk(irc1),stk(l2),m1,
     $           stk(l1),nel,istk(irc1),ierr)
         else
            lri=l1+nel1
            if(it1.eq.0) then
               lri=lw
               err=lri+nel1-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
            endif
            call wspxs(m1,n1,stk(l1),stk(l1+nel1),nel1,istk(irc1),
     $           stk(l2),stk(l2+nel2),m1,
     $           stk(l1),stk(lri),nel,istk(irc1),ierr,it1,it2)
         endif
         istk(il1)=5
         istk(il1+3)=itr
         istk(il1+4)=nel
         l=sadr(il1+5+m1+nel)
         call icopy(m1+nel,istk(irc1),1,istk(il1+5),1)
         call dcopy(nel,stk(l1),1,stk(l),1)
         if(itr.eq.1) call dcopy(nel,stk(lri),1,stk(l+nel),1)
         lstk(top+1)=l+nel*(itr+1)
         return
      endif
c     sparse.*sparse
      nel=nel1
      if(it1.eq.0.and.it2.eq.0) then
         call dspxsp(m1,n1,stk(l1),nel1,istk(irc1),
     $        stk(l2),nel2,istk(irc2),stk(l1),nel,istk(irc1),ierr)
         lrr=l1

      else
         lrr=lw
         lri=lrr+min(nel1,nel2)
         err=lri+min(nel1,nel2)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call wspxsp(m1,n1,stk(l1),stk(l1+nel1),nel1,istk(irc1),
     $        stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $        stk(lrr),stk(lri),nel,istk(irc1),ierr,it1,it2)
      endif

      istk(il1+3)=itr
      istk(il1+4)=nel
      l=sadr(il1+5+m1+nel)
      call dcopy(nel,stk(lrr),1,stk(l),1)
      if(itr.eq.1) call dcopy(nel,stk(lri),1,stk(l+nel),1)
      lstk(top+1)=l+nel*(itr+1)
      return
c     
c     kronecker
 65   continue
      top=top0
      fin=-fin
      return
c     
c     
c     transposition
 70   istk(il1+1)=n1
      istk(il1+2)=m1
      if(nel1.eq.0) then
         lw=sadr(il1+5+n1)
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call iset(n1,0,istk(il1+5),1)
         lstk(top+1)=lw
         goto 999
      endif
      ia=iadr(lw)
      iat=ia+m1+1
      irc=iat+n1+1
      lat=sadr(irc+n1+nel1)
      lw=lat+nel1*(it1+1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(ia)=1
      do 71 i=1,m1
         istk(ia+i)=istk(ia+i-1)+istk(irc1+i-1)
 71   continue
      if(it1.eq.0) then
         call dspt(m1,n1,stk(l1),nel1,istk(irc1),istk(ia),
     $        stk(lat),istk(iat),istk(irc))
      else
         call wspt(m1,n1,stk(l1),stk(l1+nel1),nel1,istk(irc1),istk(ia),
     $        stk(lat),stk(lat+nel1),istk(iat),istk(irc))
      endif
      call icopy(n1+nel1,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+n1+nel1)
      call dcopy(nel1*(it1+1),stk(lat),1,stk(l1),1)
      lstk(top+1)=l1+nel1*(it1+1)
      goto 999
c     
c     concatenation [a b]
 75   continue
      if(m1.lt.0.or.m2.lt.0) then
         call error(14)
         return
      endif
      if(m2.eq.0) then
         return
      elseif(m1.eq.0) then
         call icopy(5+m2+nel2,istk(il2),1,istk(il1),1)
         l1=sadr(il1+5+m2+nel2)
         call dcopy(nel2*(it2+1),stk(l2),1,stk(l1),1)
         lstk(top+1)=l1+nel2*(it2+1)
         return
      elseif(m1.ne.m2) then
         call error(5)
         return
      endif
      if(istk(il1).ne.5.or.istk(il2).ne.5) then
         top=top0
         fin=-fin
         return
      endif
c
      nelr=nel1+nel2
      istk(il1+2)=n1+n2
      istk(il1+3)=itr
      istk(il1+4)=nelr
      lr=lw
      irc=iadr(lr+nelr*(itr+1))
      lw=sadr(irc+m1+nelr)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(itr.eq.0) then
         call dspcsp(0,m1,n1,stk(l1),nel1,istk(irc1),
     $        m2,n2,stk(l2),nel2,istk(irc2),
     $        stk(lr),nelr,istk(irc))
      else
         call wspcsp(0,m1,n1,stk(l1),stk(l1+nel1),nel1,istk(irc1),
     $        m2,n2,stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $        stk(lr),stk(lr+nelr),nelr,istk(irc),it1,it2)
      endif
      call icopy(m1+nelr,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+m1+nelr)
      call dcopy(nelr*(itr+1),stk(lr),1,stk(l1),1)
      lstk(top+1)=l1+nelr*(itr+1)
      return
c     
c     concatenation [a;b]
 78   continue
      if(n1.lt.0.or.n2.lt.0) then
         call error(14)
         return
      endif
      if(n2.eq.0) then
         goto 999
      elseif(n1.eq.0)then
         call icopy(5+m2+nel2,istk(il2),1,istk(il1),1)
         l1=sadr(il1+5+m2+nel2)
         call dcopy(nel2*(it2+1),stk(l2),1,stk(l1),1)
         lstk(top+1)=l1+nel2*(it2+1)
         goto 999
      elseif(n1.ne.n2) then
         call error(6)
         return
      endif
      if(istk(il1).ne.5.or.istk(il2).ne.5) then
         top=top0
         fin=-fin
         return
      endif


      nelr=nel1+nel2
      istk(il1+1)=m1+m2
      istk(il1+3)=itr
      istk(il1+4)=nelr
      lr=lw
      irc=iadr(lr+nelr*(itr+1))
      lw=sadr(irc+m1+m2+nelr)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(itr.eq.0) then
         call dspcsp(1,m1,n1,stk(l1),nel1,istk(irc1),
     $        m2,n2,stk(l2),nel2,istk(irc2),
     $        stk(lr),nelr,istk(irc))
      else
         call wspcsp(1,m1,n1,stk(l1),stk(l1+nel1),nel1,istk(irc1),
     $        m2,n2,stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $        stk(lr),stk(lr+nelr),nelr,istk(irc),it1,it2)
      endif
      call icopy(m1+m2+nelr,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+m1+m2+nelr)
      call dcopy(nelr*(itr+1),stk(lr),1,stk(l1),1)
      lstk(top+1)=l1+nelr*(itr+1)
      goto 999
c     
c     extraction
c     
 80   continue
c     extraction
c     
      if(rhs.gt.2) goto 82
c     vect(arg)
      if(mn1.eq.0) then
c     un des vecteurs d'indice est vide
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         lstk(top+1)=l1+1
         goto 999
      endif
      if(m1.gt.1.and.n1.gt.1.or.it1.ne.0) then
         call error(21)
         return
      endif
      if(m2.lt.0) then
         call error(14)
         return
      endif
c     
      if(istk(il1+1).lt.0) then
         if(n2.eq.1.or.m2.eq.1) then
            call icopy(5+m2+nel2,istk(il2),1,istk(il1),1)
            l1=sadr(il1+5+m2+nel2)
            call dcopy(nel2*(it2+1),stk(l2),1,stk(l1),1)
            lstk(top+1)=l1+nel2*(it2+1)
         else
            call error(43)
            return
         endif
         return
      endif
      mm=max(m2,n2)
      li1=iadr(l1)
      do 81 j=0,mn1-1
         istk(li1+j)=stk(l1+j)
         if(istk(li1+j).lt.0.or.istk(li1+j).gt.mm) then
            call error(21)               
            return
         endif
 81   continue
      if(m2.eq.1) then
c     vecteur ligne
         m=-1
         n=mn1
         mr=n
      elseif(n2.eq.1) then
c     vecteur colonne
         m=mn1
         n=-1
         mr=m
      else
c     matrice, on retourne un vecteur colonne
         call error(43)
         return
      endif

      lptr=iadr(lw)
      irc=lptr+m2+1
      lw=sadr(irc+mr)
      nelr=(lstk(bot)-lw)/(1+2*(it2+1))
      if(nelr.le.0) then
         err=lw-lstk(bot)
         call error(17)
         return
      endif
      lr=sadr(irc+mr+nelr)
      lw=lr+nelr*(it2+1)
      nel=nelr

      if(it2.eq.0) then
         call dspe2(m2,n2,stk(l2),nel2,istk(irc2),
     $        istk(li1),m,istk(li1),n,mr,nr,
     $        stk(lr),nelr,istk(irc),istk(lptr),ierr)
      else
         call wspe2(m2,n2,stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $        istk(li1),m,istk(li1),n,mr,nr,
     $        stk(lr),stk(lr+nelr),nelr,istk(irc),istk(lptr),ierr)
      endif
      istk(il1)=5
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=it2
      istk(il1+4)=nelr
      call icopy(m+nelr,istk(irc),1,istk(il1+5),1)
      l1=sadr(il1+5+mr+nelr)
      call dcopy(nelr,stk(lr),1,stk(l1),1)
      if(it2.eq.1)  call dcopy(nelr,stk(lr+nel),1,stk(l1+nelr),1)
      lstk(top+1)=l1+nelr*(it2+1)
      go to 999

c
c     matrix(arg,arg)
 82   continue
      if(rhs.gt.4) then
         call error(36)
         return
      endif
      if(mn1*mn2.eq.0) then
c     un des vecteurs d'indice est vide
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         lstk(top+1)=l1+1
         goto 999
      endif
      if(it1+it2.ne.0) then
         call error(21)
         return
      endif
      if(mn3.eq.0) then 
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         lstk(top+1)=l1+1
         goto 999
      elseif(m3.lt.0) then
         call error(14)
         return
      endif
c
      li1=iadr(l1)
      if(istk(il1+1).lt.0) then
         m=-1
      else
         m=mn1
         do 83 j=0,mn1-1
            istk(li1+j)=stk(l1+j)
            if(istk(li1+j).lt.0.or.istk(li1+j).gt.m3) then
               call error(21)
               return
            endif
 83      continue
      endif
c.
      li2=iadr(l2)
      if(istk(il2+1).lt.0) then
         n=-1
      else
         n=mn2
         do 84 j=0,mn2-1
            istk(li2+j)=stk(l2+j)
            if(istk(li2+j).lt.0.or.istk(li2+j).gt.n3) then
               call error(21)
               return
            endif
 84      continue
      endif
c
      lptr=iadr(lw)
      irc=lptr+m3+1
      lw=sadr(irc+m)
      nelr=(lstk(bot)-lw)/(1+2*(it3+1))
      if(nelr.le.0) then
         err=lw-lstk(bot)
         call error(17)
         return
      endif
      lr=sadr(irc+m+nelr)
      lw=lr+nelr*(it3+1)
      nel=nelr
      if(it3.eq.0) then
         call dspe2(m3,n3,stk(l3),nel3,istk(irc3),istk(li1),m,
     $        istk(li2),n,mr,nr,stk(lr),nelr,istk(irc),istk(lptr),ierr)
      else
         call wspe2(m3,n3,stk(l3),stk(l3+nel3),nel3,istk(irc3),
     $        istk(li1),m,istk(li2),n,mr,nr,
     $        stk(lr),stk(lr+nel),nelr,istk(irc),istk(lptr),ierr)
      endif
      istk(il1)=5
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=it3
      istk(il1+4)=nelr
      call icopy(m+nelr,istk(irc),1,istk(il1+5),1)
      l1=sadr(il1+5+m+nelr)
      call dcopy(nelr,stk(lr),1,stk(l1),1)
      if(it3.eq.1) call dcopy(nelr,stk(lr+nel),1,stk(l1+nelr),1)
      lstk(top+1)=l1+nelr*(it3+1)
      go to 999
      
c     insert
 85   if(rhs.eq.4) goto 90

c     vector case : arg3(arg1)=arg2
c     
      if(it1.ne.0) then
         call error(21)
         return
      endif
c
      if(istk(il3).ne.5) then
         top=top0
         fin=-fin
         return
      endif
c
      imax=0
      li1=iadr(l1)
      if(m1.gt.0) then
         do 87 i = 0, m1*n1-1
            istk(li1+i)=stk(l1+i)
            if(istk(li1+i).lt.0) then
               call error(21)
               return
            endif
            imax=max(imax,istk(li1+i))
 87      continue
      endif
      if(m3.gt.1.and.n3.gt.1) then
c     matrix(:)=vector
         call error(43)
         return
      elseif (n3.le.1.and.n2.le.1) then
c     column vector 
         m=isign(mn1,m1)
         n=-1
         nr=1
         if(m.lt.0) then
            if(mn2.eq.0) then
c     v(:)=[]
               istk(il1)=1
               istk(il1+1)=0
               istk(il1+2)=0
               istk(il1+3)=0
               lstk(top+1)=sadr(il1+4)
               return
            elseif(mn2.ne.mn3) then
               call error(15)
               return
            else
c     v(:)=u
               mr=m3
            endif
         else
            if(mn2.eq.0) then
c     v(i)=[]
               mr=m3-mn1
               if(mr.le.0) then
                  istk(il1)=1
                  istk(il1+1)=0
                  istk(il1+2)=0
                  istk(il1+3)=0
                  lstk(top+1)=sadr(il1+4)
                  return
               endif
            elseif(mn1.ne.mn2) then
               call error(15)
               return
            else
c     v(i)=u
               mr=max(m3,imax)
            endif
         endif
      elseif (m3.le.1.or.m2.le.1) then
c     row vecteur 
         m=-1
         n=isign(mn1,m1)
         mr=1
         if(n.lt.0) then
            if(mn2.eq.0) then
c     v(:)=[]
               istk(il1)=1
               istk(il1+1)=0
               istk(il1+2)=0
               istk(il1+3)=0
               lstk(top+1)=sadr(il1+4)
               return
            elseif(mn2.ne.mn3) then
               call error(15)
               return
            else
               nr=n3
            endif
         else
            if(mn2.eq.0) then
c     v(i)=[]
               nr=n3-mn1
               if(nr.le.0) then
                  istk(il1)=1
                  istk(il1+1)=0
                  istk(il1+2)=0
                  istk(il1+3)=0
                  lstk(top+1)=sadr(il1+4)
                  return
               endif
            elseif(mn1.ne.mn2) then
               call error(15)
               return
            else
               nr=max(n3,imax)
            endif
         endif
      endif

c     
      itr=max(it2,it3)
      lptr=iadr(lw)
      irc=lptr+m3+1
      lw=sadr(irc+mr)
      nelr=(lstk(bot)-lw)/(1+2*(itr+1))
      if(nelr.le.0) then
         err=lw-lstk(bot)
         call error(17)
         return
      endif
      lr=sadr(irc+mr+nelr)
      lw=lr+nelr*(itr+1)
      nel=nelr
      if(istk(il3).eq.5) then
         if(istk(il2).eq.5) then
            if(itr.eq.0) then
               call dspisp(m3,n3,stk(l3),nel3,istk(irc3),
     $              istk(li1),m,istk(li1),n,
     $              m2,n2,stk(l2),nel2,istk(irc2),
     $              mr,nr,stk(lr),nelr,istk(irc),istk(lptr),ierr)
            else
               call wspisp(m3,n3,stk(l3),stk(l3+nel3),nel3,istk(irc3),
     $              istk(li1),m,istk(li1),n,
     $              m2,n2,stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $              mr,nr,stk(lr),stk(lr+nelr),nelr,istk(irc),
     $              istk(lptr),ierr,it3,it2)
            endif
         else
            if(itr.eq.0) then
               call dspis(m3,n3,stk(l3),nel3,istk(irc3),
     $              istk(li1),m,istk(li1),n,
     $              m2,n2,stk(l2),
     $              mr,nr,stk(lr),nelr,istk(irc),ierr) 
            else
               call wspis(m3,n3,stk(l3),stk(l3+nel3),nel3,istk(irc3),
     $              istk(li1),m,istk(li1),n,
     $              m2,n2,stk(l2),stk(l2+nel2),
     $              mr,nr,stk(lr),stk(lr+nelr),nelr,istk(irc),
     $              ierr,it3,it2) 
            endif
         endif
      endif
      if(ierr.ne.0) then
         buf='not enough memory'
         call error(9999)
         return
      endif
      istk(il1)=5
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=itr
      istk(il1+4)=nelr
      call icopy(mr+nelr,istk(irc),1,istk(il1+5),1)
      l1=sadr(il1+5+mr+nelr)
      call dcopy(nelr,stk(lr),1,stk(l1),1)
      if(itr.eq.1) call dcopy(nelr,stk(lr+nel),1,stk(l1+nelr),1)
      lstk(top+1)=l1+nelr*(itr+1)
      go to 999
c     
c     matrix case : arg4(arg1,arg2)=arg3
 90   continue
c     
      if(it1+it2.ne.0) then
         call error(21)
         return
      endif
c
      m=-1
      if(m1.ge.0) m=mn1
      n=-1
      if(m2.ge.0) n=mn2
      if(mn4.eq.0.and.(m.lt.0.or.n.lt.0)) then
         call error(15)
         return
      endif
      if(m3*n3.eq.0.and.m.ge.0.and.n.ge.0) then
         call error(15)
         return
      endif
      if(m.lt.0.or.n.lt.0) then
         if(m.lt.0.and.m4.ne.m3) then
            call error(15)
            return
         endif
         if(n.lt.0.and.n4.ne.n3) then
            call error(15)
            return
         endif
      endif
c    

      mr=m4
      if(istk(il4).ne.5) then
         top=top0
         fin=-fin
         return
      endif

      li1=iadr(l1)
      if (m .ge. 0) then
         if(m3.ne.0.and.m.ne.m3) then
            call error(15)
            return
         endif
         do 91 i = 0, m-1
            istk(li1+i)=stk(l1+i)
            if(istk(li1+i).lt.0) then
               call error(21)
               return
            endif
            mr=max(mr,istk(li1+i))
 91      continue
      else
         mr = max(mr,m3)
      endif
      mr = max(mr,m3)
c     
      nr=n4
      li2=iadr(l2)
      if (n .ge. 0) then 
         if(n3.ne.0.and.n.ne.n3) then
            call error(15)
            return
         endif
         do 93 i = 0, n-1
            istk(li2+i)=stk(l2+i)
            if(istk(li2+i).lt.0) then
               call error(21)
               return
            endif
            nr=max(nr,istk(li2+i))
 93      continue
      else
         nr = max(nr,n3)
      endif
      nr = max(nr,n3)
c     
c     scalar matrix case
      itr=max(it4,it3)
      lptr=iadr(lw)
      irc=lptr+m4+1
      lw=sadr(irc+mr)
      nelr=(lstk(bot)-lw)/(1+2*(itr+1))
      if(nelr.le.0) then
         err=lw-lstk(bot)
         call error(17)
         return
      endif
      lr=sadr(irc+mr+nelr)
      lw=lr+nelr*(itr+1)
      nel=nelr
      if(istk(il4).eq.5) then
         if(istk(il3).eq.5) then
            if(itr.eq.0) then
               call dspisp(m4,n4,stk(l4),nel4,istk(irc4),
     $              istk(li1),m,istk(li2),n,
     $              m3,n3,stk(l3),nel3,istk(irc3),
     $              mr,nr,stk(lr),nelr,istk(irc),istk(lptr),ierr)
            else
               call wspisp(m4,n4,stk(l4),stk(l4+nel4),nel4,istk(irc4),
     $              istk(li1),m,istk(li2),n,
     $              m3,n3,stk(l3),stk(l3+nel3),nel3,istk(irc3),
     $              mr,nr,stk(lr),stk(lr+nelr),nelr,istk(irc),
     $              istk(lptr),ierr,it4,it3)
            endif
         else
            if(itr.eq.0) then
               call dspis(m4,n4,stk(l4),nel4,istk(irc4),
     $              istk(li1),m,istk(li2),n,
     $              m3,n3,stk(l3),
     $              mr,nr,stk(lr),nelr,istk(irc),ierr) 
            else
               call wspis(m4,n4,stk(l4),stk(l4+nel4),nel4,istk(irc4),
     $              istk(li1),m,istk(li2),n,
     $              m3,n3,stk(l3),stk(l3+nel3),
     $              mr,nr,stk(lr),stk(lr+nelr),nelr,istk(irc),
     $              ierr,it4,it3) 
            endif
         endif
      endif
      if(ierr.ne.0) then
         buf='not enough memory'
         call error(9999)
         return
      endif
      istk(il1)=5
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=itr
      istk(il1+4)=nelr
      call icopy(mr+nelr,istk(irc),1,istk(il1+5),1)
      l1=sadr(il1+5+mr+nelr)
      call dcopy(nelr,stk(lr),1,stk(l1),1)
      if(itr.eq.1) call dcopy(nelr,stk(lr+nel),1,stk(l1+nelr),1)
      lstk(top+1)=l1+nelr*(itr+1)
      go to 999


c     
c     *. /. \.
 120  fin=-fin
      top=top+1
      goto 999
c     
 130  continue
      if(fin.eq.61) then
         fin=-fin
         top=top+1
         goto 999
      endif
c     comparaisons
      if(max(it1,it2).eq.1) then
         if(op.ne.equal.and.op.ne.less+great) then
            call error(57)
            return
         endif
      endif
      if(mn2.eq.0.and.mn1.eq.0) then
         if(op.eq.equal.or.op.eq.less+great) then
            istk(il1)=4
            istk(il1+1)=1
            istk(il1+2)=1
            istk(il1+3)=1
            if(op.eq.less+great) istk(il1+3)=0
            lstk(top+1)=sadr(il1+4)
            goto 999
         else
            call error(60)
            return
         endif
      endif
      if(mn1.ne.1.and.mn2.ne.1) then
         if(n1.ne.n2.or.m1.ne.m2) then
            if(op.eq.equal.or.op.eq.less+great) then
               istk(il1)=4
               istk(il1+1)=1
               istk(il1+2)=1
               istk(il1+3)=0
               if(op.eq.less+great) istk(il1+3)=1
               lstk(top+1)=sadr(il1+4)
               return
            else
               call error(60)
               return
            endif
         endif
      endif
c
      mr=m1
      nr=n1
      if(m1*n1.eq.1) then
         mr=m2
         nr=n2
      endif
      irc=iadr(lw)
      nelmx=(iadr(lstk(bot))-irc-mr-10)
      lw=sadr(irc+mr+nelmx)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif  
      nel=nelmx
      if(istk(il1).eq.1) then
         if(itr.eq.1) then
            call wsosp(op,m1,n1,stk(l1),stk(l1+nel1),
     $           m2,n2,stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $           nel,istk(irc),ierr,it1,it2)
         else
            call dsosp(op,m1,n1,stk(l1),m2,n2,stk(l2),nel2,
     $           istk(irc2),nel,istk(irc),ierr)
         endif
      elseif(istk(il2).eq.1) then
         if(itr.eq.1) then
            call wspos(op,m1,n1,stk(l1),stk(l1+nel1),nel1,istk(irc1),
     $           m2,n2,stk(l2),stk(l2+nel2),
     $           nel,istk(irc),ierr,it1,it2)
         else
            call dspos(op,m1,n1,stk(l1),nel1,istk(irc1),
     $           m2,n2,stk(l2),nel,istk(irc),ierr)
         endif
      else
         if(itr.eq.1) then
            call wsposp(op,m1,n1,stk(l1),stk(l1+nel1),nel1,
     $           istk(irc1),m2,n2,stk(l2),stk(l2+nel2),nel2,istk(irc2),
     $           nel,istk(irc),ierr,it1,it2)
         else
            call dsposp(op,m1,n1,stk(l1),nel1,istk(irc1),
     $           m2,n2,stk(l2),nel2,istk(irc2),
     $           nel,istk(irc),ierr)
         endif
      endif
      if(ierr.ne.0) then
         buf='not enough memory'
         call error(9999)
         return
      endif
      istk(il1)=6
      istk(il1+1)=mr
      istk(il1+2)=nr

      istk(il1+3)=0
      istk(il1+4)=nel
      irc1=il1+5
      call icopy(mr+nel,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+mr+nel)
      lstk(top+1)=l1
      go to 999
      
c     
      
 999  return
      end
