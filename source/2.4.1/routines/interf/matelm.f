      subroutine matelm
c ====================================================================
c
c     evaluate utility functions
c
c ====================================================================
c
c     Copyright INRIA
      INCLUDE '../stack.h'
c
      integer id(nsiz)
c     
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1

c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matelm '//buf(1:4))
      endif
c
c     functions/fin
c     abs  real imag conj roun int  size sum  prod diag triu tril
c      1    2    3    4    5    6    7    8    9    10   11   12
c     eye  rand ones maxi mini sort kron matr sin  cos  atan exp
c      13   14   15   16   17   18  19-21 22   23   24   25   26
c     sqrt log   ^  sign clean floor ceil expm cumsum  cumprod testmatrix
c      27   28   29  30   31     32   33   34    35      36      37
c!
c
      goto (10 ,15 ,20 ,25 ,30 ,35 ,40 ,45 ,50 ,60,
     1      61 ,62 ,70 ,72 ,71 ,90 ,91 ,105,110,110,
     2      110,130,140,150,160,170,180,190,200,210,
     3      220,37 ,39 ,173,46 ,47, 230,240),fin

 10   continue
      call intabs(id)
      goto 900
c     
c     real
 15   continue
      call intreal(id)
      goto 900
c     
c     imag
 20   continue
      call intimag(id)
      goto 900
c     
c     conjg
 25   continue
      call intconj(id)
      goto 900
c     
c     round
 30   continue
      call intround(id)
      goto 900
c     
c     int
 35   continue
      call intint(id)
      goto 900
c     
c     floor
 37   continue
      call intfloor(id)
      goto 900
c     
c     ceil
 39   continue
      call intceil(id)
      goto 900
c     
c     size
 40   continue
      call intsize(id)
      goto 900    

c     sum
 45   continue
      call intsum(id)
      goto 900    

c     
c     cumsum
 46   continue
      call intcumsum(id)
      go to 900
c     
c     cumprod
 47   continue
      call intcumprod(id)
      go to 900
c     
c     prod
 50   continue
      call intprod(id)
      go to 900
c     
c     diag
 60   continue
      call intdiag(id)
      go to 900

c     triu
 61   continue
      call inttriu(id)
      go to 900

c     tril
 62   continue
      call inttril(id)
      go to 900

c     eye
 70   continue
      call inteye(id)
      go to 900

c     ones
 71   continue
      call intones(id)
      go to 900

c     rand
 72   call  intrand('rand',id)
      go to 900

c     maxi
 90   continue
      call intmaxi('maxi',id)
      go to 900

c     mini
 91   continue
      call intmaxi('mini',id)
      go to 900
c     
c     sort
 105  continue
      call intsort(id)
      go to 900

c     
c     kronecker product
 110  continue
      call intkron(id)
      go to 900
c     
c     matrix
 130  continue
      call intmatrix(id)
      goto 900
c     
c     sin
c     
 140  continue
      call intsin(id)
      goto 900
c     
c     cos
c     
 150  continue
      call intcos(id)
      goto 900
c     
c     atan
c     
 160  continue
      call intatan(id)
      goto 900

c     exp element wise
 170  continue
      call intexp(id)
      goto 900

c     expm matricial exponential
 173  continue
      call intexpm(id)
      goto 900

c     sqrt
 180  continue
      call intsqrt(id)
      goto 900

c     
c     log
c     
 190  continue
      call intlog(id)
      goto 900

c     
c     ** non integer power of square matrices or  scalar^matrix
c     
 200  continue
      fun=-1
      call funnam(ids(1,pt+1),'pow',iadr(lstk(top-rhs+1)))
      goto 900
c     
c     sign
c     
 210  continue
      call intsign(id)
      goto 900
c     
c     clean
c     
 220  continue
      call intclean(id)
      goto 900

c     
c     testmatrix
c     
 230  continue
      call inttestmatrix(id)
      goto 900
c     
c     isreal
c     
 240  continue
      call intisreal(id)
      goto 900
c
 900  return
      end

      subroutine intrand(fname,id)
c     -------------------------------
      character*(*) fname
c     Interface for rand function 
      INCLUDE '../stack.h'
      double precision s,sr,si
      integer id(nsiz),tops,topk
      double precision urand
      logical checkrhs,checklhs,getsmat,getscalar,cremat,getmat
      logical cresmat2
      integer gettype
      character*(20) randtype
      integer iadr,sadr
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      tops=top
c
      randtype='uniform'//char(0)
      irt=0
      icont=0
      m=-99
      rhs=max(0,rhs)
      if (.not.checkrhs(fname,0,3)) return
      if (.not.checklhs(fname,1,1)) return
      topk=top

      if ( rhs.eq.3 ) then 
c     third argument is a string giving the rand type
c     ( 'uniform','gaussian',...)
         if(.not.getsmat(fname,topk,top,mt,nt,1,1,lrt,nlrt))return
         call cvstr(nlrt,istk(lrt),randtype,1)
         randtype(nlrt+1:nlrt+1)=char(0)
         irt=2
         top=top-1
      endif
C     
      if( rhs.ge.2) then
         itype=gettype(top) 
         if ( itype.eq.1) then 
            if(.not.getscalar(fname,topk,top,lr2))return
            n=int(stk(lr2))
         elseif ( itype.eq.10 ) then 
            if(.not.getsmat(fname,topk,top,mt,nt,1,1,lrt,nlrt))return
            call cvstr(nlrt,istk(lrt),randtype,1)
            randtype(nlrt+1:nlrt+1)=char(0)
            irt=2
         else
            buf=fname//' : second argument has wrong type'
            call error(999)
            return
         endif
         top=top-1
      endif
C     
      it1=-1
      if( rhs.ge.1) then
         itype1=gettype(top) 
         if ( itype1.eq.1.and.rhs.eq.1) then 
            if(.not.getmat(fname,topk,top,it1,m,n,lr1,lc1))return
         elseif ( itype1.eq.1.and.rhs.ge.1.and.itype.eq.1) then 
            if(.not.getscalar(fname,topk,top,lr1))return
            m=int(stk(lr1))
         elseif ( itype1.eq.1.and.rhs.ge.1.and.itype.ne.1) then 
            if(.not.getmat(fname,topk,top,it1,m,n,lr1,lc1))return
         elseif ( itype1.eq.10 ) then 
            if(.not.getsmat(fname,topk,top,mt,nt,1,1,lrt,nlrt))return
            call cvstr(nlrt,istk(lrt),randtype,1)
            randtype(nlrt+1:nlrt+1)=char(0)
            irt=1
         elseif ( rhs.eq.1.and.itype1.gt.10 ) then 
            top=topk
            fun=-1
            call funnam(ids(1,pt+1),'rand',iadr(lstk(top-rhs+1)))
            return
         else
            buf=fname//' : first argument has wrong type'
            call error(999)
            return
         endif
      endif
      if (rhs.eq.0) then 
         top=top+1
         il=iadr(lstk(top))
         istk(il)=1
         m=1
         n=1
      endif
C     seed options 
      if ( randtype(1:nlrt).eq.'seed') then 
         if ( rhs.eq.1 ) then 
            if (.not.cremat(fname,top,0,1,1,lr,lc)) return
            stk(lr) = ran(1)            
            return
         else
            if (itype.eq.1) then
               ran(1) = max(int(stk(lr2)),0)
               call objvide(fname,top)
               return
            else
               buf=fname//' : second argument has wrong type'
               call error(999)
               return
            endif
         endif
      endif
C     getting info 
      if ( randtype(1:nlrt).eq.'info') then 
         call randinfo(randtype,ilen) 
         if (.not.cresmat2(fname,top,ilen,lr)) return
         call cvstr(ilen,istk(lr),randtype,0) 
         return
      endif
C     switching to an other law 
      if ( irt.ge.1 ) then 
         iran1kp=ran(2)
         call randswitch(randtype)
      endif
C     no need for random generation 
      if(m.eq.-99) then 
         call objvide(fname,top)
         return
      endif
C     random generation 
      if(m.eq.0) n=0
      if(n.eq.0) m=0
      if(it1.ne.-1) then 
         itres= it1
      else
         itres= 0
      endif
      if (.not.cremat(fname,top,itres,m,n,lr,lc)) return
      if ( m*n .ne. 0 ) then 
         if ( ran(2).eq.0 ) then 
            do 76 j = 0, (itres+1)*m*n-1
               stk(lr+j) = urand(ran(1))
 76         continue
         elseif (ran(2).eq.1) then 
            do 77 j = 0, m*n-1
 75            sr=2.0d+0*urand(ran(1))-1.0d+0
               si=2.0d+0*urand(ran(1))-1.0d+0
               t = sr*sr+si*si
               if (t .gt. 1.0d+0) go to 75
               stk(lr+j) = sr*sqrt(-2.0d+0*log(t)/t)
 77         continue
         endif
      endif
C     switching back to the default randvalue
      if ( irt.ge.2) then 
         ran(2)=iran1kp
      endif
      return
      end
      
      subroutine randswitch(randtype)
      character*(20) randtype
      INCLUDE '../stack.h'
      if ( randtype(1:1).eq.'u') then 
         ran(2)=0
      else if ( randtype(1:1).eq.'g') then 
         ran(2)=1
      else if ( randtype(1:1).eq.'n') then 
         ran(2)=1
      else 
         ran(2)=0
      endif
      return
      end

      subroutine randinfo(randtype,ilen) 
      INCLUDE '../stack.h'
      character*(20) randtype
      integer ilen 
      if ( ran(2).eq.0) then 
         randtype='uniform'
         ilen=7
      else if ( ran(2).eq.1) then 
         randtype='normal'
         ilen=6
      endif
      return
      end


      subroutine intmaxi(fname,id)
c     -------------------------------
c     maxi mini interface 
c     -------------------------------
      character*(*) fname
      character*(2) type
c     Interface for maxi and mini 
      INCLUDE '../stack.h'
      integer id(nsiz)
      double precision s,sr,si
      logical checkrhs,checklhs,getsmat,getscalar,cremat,getmat
      logical cresmat2,getrmat,test
      logical getilist,getlistmat,checkval
      integer gettype,itype,topk
      integer iadr,sadr
      double precision x1
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      type='g'//char(0)

      topk=top
      if (.not.checklhs(fname,1,2)) return
      if (rhs.le.0) then 
         buf = fname // ' rhs must be stricly positive'
         call error(999)
         return
      endif
      itype=gettype(topk)
c     ------list case 
      if(itype.eq.15) goto 200
c     ------sparse case 
      if(itype.eq.5) then
         call ref2val
         fin=fin-6
         fun=27
c        *call* spelm
         return 
      endif
      if(itype.eq.10.and.rhs.eq.2) goto 10

      if(itype.ne.1) then
c     ------call macro 
         top=topk
         if(fin.eq.17) then
            call funnam(ids(1,pt+1),'mini',iadr(lstk(top)))
         else
            call funnam(ids(1,pt+1),'maxi',iadr(lstk(top)))
         endif
         fun=-1
         return
      endif

      if(rhs.gt.1.and.itype.ne.10) goto 100
c=====maxi mini (A1)
c     ------simple case one argument which is a matrix or vector 
 10   if(rhs.eq.2) then 
         if(.not.getsmat(fname,topk,top,m2,n2,1,1,lr2,nlr2))return
         if (nlr2.ne.1) then
            buf=fname//' : second argument must be "c" or "r"'
            call error(999)         
            return
         endif
         call cvstr(nlr2,istk(lr2),type,1)
         top=top-1
      endif
      if(.not.getrmat(fname,topk,top,m,n,lr1))then
         top=topk
         if(fin.eq.17) then
            call funnam(ids(1,pt+1),'mini',iadr(lstk(top-rhs+1)))
         else
            call funnam(ids(1,pt+1),'maxi',iadr(lstk(top-rhs+1)))
         endif
         fun=-1
         return
      endif
      if(m*n.le.0) then
         if (.not.cremat(fname,top,0,0,0,lr,lir)) return
         return
      endif
      if ( type(1:1).eq.'r') then 
c     ------------max of each column of a 
         if (.not.cremat(fname,topk,0,1,n,lr,lir)) return
         if (.not.cremat(fname,topk+1,0,1,n,lkr,lkir)) return
         do 20 j=0,n-1
            stk(lr+j)=stk(lr1+m*j)
            stk(lkr+j)=1
            if(fin.eq.17) then 
               do 15 i=1,m-1
                  if ( stk(lr1+i+m*j).lt.stk(lr+j)) then 
                     stk(lr+j)=stk(lr1+i+m*j)
                     stk(lkr+j)=i+1
                  endif
 15           continue
            else
               do 16 i=1,m-1
                  if ( stk(lr1+i+m*j).gt.stk(lr+j)) then 
                     stk(lr+j)=stk(lr1+i+m*j)
                     stk(lkr+j)=i+1
                  endif
 16            continue
            endif
 20     continue
         call copyobj(fname,topk,topk-rhs+1)
         if (lhs.eq.2) then 
            call copyobj(fname,topk+1,topk-rhs+2)
         endif
         top=topk-rhs+lhs            
c     ---------max of each row of a
      else if ( type(1:1).eq.'c') then       
         if (.not.cremat(fname,topk,0,m,1,lr,lir)) return
         if (.not.cremat(fname,topk+1,0,m,1,lkr,lkir)) return
         do 30 j=0,m-1
            stk(lr+j)=stk(lr1+j)
            stk(lkr+j)=1
            if(fin.eq.17) then 
               do 25 i=1,n-1
                  if ( stk(lr1+j+m*i).lt.stk(lr+j)) then 
                     stk(lr+j)=stk(lr1+j+m*i)
                     stk(lkr+j)=i+1
                  endif
 25            continue
            else
               do 26 i=1,n-1
                  if ( stk(lr1+j+m*i).gt.stk(lr+j)) then 
                     stk(lr+j)=stk(lr1+j+m*i)
                     stk(lkr+j)=i+1
                  endif
 26           continue
            endif
 30      continue
         call copyobj(fname,topk,topk-rhs+1)
         if (lhs.eq.2) then 
            call copyobj(fname,topk+1,topk-rhs+2)
         endif
         top=topk-rhs+lhs            
c     ----- general maxi or mini 
      else if ( type(1:1).eq.'g') then 
         k=lr1
         ki=lr1
         x1=stk(k)
         if(fin.eq.17) then 
c     mini
            do 41 i=2,m*n
               lr1=lr1+1
               if(stk(lr1).lt.x1) then 
                  k=lr1
                  x1=stk(k)
               endif
 41         continue
c     maxi
         else
            do 42 i=2,m*n
               lr1=lr1+1
               if(stk(lr1).gt.x1) then 
                  k=lr1
                  x1=stk(k)
               endif
 42         continue
         endif
C     return the max or min 
         if (.not.cremat(fname,topk,0,1,1,l1,li1)) return
         stk(l1)=x1
C     return indices of max or min ([k] for vectors  or [kl,kc] 
c     for matrices 
         if(lhs.eq.2) then 
            top=topk+1
            k=k-ki+1
            if(m.eq.1.or.n.eq.1) then 
               if (.not.cremat(fname,top,0,1,1,lr1,lc1)) return
               stk(lr1)=dble(k)
            else
               kc=k/m
               kl=k-kc*m
               if(kl.eq.0) then 
                  kc=kc-1
                  kl=m
               endif
               if (.not.cremat(fname,top,0,1,2,lr1,lc1)) return
               stk(lr1)=dble(kl)
               stk(lr1+1)=dble(kc+1)
            endif
         endif
      else
         buf = fname // ' second argument must be "c" or "r"'
         call error(999)
      endif
      return
c=====maxi mini (A1,.....,An)
 100   continue
c     check argument and compute dimension of the result.
      do 101 i=1,rhs
         if(.not.getrmat(fname,topk,topk-rhs+i,mi,ni,lri)) then
            top=topk
            if(fin.eq.17) then
               call funnam(ids(1,pt+1),'mini',iadr(lstk(topk-rhs+i)))
            else
               call funnam(ids(1,pt+1),'maxi',iadr(lstk(topk-rhs+i)))
            endif
            fun=-1
            return
         endif
         if(mi*ni.le.0) then
            err=i
            call error(45)
            return
         endif
         if(i.eq.1) then
            m=mi
            n=ni
         else
            if(mi.ne.1.or.ni.ne.1) then
               if(mi.ne.m.or.ni.ne.n) then
                  if(m*n.ne.1) then
                     err=i
                     call error(42)
                     return
                  else
                     m=mi
                     n=ni
                  endif
               endif
            endif
         endif
 101   continue



      if(.not.cremat(fname,topk+1,0,m,n,lv,lcw)) return
      if(.not.cremat(fname,topk+2,0,m,n,lind,lcw)) return
c     maxi mini a plusieurs argument
      call dset(m*n,1.0d0,stk(lind),1)
      test=getrmat(fname,topk,topk-rhs+1,mi,ni,lr1) 
      if(mi*ni.eq.1) then
         call dset(m*n,stk(lr1),stk(lv),1)
      else
         call dcopy(m*n,stk(lr1),1,stk(lv),1)
      endif
      do 120 i=2,rhs
         test=getrmat(fname,topk,topk-rhs+i,mi,ni,lri)
         if(mi.eq.1.and.ni.eq.1) then
            inc=0
         else
            inc=1
         endif
         if ( fin.eq.17) then 
c     mini            
            do 111 j=0,m*n-1
               if ( stk(lri).lt.stk(lv+j) ) then 
                  stk(lv+j)= stk(lri) 
                  stk(lind+j)= dble(i)
               endif
               lri=lri+inc
 111         continue
         else
            do 112 j=0,m*n-1
               if ( stk(lri).gt.stk(lv+j) ) then 
                  stk(lv+j)= stk(lri) 
                  stk(lind+j)= dble(i)
               endif
               lri=lri+inc
 112         continue
         endif
 120   continue
      call copyobj(fname,topk+1,topk-rhs+1)
      if (lhs.eq.2) then 
         call copyobj(fname,topk+2,topk-rhs+2)
      endif
      top=topk-rhs+lhs
      return
c
 200  continue
c=====maxi mini of list arguments 
      if(rhs.ne.1) then 
         buf = fname // ': only one argument if it is a list'
         call error(999)
         return
      endif
      if(.not.getilist(fname,topk,topk,n1,1,il1)) return
      if(n1.eq.0) then 
         buf = fname // ': empty list '
         call error(999)
         return
      endif
      if(.not.getlistmat(fname,topk,topk,1,it1,m,n,lr1,lc1)
     $     ) return
      if ( it1.ne.0) then 
         buf = fname // 'arguments must be real '
         call error(999)
         return 
      endif
      if(m*n.le.0) then
         err=1
         call error(45)
         return
      endif
      if(.not.cremat(fname,topk+1,0,m,n,lrw,lcw)) return
      if(.not.cremat(fname,topk+2,0,m,n,lrkw,lckw)) return
      call dset(m*n,1.0d0,stk(lrkw),1)           
      call dcopy(m*n,stk(lr1),1,stk(lrw),1)
c     test si n1 > 1 
      if ( n1.gt.1) then 
         do 215 i=2,n1
            if(.not.getlistmat(fname,topk,topk,i,iti,mi,ni,
     $           lri,lci))           return
            if ( iti.ne.0) then 
               buf = fname // 'arguments must be real '
               call error(999)
               return 
            endif
            if(.not.checkval(fname,m,mi)) return
            if(.not.checkval(fname,n,ni)) return
            if ( fin.eq.17) then 
c     mini            
               do 211 j=0,m*n-1
                  if ( stk(lri+j).lt.stk(lrw+j)) then 
                     stk(lrw+j)=stk(lri+j)
                     stk(lrkw+j)= i
                  endif
 211           continue
            else
               do 212 j=0,m*n-1
                  if ( stk(lri+j).gt.stk(lrw+j)) then 
                     stk(lrw+j)=stk(lri+j)
                     stk(lrkw+j)= i
                  endif
 212           continue
            endif
 215     continue
      endif
      call copyobj(fname,topk+1,topk)
      if (lhs.eq.2) then 
         call copyobj(fname,topk+2,topk+1)
      endif
      top=topk-rhs+lhs
c=====end of list case 
      return
      end
c%%%%
      subroutine intabs(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      double precision pythag
      logical ref
      integer head
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) then
         il=iadr(istk(il+1))
         ref=.true.
      else
         ref=.false.
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)

      if(istk(il).eq.1) then
         mn=m*n
         head=4
         l=sadr(il+4)
         lr=sadr(ilr+4)
      elseif(istk(il).eq.5) then
         mn=istk(il+4)
         head=5+m+mn
         l=sadr(il+5+m+mn)
         lr=sadr(ilr+5+m+mn)
      elseif(istk(il).eq.2) then
         l=sadr(il+9+m*n)
         mn=istk(il+8+m*n)-1
         lr=sadr(ilr+9+m*n)
         head=9+m*n
      else
         call funnam(ids(1,pt+1),'abs',iadr(lstk(top)))
         fun=-1
         return
      endif
      if(ref) then
         err=lr+mn-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(head,istk(il),1,istk(ilr),1)
      endif
      l1=l-1
      lr1=lr-1
      if(it.eq.0) then
         do 11 i=1,mn
            stk(lr1+i)=abs(stk(l1+i))
 11      continue
      else
         k1=l1+mn
         do 13 i=1,mn
            stk(lr1+i)=pythag(stk(l1+i),stk(k1+i))
 13      continue
         istk(ilr+3)=0
      endif
      lstk(top+1)=lr+mn
      return
      end

      subroutine intreal(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      logical ref
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) then
         il=iadr(istk(il+1))
         ref=.true.
      else
         ref=.false.
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)

      if(istk(il).eq.1) then
         mn=m*n
         l=sadr(il+4)
         lr=sadr(ilr+4)
         if (ref) then
            err=lr+mn-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il),1,istk(ilr),1)
            call dcopy(mn,stk(l),1,stk(lr),1)
         endif
         istk(ilr+3)=0
         lstk(top+1)=lr+mn
      elseif(istk(il).eq.2) then
         l=sadr(il+9+m*n)
         lr=sadr(ilr+9+m*n)
         id1=ilr+8
         mn=istk(il+8+m*n)-1
         if (ref) then
            err=lr+mn-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(9+m*n,istk(il),1,istk(ilr),1)
            call dcopy(mn,stk(l),1,stk(lr),1)
         endif
         ilw=iadr(lr+mn)
         call dmpcle(stk(lr),istk(id1),m,n,istk(ilw),0.0d0,0.0d0)
         istk(ilr+3)=0
         lstk(top+1)=lr+istk(id1+m*n)
      else
         call funnam(ids(1,pt+1),'real',iadr(lstk(top)))
         fun=-1
         return
      endif
c
      return
      end

      subroutine intimag(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      logical ref
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) then
         il=iadr(istk(il+1))
         ref=.true.
      else
         ref=.false.
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)


      if(istk(il).eq.1) then
         mn=m*n
         l=sadr(il+4)
         lr=sadr(ilr+4)
         if (ref) then
            err=lr+mn-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il),1,istk(ilr),1)
         endif
         if(it.eq.1) then
            call dcopy(mn,stk(l+mn),1,stk(lr),1)
         else
            call dset(mn,0.0d+0,stk(lr),1)
         endif
         istk(ilr+3)=0
         lstk(top+1)=lr+mn
      elseif(istk(il).eq.2) then
         l=sadr(il+9+m*n)
         lr=sadr(ilr+9+m*n)
         id1=ilr+8
         mn=istk(il+8+m*n)-1
         if (ref) then
            err=lr+mn-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(9+m*n,istk(il),1,istk(ilr),1)
         endif
         if(it.eq.1) then
            call dcopy(mn,stk(l+mn),1,stk(lr),1)
            ilw=iadr(lr+mn)
            call dmpcle(stk(lr),istk(id1),m,n,istk(ilw),0.0d0,0.0d0)
         else
            call dset(m*n,0.0d+0,stk(lr),1)
            do 21 i=1,m*n+1
               istk(id1-1+i)=i
 21         continue
         endif
         istk(ilr+3)=0
         lstk(top+1)=lr+istk(id1+m*n)
      else
         call funnam(ids(1,pt+1),'imag',iadr(lstk(top)))
         fun=-1
         return
      endif
      return
      end

      subroutine intconj(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      
      il=iadr(lstk(top))
      if(abs(istk(il)).gt.2) then
         call funnam(ids(1,pt+1),'conj',iadr(lstk(top)))
         fun=-1
         return
      endif

      if(istk(il).lt.0) then
         k=istk(il+2)
         err=lstk(top)+lstk(k+1)-lstk(k)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dcopy(lstk(k+1)-lstk(k),stk(lstk(k)),1
     $        ,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lstk(k+1)-lstk(k)
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)

      if(istk(il).eq.1) then
         mn=m*n
         l=sadr(il+4)
      else
         l=sadr(il+9+m*n)
         mn=istk(il+8+m*n)-1
      endif
      if(it.eq.1) call dscal(mn,-1.0d+0,stk(l+mn),1)

      return
      end

      subroutine intround(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      double precision round
      logical ref
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) then
         il=iadr(istk(il+1))
         ref=.true.
      else
         ref=.false.
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)

      if(istk(il).eq.1) then
         mn=m*n
         l=sadr(il+4)
         lr=sadr(ilr+4)
         if (ref) then
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il),1,istk(ilr),1)
         endif
      elseif(istk(il).eq.2) then
         l=sadr(il+9+m*n)
         lr=sadr(ilr+9+m*n)
         mn=istk(il+8+m*n)-1
         if (ref) then
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(9+m*n,istk(il),1,istk(ilr),1)
         endif
      else
         call funnam(ids(1,pt+1),'round',iadr(lstk(top)))
         fun=-1
         return
      endif

      if(it.eq.1) mn=2*mn
      do 10 i=1,mn
       i1=i-1
       stk(lr+i1)=round(stk(l+i1))
 10   continue
      lstk(top+1)=lr+mn
      return
      end

      subroutine intint(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      logical ref
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) then
         il=iadr(istk(il+1))
         ref=.true.
      else
         ref=.false.
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)

      if(istk(il).eq.1) then
         mn=m*n
         l=sadr(il+4)
         lr=sadr(ilr+4)
         if (ref) then
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il),1,istk(ilr),1)
         endif
      elseif(istk(il).eq.2) then
         l=sadr(il+9+m*n)
         lr=sadr(ilr+9+m*n)
         mn=istk(il+8+m*n)-1
         if (ref) then
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(9+m*n,istk(il),1,istk(ilr),1)
         endif
      else
         call funnam(ids(1,pt+1),'int',iadr(lstk(top)))
         fun=-1
         return
      endif
c
      if(it.eq.1) mn=2*mn
      do 10 i=1,mn
       i1=i-1
       stk(lr+i1)=aint(stk(l+i1))
 10   continue
      lstk(top+1)=lr+mn
      return
      end

      subroutine intfloor(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      double precision t,t1,round
      logical ref
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) then
         il=iadr(istk(il+1))
         ref=.true.
      else
         ref=.false.
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)

      if(istk(il).eq.1) then
         mn=m*n
         l=sadr(il+4)
         lr=sadr(ilr+4)
         if (ref) then
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il),1,istk(ilr),1)
         endif
      elseif(istk(il).eq.2) then
         l=sadr(il+9+m*n)
         lr=sadr(ilr+9+m*n)
         mn=istk(il+8+m*n)-1
         if (ref) then
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(9+m*n,istk(il),1,istk(ilr),1)
         endif
      else
         call funnam(ids(1,pt+1),'floor',iadr(lstk(top)))
         fun=-1
         return
      endif
      if(it.eq.1) mn=2*mn
      do 10 i=1,mn
        i1=i-1
        t=stk(l+i1)
        t1=round(t-0.5d0)
        if(t.gt.0.d0.and.((t-t1).eq.1.0d0)) t1=t
        stk(lr+i1)=t1
 10   continue
      lstk(top+1)=lr+mn
      return
      end

      subroutine intceil(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      double precision t,t1,round
      logical ref
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) then
         il=iadr(istk(il+1))
         ref=.true.
      else
         ref=.false.
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)

      if(istk(il).eq.1) then
         mn=m*n
         l=sadr(il+4)
         lr=sadr(ilr+4)
         if (ref) then
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il),1,istk(ilr),1)
         endif
      elseif(istk(il).eq.2) then
         l=sadr(il+9+m*n)
         lr=sadr(ilr+9+m*n)
         mn=istk(il+8+m*n)-1
         if (ref) then
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(9+m*n,istk(il),1,istk(ilr),1)
         endif
      else
         call funnam(ids(1,pt+1),'ceil',iadr(lstk(top)))
         fun=-1
         return
      endif
      if(it.eq.1) mn=2*mn
      do 10 i=1,mn
        i1=i-1
        t=stk(l+i1)
        t1=round(t+0.5d0)
        if(t.gt.0.d0.and.((t-t1).eq.1.0d0)) t1=t
        stk(lr+i1)=t1
 10   continue
      lstk(top+1)=lr+mn
      return
      end

      subroutine intsize(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      logical ref
      integer sel,tops
      integer iadr,sadr
      integer basetype
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c

      if(rhs.gt.2) then
         call error(42)
         return
      endif
c
      sel=-1
      tops=top
c
      il=iadr(lstk(tops-rhs+1))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      
      if(istk(il).eq.15.or.istk(il).eq.16) then
c     list or tlist case
c     ------------------
         ll=sadr(il+istk(il+1)+3)
         ilt=iadr(ll)
         if(istk(ilt).eq.10) then
            mnt=istk(ilt+1)*istk(ilt+2)
            if((istk(ilt+5).eq.2.and.istk(ilt+5+mnt).eq.27).or.
     +           (istk(ilt+5).eq.4.and.
     +           (istk(ilt+5+mnt).eq.21.and.istk(ilt+6+mnt).eq.28.and.
     +           istk(ilt+7+mnt).eq.28))) then
c     size of  'lss' or 'r' typed list
               top=tops
               call funnam(ids(1,pt+1),'size',iadr(lstk(top-rhs+1)))
               fun=-1
               return
            endif
         endif
C     size of standard list
         if(lhs*rhs.ne.1) then
            err=1
            call error(39)
            return
         endif
         ilr=iadr(lstk(top))
         istk(ilr)=1
         n=istk(il+1)
         istk(ilr+1)=1
         istk(ilr+2)=1
         istk(ilr+3)=0
         l=sadr(ilr+4)
         stk(l)=dble(n)
         lstk(top+1)=l+1
c
      elseif(istk(il).le.10) then
c     matrix type variable type
c     -------------------------

         if(lhs.gt.2) then
            call error(41)
            return
         endif
         if(rhs.eq.2) then
            if(lhs.ne.1) then
               call error(41)
               return
            endif
            call getorient(top,sel)
            if(err.gt.0) return
            top=top-1
         endif
         m=istk(il+1)
         n=istk(il+2)
         l=sadr(il+4)
         ilr=iadr(lstk(top))
         istk(ilr)=1
         istk(ilr+1)=1
         lr=sadr(ilr+4)

         if(err.gt.0) return
         if(lhs.eq.1) then
            if(sel.eq.-1) then
               istk(ilr+2)=2
               istk(ilr+3)=0
               stk(lr) = m
               stk(lr+1) = n
               lstk(top+1)=lr+2
            elseif(sel.eq.1) then
               istk(ilr+2)=1
               istk(ilr+3)=0
               stk(lr) = m
               lstk(top+1)=lr+1
            elseif(sel.eq.2) then
               istk(ilr+2)=1
               istk(ilr+3)=0
               stk(lr) = n
               lstk(top+1)=lr+1
            elseif(sel.eq.3) then
               istk(ilr+2)=1
               istk(ilr+3)=0
               stk(lr) = m*n
               lstk(top+1)=lr+1
            endif
         else
            istk(ilr)=1
            istk(ilr+1)=1
            istk(ilr+2)=1
            istk(ilr+3)=0
            stk(lr) = m
            lstk(top+1)=lr+1
            top = top + 1
            ilr=iadr(lr+1)
            lr=sadr(ilr+4)
            err=lr+1-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            istk(ilr)=1
            istk(ilr+1)=1
            istk(ilr+2)=1
            istk(ilr+3)=0
            stk(lr) = n
            lstk(top+1)=lr+1
         endif
      else
c     other cases
c     -----------
         top=tops
         call funnam(ids(1,pt+1),'size',iadr(lstk(top-rhs+1)))
         fun=-1
      endif
      return
      end
c

      subroutine intsum(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      logical ref
      integer sel,tops
      integer iadr,sadr
      double precision dsum
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      if(lhs.ne.1) then
         call error(41)
         return
      endif
c
      tops=top
      sel=0
c     
      il0=iadr(lstk(tops-rhs+1))
      ilr=il0
      if(istk(il0).lt.0) il0=iadr(istk(il0+1))
      ref=ilr.ne.il0
c
      if(istk(il0).eq.1) then
c     standard matrix case
         if(rhs.eq.2) then
            call  getorient(top,sel)
            if(err.gt.0) return
            top=top-1
         endif
         m=istk(il0+1)
         n=istk(il0+2)
         it=istk(il0+3)
         mn=m*n
         l1=sadr(ilr+4)
         l=sadr(il0+4)
         if(mn.eq.0) then
            if(ref) then
               err=l1+1-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
            endif
            if(sel.eq.0) then
               istk(ilr)=1
               istk(ilr+1)=1
               istk(ilr+2)=1
               istk(ilr+3)=0
               stk(l1)=0.0d0
               lstk(top+1)=l1+1
            else
               istk(ilr)=1
               istk(ilr+1)=0
               istk(ilr+2)=0
               istk(ilr+3)=0
               lstk(top+1)=l1
            endif
            return
         endif

         if(sel.eq.0) then
            mr=1
            nr=1
         elseif(sel.eq.1) then
            mr=1
            nr=n
         else
            mr=m
            nr=1
         endif
         if(ref) then
            err=l1+mr*nr*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
         endif
         istk(ilr)=1
         istk(ilr+1)=mr
         istk(ilr+2)=nr
         istk(ilr+3)=it
         l1=sadr(ilr+4)

         if(ref) then
            if(it.eq.0) then
               call dmsum(sel,stk(l),m,m,n,stk(l1),1)
            else
               call wmsum(sel,stk(l),stk(l+m*n),m,m,n,stk(l1),
     $              stk(l1+mr*nr),1) 
            endif
         else
            if(it.eq.0) then
               call dmsum(sel,stk(l),m,m,n,stk(l1),1)
            else
               call wmsum(sel,stk(l),stk(l+m*n),m,m,n,stk(l),
     $              stk(l+m*n),1)  
               call dcopy(mr*nr,stk(l+m*n),-1,stk(l1+mr*nr),-1)
            endif
         endif
         lstk(top+1)=l1+mr*nr*(it+1)
      elseif(istk(il0).eq.2.and.sel.eq.0) then
c     matrix of polynomial case
         top=tops
         fin=8
         fun=16
c     .  *call* polelm
         return
      elseif(istk(il0).eq.5) then
         if(rhs.eq.2) then
            call  getorient(top,sel)
            if(err.gt.0) return
            top=top-1
         endif
         if(sel.ne.0) then
            top=tops
            call funnam(ids(1,pt+1),'sum',iadr(lstk(top-rhs+1)))
            fun=-1
            return
         endif
c     sparse matrix case
         it=istk(il0+3)
         m=istk(il0+1)
         mn=istk(il0+4)
         l=sadr(il0+5+m+mn)
         istk(ilr)=1
         istk(ilr+1)=1
         istk(ilr+2)=1
         istk(ilr+3)=it
         l1=sadr(ilr+4)
         if(it.eq.0) then
            stk(l1)=dsum(mn,stk(l),1)
         else
            stk(l1)=dsum(mn,stk(l),1)
            stk(l1+1)=dsum(mn,stk(l+mn),1)
         endif
         lstk(top+1)=l1+(it+1)
      else
c     other cases
         top=tops
         call funnam(ids(1,pt+1),'sum',iadr(lstk(top-rhs+1)))
         fun=-1
      endif
      return
      end

      subroutine intcumsum(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      logical ref
      integer sel,tops
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      if(lhs.ne.1) then
         call error(41)
         return
      endif
c
      sel=0
      tops=top
c
      il0=iadr(lstk(tops-rhs+1))
      ilr=il0
      if(istk(il0).lt.0) il0=iadr(istk(il0+1))
      ref=ilr.ne.il0
c
      if(istk(il0).ne.1) then
         top=tops
         call funnam(ids(1,pt+1),'cumsum',iadr(lstk(top-rhs+1)))
         fun=-1
         return
      endif

c     standard matrix case
      if(rhs.eq.2) then
         call getorient(top,sel)
         if(err.gt.0) return
         top=top-1
      endif

      m=istk(il0+1)
      n=istk(il0+2)
      it=istk(il0+3)
      l=sadr(il0+4)
      l1=sadr(ilr+4)
      mn=m*n

c
      if(ref) then
         err=l1+mn*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il0),1,istk(ilr),1)
         call dcopy(mn*(it+1),stk(l),1,stk(l1),1)
      endif
      lstk(top+1)=l1+mn*(it+1)
      if(mn.eq.0) return


      if(sel.eq.0) then
c     op(a) <=> op(a,'*')
         call cusum(mn,stk(l1))
         if(it.eq.1) call cusum(mn,stk(l1+mn))
      elseif(sel.eq.1) then
c     op(a,'r')  <=>  op(a,1)
         do 10 k=0,n-1
            call cusum(m,stk(l1+k*m))
 10      continue
         if(it.eq.1) then
            do 11 k=0,n-1
               call cusum(m,stk(l1+k*m+mn))
 11         continue
         endif
      elseif(sel.eq.2) then
c     op(a,'c')   <=>  op(a,2)
         kk=0
         do 20 k=1,n-1
	    call dadd(m,stk(l1+kk),1,stk(l1+kk+m),1)
            kk=kk+m
 20      continue
         if(it.eq.1) then
            kk=0
            do 21 k=1,n-1
               call dadd(m,stk(l1+mn+kk),1,stk(l1+kk+m+mn),1)
               kk=kk+m
 21         continue
         endif
      endif
      end

      subroutine intcumprod(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      logical ref
      integer sel,tops
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      if(lhs.ne.1) then
         call error(41)
         return
      endif
c
      tops=top
      sel=0
c
      il0=iadr(lstk(tops-rhs+1))
      ilr=il0
      if(istk(il0).lt.0) il0=iadr(istk(il0+1))
c
      if(istk(il0).ne.1) then
         top=tops
         call funnam(ids(1,pt+1),'cumprod',iadr(lstk(top)))
         fun=-1
         return
      endif
c     
c     standard matrix case
      if(rhs.eq.2) then
         call getorient(top,sel)
         if(err.gt.0) return
         top=top-1
      endif

      m=istk(il0+1)
      n=istk(il0+2)
      it=istk(il0+3)
      l=sadr(il0+4)
      l1=l
      mn=m*n
c
      if(ilr.ne.il0) then
         err=sadr(ilr+4)+mn*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il0),1,istk(ilr),1)
         l1=sadr(ilr+4)
         call dcopy(mn*(it+1),stk(l),1,stk(l1),1)
         il0=ilr
         l=l1
      endif
      if(mn.eq.0) return

c

      lstk(top+1)=l1+mn*(it+1)
      if(sel.eq.0) then
c     op(a) <=> op(a,'*')
         call cupro(mn,stk(l1))
         if(it.eq.1) call cupro(mn,stk(l1+mn))
      elseif(sel.eq.1) then
c     op(a,'r')  <=>  op(a,1)
         if(it.eq.0) then
            do 10 k=0,n-1
               call cupro(m,stk(l1+k*m))
 10         continue
         elseif(it.eq.1) then
            do 11 k=0,n-1
               call cuproi(m,stk(l1+k*m),stk(l1+k*m+mn))
 11         continue
         endif
      elseif(sel.eq.2) then
c     op(a,'c')   <=>  op(a,2)
         if(it.eq.0) then
            kk=0
            do 20 k=1,n-1
               call dvmul(m,stk(l1+kk),1,stk(l1+kk+m),1)
               kk=kk+m
 20         continue
         elseif(it.eq.1) then
            kk=0
            do 21 k=1,n-1
               call wvmul(m,stk(l1+kk),stk(l1+mn+kk),1,
     $              stk(l1+kk+m),stk(l1+kk+m+mn),1)
               kk=kk+m
 21         continue
         endif
      endif
      return
      end

      subroutine intprod(id)
c     WARNING : argument of this interface may be passed by reference
      INCLUDE '../stack.h'
      integer id(nsiz)
      logical ref
      integer sel,tops
      integer iadr,sadr
      double precision t,tr,ti
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      if(lhs.ne.1) then
         call error(41)
         return
      endif
c
      tops=top
      sel=0
c
      il0=iadr(lstk(tops-rhs+1))
      ilr=il0
      if(istk(il0).lt.0) il0=iadr(istk(il0+1))
      ref=ilr.ne.il0
c
      if(istk(il0).eq.1) then
c     standard matrix case
         if(rhs.eq.2) then
            call getorient(top,sel)
            if(err.gt.0) return
            top=top-1
         endif
         m=istk(il0+1)
         n=istk(il0+2)
         it=istk(il0+3)
         mn=m*n
         l1=sadr(ilr+4)
         l=sadr(il0+4)
         if(mn.eq.0) then
            if(ilr.ne.il0) then
               err=l1+1-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
            endif
            if(sel.eq.0) then
               istk(ilr)=1
               istk(ilr+1)=1
               istk(ilr+2)=1
               istk(ilr+3)=0
               stk(l1)=1.0d0
               lstk(top+1)=l1+1
            else
               istk(ilr)=1
               istk(ilr+1)=0
               istk(ilr+2)=0
               istk(ilr+3)=0
               lstk(top+1)=l1
            endif
            return
         endif

         if(sel.eq.0) then
            mr=1
            nr=1
         elseif(sel.eq.1) then
            mr=1
            nr=n
         else
            mr=m
            nr=1
         endif
         if(ref) then
            err=l1+mr*nr*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
         endif
         istk(ilr)=1
         istk(ilr+1)=mr
         istk(ilr+2)=nr
         istk(ilr+3)=it
         l1=sadr(ilr+4)

         if(ref) then
            if(it.eq.0) then
               call dmprod(sel,stk(l),m,m,n,stk(l1),1)
            else
               call wmprod(sel,stk(l),stk(l+m*n),m,m,n,stk(l1),
     $              stk(l1+mr*nr),1) 
            endif
         else
            if(it.eq.0) then
               call dmprod(sel,stk(l),m,m,n,stk(l1),1)
            else
               call wmprod(sel,stk(l),stk(l+m*n),m,m,n,stk(l),
     $              stk(l+m*n),1)  
               call dcopy(mr*nr,stk(l+m*n),-1,stk(l1+mr*nr),-1)
            endif
         endif
         lstk(top+1)=l1+mr*nr*(it+1)
      elseif(istk(il0).eq.5) then
c     sparse matrix case
         if(rhs.eq.2) then
            call getorient(top,sel)
            if(err.gt.0) return
            top=top-1
         endif
         if(sel.ne.0) then
            top=tops
            call funnam(ids(1,pt+1),'prod',iadr(lstk(top-rhs+1)))
            fun=-1
            return
         endif
         m=istk(il0+1)
         n=istk(il0+2)
         it=istk(il0+3)
         mn=istk(il0+4)
         l=sadr(il0+5+m+mn)
         lr=sadr(ilr+5+m+mn)
         if(ilr.ne.il0) then
            err=lr+(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
         endif
c         
         istk(ilr)=1
         istk(ilr+1)=1
         istk(ilr+2)=1
         istk(ilr+3)=it
         l1=sadr(ilr+4)
         if(mn.eq.m*n) then
            if(it.eq.0) then
               t=1.0d0
               call dvmul(mn,stk(l),1,t,0)
               stk(l1)=t
            else
               tr=1.0d0
               ti=0.0d0
               call wvmul(mn,stk(l),stk(l+mn),1,tr,ti,0)
               stk(l1)=tr
               stk(l1+1)=ti
            endif
         else
            stk(l1)=0.0d0
            istk(ilr+3)=0
            it=0
         endif
         lstk(top+1)=l1+it+1
c
      elseif(istk(il0).eq.2) then
         top=tops
         fin=9
         fun=16
         return
      else
         top=tops
         call funnam(ids(1,pt+1),'prod',iadr(lstk(top-rhs+1)))
         fun=-1
      endif
      return
      end



      subroutine getorient(k,sel)
      INCLUDE '../stack.h'
c
      integer sel,row,col,star
      integer iadr,sadr
c
      data row/27/,col/12/,star/47/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1

      sel=-1
      il=iadr(lstk(k))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).eq.1) then
         if(istk(il+1)*istk(il+2).ne.1) then
            err=2
            call error(89)
            return
         endif
         sel=stk(sadr(il+4))
         if(sel.ne.1.and.sel.ne.2) then
            err=2
            call error(44)
            return
         endif
      elseif (istk(il).eq.10) then
         if(istk(il+1)*istk(il+2).ne.1) then
            err=2
            call error(89)
            return
         endif
         if(istk(il+6).eq.row) then
            sel=1
         elseif(istk(il+6).eq.col) then
            sel=2
         elseif(istk(il+6).eq.star) then
            sel=3
         else
            err=2
            call error(44)
            return
         endif
      else
         err=2
         call error(44)
         return
      endif
      return
      end

      subroutine intdiag(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

c
      integer tops
      logical ref
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.gt.2) then
         call error(42)
         return
      endif

      tops=top
c
      k = 0
      if (rhs .eq. 2) then
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=1
            call  error(53)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call  error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         k = int(stk(sadr(il+4)))
         top = top-1
      endif
c
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).eq.1) then
c     standard matrix case
         m=istk(il+1)
         n=istk(il+2)
         mn=m*n
         it=istk(il+3)
         l=sadr(il+4)
         ref=il.ne.ilr
         lr=sadr(ilr+4)

         if (m .eq. 1 .or. n .eq. 1) go to 63
c     
c     .  diag(a,k) with a a matrix
         if (k.ge.0) then
            mn=max(0,min(m,n-k))
         else
            mn=max(0,min(m+k,n))
         endif
         if(ref) then
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
         endif
         if(mn.eq.0) then
            istk(ilr)=1
            istk(ilr+1)=0
            istk(ilr+2)=0
            istk(ilr+3)=0
            lstk(top+1)=sadr(ilr+4)+1
            return
         else
            istk(ilr)=1
            istk(ilr+1)=mn
            istk(ilr+2)=1
            istk(ilr+3)=it
            lstk(top+1)=lr+istk(ilr+1)*(it+1)
            if(k.ge.0) then
               call dcopy(mn,stk(l+k*m),m+1,stk(lr),1)
            else
               call dcopy(mn,stk(l-k),m+1,stk(lr),1)
            endif
            if(it.eq.0) return
            if(k.ge.0) then
               call dcopy(mn,stk(l+m*n+k*m),m+1,stk(lr+mn),1)
            else
               call dcopy(mn,stk(l+m*n-k),m+1,stk(lr+mn),1)
            endif
         endif
         return

c     .  diag(vector,k)
 63      nn = max(m,n)+abs(k)
         l1=lr+nn*nn*(it+1)
         err = l1 + mn*(it+1) -  lstk(bot)
         if (err .gt. 0) then
            call error(17)
            return
         endif
         istk(ilr)=1
         istk(ilr+1)=nn
         istk(ilr+2)=nn
         istk(ilr+3)=it
         lstk(top+1)=lr+nn*nn*(it+1)
         if(ref) then
            l1=l
         else
            call dcopy(mn*(it+1),stk(l),-1,stk(l1),-1)
         endif
         call dset(nn*nn*(it+1),0.0d+0,stk(lr),1)
         if(k.ge.0) then
            call dcopy(mn,stk(l1),1,stk(lr+nn*k),nn+1)
         else
            call dcopy(mn,stk(l1),1,stk(lr-k),nn+1)
         endif
         if(it.eq.0) return
         if(k.ge.0) then
            call dcopy(mn,stk(l1+mn),1,stk(lr+nn*nn+k*nn),nn+1)
         else
            call dcopy(mn,stk(l1+mn),1,stk(lr+nn*nn-k),nn+1)
         endif
      elseif(istk(il).eq.2) then
c       *call* polelm
         fun=16
         fin=10
         top=tops
      else
         top=tops
         call funnam(ids(1,pt+1),'diag',iadr(lstk(top-rhs+1)))
         fun=-1
      endif
      return
      end

      subroutine inttriu(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

c
      integer tops
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.gt.2) then
         call error(42)
         return
      endif

      tops=top
c
      k = 0
      if (rhs .eq. 2) then
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=1
            call  error(53)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call  error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         k = int(stk(sadr(il+4)))
         top = top-1
      endif


      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).eq.1) then
c     standard matrix case
         m=istk(il+1)
         n=istk(il+2)
         mn=m*n
         it=istk(il+3)
         l=sadr(il+4)

         if(il.ne.ilr) then
            lr=sadr(ilr+4)
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il),1,istk(ilr),1)
            call dcopy(mn*(it+1),stk(l),1,stk(lr),1)
            lstk(top+1)=lr+mn*(it+1)
            l=lr
         endif
c
         if(k.le.0) goto 65
         call dset(m*k,0.0d+0,stk(l),1)
         if(it.eq.1) call dset(m*k,0.0d+0,stk(l+mn),1)
         l=l+m*k
         n=n-k
         k=0
 65      ls=l+1-k
         ll=m-1+k
         do 66 j=1,n
            if(ll.le.0) return
            call dset(ll,0.0d+0,stk(ls),1)
            if(it.eq.1) call dset(ll,0.0d+0,stk(ls+mn),1)
            ll=ll-1
            ls=ls+m+1
 66      continue
      elseif(istk(il).eq.2) then
c       *call* polelm
         top=tops
         fun=16
         fin=11
      else
         top=tops
         call funnam(ids(1,pt+1),'triu',iadr(lstk(top-rhs+1)))
         fun=-1
      endif
      return
      end

      subroutine inttril(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      integer tops
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.gt.2) then
         call error(42)
         return
      endif

      tops=top
c
      k = 0
      if (rhs .eq. 2) then
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=1
            call  error(53)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call  error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         k = int(stk(sadr(il+4)))
         top = top-1
      endif
c
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).eq.1) then
c     standard matrix case
         m=istk(il+1)
         n=istk(il+2)
         mn=m*n
         it=istk(il+3)
         l=sadr(il+4)

         if(il.ne.ilr) then
            lr=sadr(ilr+4)
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il),1,istk(ilr),1)
            call dcopy(mn*(it+1),stk(l),1,stk(lr),1)
            lstk(top+1)=lr+mn*(it+1)
            l=lr
         endif

         if(k.ge.0) then
            l=l+m*(k+1)
            n=n-k-1
            k=-1
         endif
         ls=l
         ll=-k
         do 69 j=1,n
            if(ll.gt.m) ll=m
            call dset(ll,0.0d+0,stk(ls),1)
            if(it.eq.1) call dset(ll,0.0d+0,stk(ls+mn),1)
            ls=ls+m
            ll=ll+1
 69      continue
      elseif(istk(il).eq.2) then
c     polynomial matrix case
c     .  *call* polelm
         top=tops
         fun=16
         fin=12
         return
      else
         top=tops
         call funnam(ids(1,pt+1),'tril',iadr(lstk(top-rhs+1)))
         fun=-1
         return
      endif
      return
      end

      subroutine inteye(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      integer tops,speye(nsiz)
      double precision s
      integer iadr,sadr
      data speye/571349276,673720334,4*673720360/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.gt.2) then
         call error(42)
         return
      endif

      tops=top
c
      if(rhs.le.0) then
c     eye sans argument
         top=top+1
         m=-1
         n=-1
      elseif(rhs.eq.1) then
         il=iadr(lstk(top))
         
         if(abs(istk(il)).gt.10) then
            call funnam(ids(1,pt+1),'eye',il)
            fun=-1
            return
         endif
         if(abs(istk(il)).eq.5.or.abs(istk(il)).eq.6) then
            call putid(ids(1,pt+1),speye)
            fun=-1
            return
         endif
         if(istk(il).lt.0) il=iadr(istk(il+1))
         m=istk(il+1)
         n=istk(il+2)
c     eye(matrice)
      elseif(rhs.eq.2) then
c     eye(m,n)
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=1
            call  error(53)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call  error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         n=max(int(stk(sadr(il+4))),0)
c
         top=top-1
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=1
            call  error(53)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call  error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         m=max(int(stk(sadr(il+4))),0)
      endif
c
      mn=m*n
      if(m.eq.0) n=0
      if(n.eq.0) m=0

      il=iadr(lstk(top))
      l=sadr(il+4)

c     to avoid integer overflow
      s=l+dble(m)*dble(n)- lstk(bot)
      if(s.gt.0.0d0) then
         err=s
         call error(17)
         return
      endif
      istk(il)=1
      istk(il+1)=m
      istk(il+2)=n
      istk(il+3)=0
      lstk(top+1)=l+mn
      if(mn.ne.0) then
         m=abs(m)
         call dset(mn,0.0d+0,stk(l),1)
         call dset(min(m,abs(n)),1.0d+0,stk(l),m+1)
      endif
      return
      end


      subroutine intones(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      integer tops
      double precision s
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.gt.2) then
         call error(42)
         return
      endif

      tops=top
c

      if(rhs.le.0) then
c     ones sans argument
         top=top+1
         m=1
         n=1
      elseif(rhs.eq.1) then
         il=iadr(lstk(top))
         if(abs(istk(il)).gt.10) then
            call funnam(ids(1,pt+1),'ones',il)
            fun=-1
            return
         endif
         if(istk(il).lt.0) il=iadr(istk(il+1))
         m=istk(il+1)
         n=istk(il+2)
c     ones(matrice)
      elseif(rhs.eq.2) then
c     ones(m,n)
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=1
            call  error(53)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call  error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         n=max(int(stk(sadr(il+4))),0)
c
         top=top-1
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=1
            call  error(53)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call  error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         m=max(int(stk(sadr(il+4))),0)
      endif
c
      mn=m*n
      if(m.eq.0) n=0
      if(n.eq.0) m=0

      il=iadr(lstk(top))
      l=sadr(il+4)

c     to avoid integer overflow
      s=l+dble(m)*dble(n)- lstk(bot)
      if(s.gt.0.0d0) then
         err=s
         call error(17)
         return
      endif
      istk(il)=1
      istk(il+1)=m
      istk(il+2)=n
      istk(il+3)=0
      lstk(top+1)=l+mn
      if(mn.eq.0) return
      call dset(mn,1.0d+0,stk(l),1)
      return
      end

      subroutine intsort(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      integer tops,sel
      integer iadr,sadr
      integer modtest,rptest
      external modtest,rptest
c
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      tops=top
c
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      il=iadr(lstk(top+1-rhs))

      if(abs(istk(il)).eq.10) then
c     *call* strelm
         fun=21
         fin=8
         return
      endif
      if(abs(istk(il)).ne.1) then
         call funnam(ids(1,pt+1),'sort',iadr(lstk(top-rhs+1)))
         fun=-1
         return
      endif

c     select type of sort to perform
      sel=0
      if(rhs.eq.2) then
         call  getorient(top,sel)
         if(err.gt.0) return
         top=top-1
      endif

      if(sel.eq.2) then
c        sort(a,'c')   <=>  sort(a,2)   The lazy way...
         top=tops
         call funnam(ids(1,pt+1),'sort',iadr(lstk(top-rhs+1)))
         fun=-1
         return
      endif

      il0=iadr(lstk(top))
      if(istk(il0).lt.0) then
c     array is passed by reference copy it on the top of the stack
         k=istk(il0+2)
         err=lstk(top)+lstk(k+1)-lstk(k)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dcopy(lstk(k+1)-lstk(k),stk(lstk(k)),1
     $        ,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lstk(k+1)-lstk(k)
      endif

      m=istk(il0+1)
      n=istk(il0+2)
      it=istk(il0+3)
      mn=m*n
c     
      if(mn.eq.0) then
         if(lhs.eq.1) return
         top=top+1
         il=iadr(lstk(top))
         istk(il)=1
         istk(il+1)=0
         istk(il+2)=0
         istk(il+3)=0
         lstk(top+1)=sadr(il+4)
         return
      endif
c
      lw=iadr(lstk(top+1))
      err=sadr(lw+mn)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c
      if(sel.eq.0) then
c     sort(a) <=> sort(a,'*')
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         if(it.eq.0) then
            call dsort(stk(l1),mn,istk(lw))
         else
            call wsort(stk(l1),stk(l1+mn),mn,istk(lw),modtest)
         endif
         lstk(top+1)=l1+mn*(it+1)
         if(lhs.eq.1) return
         top=top+1
         il=lw
         l1=sadr(il+4)+mn
         l2=lw+mn
         err=l1-lstk(bot)
         if(err.gt.0) then
            call error(17)
         return
         endif
         lstk(top+1)=l1
         do 106 i=1,mn
           stk(l1-i)=dble(istk(l2-i))
  106    continue
         istk(il)=1
         istk(il+1)=m
         istk(il+2)=n
         istk(il+3)=0
      elseif(sel.eq.1) then
c     sort(a,'r')  <=>  sort(a,1)
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         lw1=lw
         if(it.eq.0) then
            do 107 k=0,n-1
               call dsort(stk(l1+k*m),m,istk(lw1))
               lw1=lw1+m
 107        continue
         else
            do 108 k=0,n-1
               call wsort(stk(l1+k*m),stk(l1+mn+k*m),mn,istk(lw1),
     $              modtest)
              lw1=lw1+m
 108        continue
         endif
         lstk(top+1)=l1+mn*(it+1)
c              cccccccccccc
         if(lhs.eq.1) return
         top=top+1
         il=lw
         l1=sadr(il+4)+mn
         l2=lw+mn
         err=l1-lstk(bot)
         if(err.gt.0) then
            call error(17)
         return
         endif
         lstk(top+1)=l1
         do 109 i=1,mn
           stk(l1-i)=dble(istk(l2-i))
  109    continue
         istk(il)=1
         istk(il+1)=m
         istk(il+2)=n
         istk(il+3)=0
      elseif(sel.eq.2) then
c     implemented by a call to a function see above
      endif
      return
      end

      subroutine intkron(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      integer tops
      logical refa,refb
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      tops=top
c
      if (rhs .ne. 2) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif

      il=iadr(lstk(top))
      ilb=il
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).ne.1) then
         if(fin.eq.19) then
            call funnam(ids(1,pt+1),'kronm',iadr(lstk(top-rhs+1)))
         elseif(fin.eq.20) then
            call funnam(ids(1,pt+1),'kronr',iadr(lstk(top-rhs+1)))
         else
            call funnam(ids(1,pt+1),'kronl',iadr(lstk(top-rhs+1)))
         endif
         fun=-1
         return
      endif
      refb=il.ne.ilb
      mb=istk(il+1)
      nb=istk(il+2)
      itb=istk(il+3)
      lb=sadr(il+4)
      mnb=mb*nb
      top=top-1

      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).ne.1) then
         top=tops
         if(fin.eq.19) then
            call funnam(ids(1,pt+1),'kronm',iadr(lstk(top)))
         elseif(fin.eq.20) then
            call funnam(ids(1,pt+1),'kronr',iadr(lstk(top)))
         else
            call funnam(ids(1,pt+1),'kronl',iadr(lstk(top)))
         endif
         fun=-1
         return
      endif
      refa=il.ne.ilr
      ma=istk(il+1)
      na=istk(il+2)
      ita=istk(il+3)
      la=sadr(il+4)
      mna=ma*na
c
      if(fin.eq.19) goto 115
      if(fin.eq.20) goto 111
      l=la
      mn=mna
      it=ita
  111 if(it.eq.1) goto 113
      do 112 k=1,mn
         lk=l+k-1
         if(stk(lk).eq.0.0d+0) then
            call error(27)
            return
         endif
         stk(lk)=1.0d+0/stk(lk)
 112  continue
      goto 115
  113 do 114 k=1,mn
         lk=l+k-1
         sr=stk(lk)
         si=stk(lk+mn)
         s=sr*sr+si*si
         if(s.eq.0.0d+0) then
            call error(27)
            return
         endif
         stk(lk)=sr/s
         stk(lk+mn)=-si/s
 114  continue
c
 115  continue
      l=sadr(ilr+4)
      l1=l+mnb*mna*(max(itb,ita)+1)
      lstk(top+1)=l1
c
c move a and b if necessary
      lw=l1
      if(.not.refb) lw=lw+mnb*(itb+1)
      if(.not.refa) lw=lw+mna*(ita+1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      lw=l1
      if(.not.refb) then
         call dcopy(mnb*(itb+1),stk(lb),-1,stk(lw),-1)
         lb=lw
         lw=lw+mnb*(itb+1)
      endif
      if(.not.refa) then
         call dcopy(mna*(ita+1),stk(la),-1,stk(lw),-1)
         la=lw
      endif
      goto(117,116,118) itb+2*ita
c a et b sont reelles
      call kronr(stk(la),ma,ma,na,stk(lb),mb,mb,nb,stk(l),ma*mb)
      goto 999
c a est complexe b est reelle
  116 call kronr(stk(la),ma,ma,na,stk(lb),mb,mb,nb,stk(l),ma*mb)
      call kronr(stk(la+mna),ma,ma,na,stk(lb),mb,mb,nb,stk(l+mnb*mna),
     1 ma*mb)
      goto 999
c a est reelle b complexe
  117 call kronr(stk(la),ma,ma,na,stk(lb),mb,mb,nb,stk(l),ma*mb)
      call kronr(stk(la),ma,ma,na,stk(lb+mnb),mb,mb,nb,
     1 stk(l+mnb*mna),ma*mb)
      goto 999
  118 call kronc(stk(la),stk(la+mna),ma,ma,na,stk(lb),stk(lb+mnb),
     1 mb,mb,nb,stk(l),stk(l+mnb*mna),ma*mb)
      goto 999
 999  continue
      istk(ilr)=1
      istk(ilr+1)=mb*ma
      istk(ilr+2)=nb*na
      istk(ilr+3)=max(itb,ita)
      return
      end

      subroutine intmatrix(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      integer tops,top2
      integer iadr,sadr
      logical ref
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      tops=top

      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.lt.2) then
         call error(39)
         return
      endif
      if(rhs.gt.3) then
        top=tops
         call ref2val
         call funnam(ids(1,pt+1),'matrix',iadr(lstk(top-rhs+1)))
         fun=-1
         return
      endif

      top2=top-rhs+1
      il2=iadr(lstk(top2))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))


c changement de dimension d'une matrice
      il=iadr(lstk(top+1-rhs))

      if(abs(istk(il)).eq.5.or.abs(istk(il)).eq.6) then
         top=tops
         call ref2val
         fin=12
         fun=27
c        *call* spelm
         return
      endif

      ityp=abs(istk(il))
      if(ityp.ne.1.and.ityp.ne.2
     $     .and.ityp.ne.4.and.ityp.ne.10) then
         top=tops
         call ref2val
         call funnam(ids(1,pt+1),'matrix',iadr(lstk(top-rhs+1)))
         fun=-1
         return
      endif

      il=iadr(lstk(top))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).ne.1) then
         err=3
         call error(53)
         return
      endif
      if(rhs.eq.2) then
         if(istk(il+3).ne.0) then
            err=3
            call error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).eq.1) then
            m=int(stk(sadr(il+4)))
            n=1
         elseif(istk(il+1)*istk(il+2).eq.2) then
            m=int(stk(sadr(il+4)))
            n=int(stk(sadr(il+4)+1))
         else
            top=tops
            call ref2val
            call funnam(ids(1,pt+1),'matrix',iadr(lstk(top-rhs+1)))
            fun=-1
            return
         endif
      else
         if(istk(il+1)*istk(il+2).ne.1) then
            err=3
            call error(89)
            return
         endif
         if(istk(il+3).ne.0) then
            err=3
            call error(52)
            return
         endif
         n=int(stk(sadr(il+4)))
c     
         top=top-1
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=2
            call error(53)
            return
         endif

         if(istk(il+1)*istk(il+2).ne.1) then
            err=2
            call error(89)
            return
         endif
         if(istk(il+3).ne.0) then
            err=2
            call error(52)
            return
         endif
         m=int(stk(sadr(il+4)))
      endif
c
      top=top-1
      il=iadr(lstk(top))
      ilr=il
      if(istk(il).lt.0) then
         k=istk(il+2)
         err=lstk(top)+lstk(k+1)-lstk(k)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dcopy(lstk(k+1)-lstk(k),stk(lstk(k)),1,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lstk(k+1)-lstk(k)
      endif


      if(m*n.ne.istk(il+1)*istk(il+2)) then
         call error(60)
         return
      endif
      if(m*n.eq.0) then
         istk(il+1)=0
         istk(il+2)=0
      else
         istk(il+1)=m
         istk(il+2)=n
      endif
 999  return
      end

      subroutine intsin(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      double precision sr,si
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs .ne. 1) then
         call error(42)
         return
      endif

      il=iadr(lstk(top))
      
      if(abs(istk(il)).ne.1) then
         call funnam(ids(1,pt+1),'sin',iadr(lstk(top)))
         fun=-1
         return
      endif

      if(istk(il).lt.0) then
c     argument is passed by reference
         ilr=il
         il=iadr(istk(il+1))
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=sadr(ilr+4)
         err=lr+mn*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il),1,istk(ilr),1)
         lstk(top+1)=lr+mn*(it+1)
      else
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=l
      endif
      
      if(mn.eq.0) return
      if(it.eq.0) then
         do 10 i=0,mn-1
            stk(lr+i)=sin(stk(l+i))
 10      continue
      else
         do 11 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            stk(lr+i)=sin(sr)*cosh(si)
            stk(lr+i+mn)=cos(sr)*sinh(si)
 11      continue
      endif
      return
      end

      subroutine intcos(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      double precision sr,si
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c

      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs .ne. 1) then
         call error(42)
         return
      endif

      il=iadr(lstk(top))
      
      if(abs(istk(il)).ne.1) then
         call funnam(ids(1,pt+1),'cos',iadr(lstk(top)))
         fun=-1
         return
      endif

      if(istk(il).lt.0) then
c     argument is passed by reference
         ilr=il
         il=iadr(istk(il+1))
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=sadr(ilr+4)
         err=lr+mn*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il),1,istk(ilr),1)
         lstk(top+1)=lr+mn*(it+1)
      else
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=l
      endif
      
      if(mn.eq.0) return

      if(it.eq.0) then
         do 151 i=0,mn-1
            stk(lr+i)=cos(stk(l+i))
 151     continue
      else
         do 152 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            stk(lr+i)=cos(sr)*cosh(si)
            stk(lr+i+mn)=-sin(sr)*sinh(si)
 152     continue
      endif
      return
      end


      subroutine intatan(id)
      INCLUDE '../stack.h'
      integer id(nsiz),tops

      double precision sr,si
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c

      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs .ne. 1.and.rhs .ne. 2) then
         call error(42)
         return
      endif
      tops=top

      il=iadr(lstk(top+1-rhs))
      
      if(abs(istk(il)).ne.1) then
         call funnam(ids(1,pt+1),'atan',iadr(lstk(top-rhs+1)))
         fun=-1
         return
      endif

      if(rhs.eq.1) then
c     atan with only argument
         il=iadr(lstk(top))
         if(istk(il).lt.0) then
c     .     argument is passed by reference
            ilr=il
            il=iadr(istk(il+1))
            mn=istk(il+1)*istk(il+2)
            it=istk(il+3)
            l=sadr(il+4)
            lr=sadr(ilr+4)
            err=lr+mn*(it+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il),1,istk(ilr),1)
            lstk(top+1)=lr+mn*(it+1)
         else
c     .     argument is passed by value
            mn=istk(il+1)*istk(il+2)
            it=istk(il+3)
            l=sadr(il+4)
            lr=l
         endif
         
         if(mn.eq.0) return
         if(it.eq.0) then
            do 10 i=0,mn-1
               stk(lr+i)=atan(stk(l+i))
 10         continue
         else
            do 11 i=0,mn-1
               sr=stk(l+i)
               si=stk(l+mn+i)
               if(abs(sinh(sr)).eq.1.0d+0.and.si.eq.0.0d+0) then
                  if(ieee.eq.0) then
                     call error(32)
                     return
                  elseif(ieee.eq.1) then
                     call msgs(64)
                  endif
               endif
               call watan(sr,si,stk(lr+i),stk(lr+i+mn))
 11         continue
         endif
      else
         il2=iadr(lstk(top))
         if(istk(il2).lt.0) il2=iadr(istk(il2+1))
         l2=sadr(il2+4)
         top=top-1
         il1=iadr(lstk(top))
         if(abs(istk(il1)).ne.1.or.istk(il2).ne.1) then
            top=tops
            call funnam(ids(1,pt+1),'atan',iadr(lstk(top-rhs+1)))
            fun=-1
            return
         endif
         if(istk(il1).lt.0) then
c     .     first argument is passed by reference
            ilr=il1
            il1=iadr(istk(il1+1))
            mn1=istk(il1+1)*istk(il1+2)
            it1=istk(il1+3)
            l1=sadr(il1+4)
            lr=sadr(ilr+4)
            err=lr+mn1*(it1+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(4,istk(il1),1,istk(ilr),1)
            lstk(top+1)=lr+mn1
         else
c     .     argument is passed by value
            mn1=istk(il1+1)*istk(il1+2)
            it1=istk(il1+3)
            l1=sadr(il1+4)
            lr=l1
         endif
         if(istk(il2+3).ne.0.or.it1.ne.0) then
            call error(43)
            return
         endif  
         if(istk(il2+1)*istk(il2+2).ne.mn1) then
            call error(60)
            return
         endif
         if(mn1.eq.0) return
         do 20 i=0,mn1
            if(abs(stk(l1+i))+abs(stk(l2+i)).eq.0.0d+0) then
               if(ieee.eq.0) then
                  call error(32)
                  return
               elseif(ieee.eq.1) then
                  call msgs(64)
               endif
            endif
            stk(lr+i)=atan2(stk(l1+i),stk(l2+i))
 20      continue
      endif
      return
      end

      subroutine intexp(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      double precision sr,si
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs .ne. 1) then
         call error(42)
         return
      endif

      il=iadr(lstk(top))
      
      if(abs(istk(il)).ne.1) then
         call funnam(ids(1,pt+1),'exp',iadr(lstk(top)))
         fun=-1
         return
      endif

      if(istk(il).lt.0) then
c     argument is passed by reference
         ilr=il
         il=iadr(istk(il+1))
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=sadr(ilr+4)
         err=lr+mn*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il),1,istk(ilr),1)
         lstk(top+1)=lr+mn*(it+1)
      else
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=l
      endif
      
      if(mn.eq.0) return

      if(it.eq.0) then
         do 10 i=0,mn-1
            stk(lr+i)=exp(stk(l+i))
 10      continue
      else
         do 11 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            stk(lr+i)=exp(sr)*cos(si)
            stk(lr+i+mn)=exp(sr)*sin(si)
 11      continue
      endif
      return
      end

      subroutine intexpm(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      double precision sr,si
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs .ne. 1) then
         call error(42)
         return
      endif

      il=iadr(lstk(top))
      
      if(abs(istk(il)).ne.1) then
         call funnam(ids(1,pt+1),'expm',iadr(lstk(top)))
         fun=-1
         return
      endif

      if(istk(il).lt.0) then
c     argument is passed by reference
         ilr=il
         il=iadr(istk(il+1))
         m=istk(il+1)
         n=istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=sadr(ilr+4)
         err=lr+m*n*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il),1,istk(ilr),1)
         call dcopy(m*n*(it+1),stk(l),1,stk(lr),1)
         lstk(top+1)=lr+m*n*(it+1)
      else
         m=istk(il+1)
         n=istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=l
      endif

      nn=m*n
      if(nn.eq.0) return

      if(m.ne.n) then
         err=1
         call error(2)
         return
      endif

      le=lstk(top+1)
      lw=le+nn*(it+1)
      ilb=iadr(lw+4*nn*(it+1)+5*n+2*n*it)
      err=sadr(ilb+n+n)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif

      if(it.eq.0) then
         call dexpm1(n,n,stk(lr),stk(le),n,stk(lw),istk(ilb),err)
      else
         call wexpm1(n,stk(lr),stk(lr+nn),n,stk(le),stk(le+nn),
     *        n,stk(lw),istk(ilb),err)
      endif
      if(err.ne.0) then
         call error(24)
         return
      endif
      call dcopy(nn*(it+1),stk(le),1,stk(lr),1)
      return
      end

      subroutine intsqrt(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      double precision sr,si
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs .ne. 1) then
         call error(42)
         return
      endif

      il=iadr(lstk(top))
      
      if(abs(istk(il)).ne.1) then
         call funnam(ids(1,pt+1),'sqrt',iadr(lstk(top)))
         fun=-1
         return
      endif

      if(istk(il).lt.0) then
c     argument is passed by reference
         ilr=il
         il=iadr(istk(il+1))
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=sadr(ilr+4)
         err=lr+mn*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il),1,istk(ilr),1)
         lstk(top+1)=lr+mn*(it+1)
      else
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=l
         ilr=il
      endif
      
      if(mn.eq.0) return

      if(it.eq.0) then
         itr=0
         do 10 i=0,mn-1
            if(stk(l+i).lt.0.0d+0) then
               itr=1
               goto 20
            endif
 10      continue

 20      if(itr.eq.0) then
c     .  argument is real non negative
            do 21 i=0,mn-1
               stk(lr+i)=sqrt(stk(l+i))
 21         continue
         else
c     .  argument is real with negative entries
            err=lr+2*mn-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            lstk(top+1)=lr+2*mn
            do 22 i=0,mn-1
               call wsqrt(stk(l+i),0.0d+0,stk(lr+i),stk(lr+mn+i))
 22         continue
            istk(ilr+3)=itr
         endif
      else
c     argument is complex
         do 30 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            call wsqrt(sr,si,stk(lr+i),stk(lr+i+mn))
 30      continue
      endif
      return
      end

      subroutine intlog(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      double precision sr,si
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs .ne. 1) then
         call error(42)
         return
      endif

      il=iadr(lstk(top))
      
      if(abs(istk(il)).ne.1) then
         call funnam(ids(1,pt+1),'log',iadr(lstk(top)))
         fun=-1
         return
      endif

      if(istk(il).lt.0) then
c     argument is passed by reference
         ilr=il
         il=iadr(istk(il+1))
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=sadr(ilr+4)
         err=lr+mn*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il),1,istk(ilr),1)
         lstk(top+1)=lr+mn*(it+1)
      else
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=l
         ilr=il
      endif
      
      if(mn.eq.0) return

      if(it.eq.0) then
         itr=0
         do 10 i=0,mn-1
            if(stk(l+i).lt.0.0d+0) then
               itr=1
               goto 20
            elseif(stk(l+i).eq.0.0d+0) then
               if(ieee.eq.0) then
                  call error(32)
                  return
               elseif(ieee.eq.1) then
                  call msgs(64)
               endif
               goto 20
            endif
 10      continue

 20      if(itr.eq.0) then
c     .     argument is a real positive matrix
            do 193 i=0,mn-1
               stk(lr+i)=log(stk(l+i))
 193        continue
         else
c     .     argument is a real matrix with negative entries
            err=lr+2*mn-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            lstk(top+1)=lr+2*mn
            do 194 i=0,mn-1
               call wlog(stk(l+i),0.0d+0,stk(lr+i),stk(lr+mn+i))
 194        continue
            istk(ilr+3)=itr
         endif
      else
c     argument is a complex matrix
         do 195 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            if(sr*sr+si*si.eq.0.0d+0) then
               if(ieee.eq.0) then
                  call error(32)
                  return
               elseif(ieee.eq.1) then
                  call msgs(64)
               endif
            endif
            call wlog(sr,si,stk(lr+i),stk(lr+i+mn))
 195     continue
      endif
      return
      end


      subroutine intsign(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      double precision sr,si,pythag
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs .ne. 1) then
         call error(42)
         return
      endif

      il=iadr(lstk(top))
      
      if(abs(istk(il)).ne.1) then
         call funnam(ids(1,pt+1),'sign',iadr(lstk(top)))
         fun=-1
         return
      endif

      if(istk(il).lt.0) then
c     argument is passed by reference
         ilr=il
         il=iadr(istk(il+1))
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=sadr(ilr+4)
         err=lr+mn*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il),1,istk(ilr),1)
         lstk(top+1)=lr+mn*(it+1)
      else
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=l
         ilr=il
      endif
      
      if(mn.eq.0) return

      if(it.eq.0) then
         do 10 i=0,mn-1
            if(stk(l+i).gt.0.d0) then
               stk(lr+i)=1.d0
            elseif(stk(l+i).lt.0.d0) then
               stk(lr+i)=-1.d0
            else
               stk(lr+i)=0.0d0
            endif
 10      continue
      else
         do 20 i=0,mn-1
            sr=pythag(stk(l+i),stk(l+mn+i))
            if(sr.eq.0) then
               stk(lr+i)=0.0d0
               stk(lr+mn+i)=0.0d0
            else
               stk(lr+i)=stk(l+i)/sr
               stk(lr+mn+i)=stk(l+mn+i)/sr
            endif
 20      continue
      endif
      return
      end

      subroutine intclean(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      double precision sr,si,pythag,epsa,epsr,norm,eps
      double precision dasum,wasum
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs .lt. 1 .or. rhs .gt. 3) then
         call error(42)
         return
      endif

      ilp=iadr(lstk(top+1-rhs))
      if(abs(istk(ilp)).eq.2) then
         fin=17
         fun=16
c        *call* polelm
         return
      elseif(abs(istk(ilp)).eq.5) then
         call ref2val
         fin=8
         fun=27
c        *call* spelm
         return
      elseif(abs(istk(ilp)).ne.1) then
         call funnam(ids(1,pt+1),'clean',iadr(lstk(top-rhs+1)))
         fun=-1
         return
      endif

c     get relative and absolute tolerances
      epsr=1.0d-10
      epsa=1.0d-10

      if (rhs.eq.3) then
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=3
            call error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=3
            call error(60)
            return
         endif
         if(istk(il+3).ne.0) then
            err=3
            call error(52)
            return
         endif
         epsr=stk(sadr(il+4))
         top=top-1
      endif

      if (rhs.ge.2) then
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=3
            call error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=3
            call error(60)
            return
         endif
         if(istk(il+3).ne.0) then
            err=3
            call error(52)
            return
         endif
         epsa=stk(sadr(il+4))
         top=top-1
      endif

      il=iadr(lstk(top))
      
      if(istk(il).lt.0) then
c     argument is passed by reference
         ilr=il
         il=iadr(istk(il+1))
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=sadr(ilr+4)
         err=lr+mn*(it+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(4,istk(il),1,istk(ilr),1)
         call dcopy(mn*(it+1),stk(l),1,stk(lr),1)
         lstk(top+1)=lr+mn*(it+1)
      else
         mn=istk(il+1)*istk(il+2)
         it=istk(il+3)
         l=sadr(il+4)
         lr=l
         ilr=il
      endif
      
      if(mn.eq.0) return

      if(it.eq.0) then
         norm=dasum(mn,stk(lr),1)
      else
         norm=wasum(mn,stk(lr),stk(lr+mn),1)
      endif
      eps=max(epsa,epsr*norm)
      do 10 kk=0,mn*(it+1)
         if (abs(stk(lr+kk)).le.eps) stk(lr+kk)=0.d0
 10   continue

      return
      end

      subroutine inttestmatrix(id)
      INCLUDE '../stack.h'
      integer id(nsiz)

      integer tops,top2
      integer magi,frk,hilb
      integer iadr,sadr
      logical ref
      data magi/22/,frk/15/,hilb/17/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      tops=top

      if (lhs .ne. 1) then
         call error(41)
         return
      endif

      top2=top-rhs+1
      il2=iadr(lstk(top2))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))
      if(istk(il2).ne.10) then
         err=1
         call error(55)
         return
      endif
      kletr=abs(istk(il2+5+istk(il2+1)*istk(il2+2)))

      il=iadr(lstk(top))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      l=sadr(il+4)
      n=max(int(stk(l)),0)
c
      top=top-1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=n
      istk(il+2)=n
      istk(il+3)=0
      l=sadr(il+4)
      lstk(top+1)=l+n*n
      err=lstk(top+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(kletr.eq.magi) goto 131
      if(kletr.eq.hilb) goto 132
      if(kletr.eq.frk) goto 133
c
c     carre magique
  131 if (n .eq. 2) n = 0
      if (n .gt. 0) call magic(stk(l),n,n)
      istk(il+1)=n
      istk(il+2)=n
      lstk(top+1)=l+n*n
      go to 999
c
c     hilbert
 132  call hilber(stk(l),n,n)
      go to 999
c
c matrice de franck
 133  continue
      job=0
      if (n .gt. 0) call franck(stk(l),n,n,job)
      go to 999
 999  return
      end

      subroutine intisreal(id)
      INCLUDE '../stack.h'
      integer id(nsiz)
      double precision eps,mx
      integer tops,top2
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.ne.1.and.rhs.ne.2) then
         call error(39)
         return
      endif
      
      if(rhs.eq.1) then
c     .  check for  real storage
         il=iadr(lstk(top))
         ilr=il
         if(istk(il).lt.0) il=iadr(istk(il+1))
         it=istk(il+3)
         
         if(istk(il).eq.1.or.istk(il).eq.2.or.istk(il).eq.5) then
            istk(ilr)=4
            istk(ilr+1)=1
            istk(ilr+2)=1
            istk(ilr+3)=abs(1-it)
            lstk(top+1)=sadr(ilr+4)
         else
            call ref2val
            call funnam(ids(1,pt+1),'isreal',iadr(lstk(top)))
            fun=-1
            return
         endif
      else
c     .  check for zero imaginary part
         il=iadr(lstk(top))
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1) then
            err=2
            call error(53)
            return
         endif
         eps=stk(sadr(il+4))
         top=top-1

         il=iadr(lstk(top))
         ilr=il
         if(istk(il).lt.0) il=iadr(istk(il+1))
         if(istk(il).ne.1.and.istk(il).ne.2.and.istk(il).ne.5) then
            top=top+1
            call ref2val
            call funnam(ids(1,pt+1),'isreal',iadr(lstk(top)))
            fun=-1
            return
         endif
         m=istk(il+1)
         n=istk(il+2)
         it=istk(il+3)
         if(it.eq.0) then
            istk(ilr)=4
            istk(ilr+1)=1
            istk(ilr+2)=1
            istk(ilr+3)=abs(1-it)
            lstk(top+1)=sadr(ilr+4)
         else
            if(istk(il).eq.1) then
               mn=istk(il+1)*istk(il+2)
               l=sadr(il+4)+mn
            elseif(istk(il).eq.2) then
               mn=istk(il+8+m*n)-1
               l=sadr(il+9+istk(il+1)*istk(il+2))
            elseif(istk(il).eq.5) then
               mn=istk(il+4)
               l=sadr(ilr+5+m+mn)+mn
            endif

            mx=0.0d0
            if(mn.gt.0) then
               do 10 i=0,mn-1
                  mx=max(mx,abs(stk(l+i)))
 10            continue
            endif
            it=1
            if(mx.le.eps) it=0
            istk(ilr)=4
            istk(ilr+1)=1
            istk(ilr+2)=1
            istk(ilr+3)=abs(1-it)
            lstk(top+1)=sadr(ilr+4)
         endif
      endif
      return
      end
