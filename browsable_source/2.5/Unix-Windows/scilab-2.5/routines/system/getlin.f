      subroutine getlin(job)
c ====================================================================
c     get a new line
c ====================================================================
c
c     Copyright INRIA
      include '../stack.h'
c
      integer lrecl,eol,slash,dot,blank,comma
      integer retu(6)
      integer r,quit(4)
      logical maj,isinstring
      external isinstring

      data eol/99/,dot/51/,blank/40/,comma/52/
      data retu/27,14,29,30,27,23/
      data slash/48/,lrecl/512/
      data quit/26,30,18,29/
c
      if(ddt.eq.4) then
         write(buf(1:10),'(2i5)') rio,job
         call basout(io,wte,' getlin rio:'//buf(1:5)//' job: '
     &              //buf(6:10))
      endif
c
      n=1
 10   l1=lpt(1)
      lct(8)=lct(8)+1
c     next line to preserve end-of-line marks (eol)
      if(job.eq.1) l1=lpt(6)+1
      if(job.eq.-1) then
         if (lpt(6).lt.0) then
            l=-lpt(6)
         else
            l=l1
         endif
      else
         l=l1
      endif
      r=0
      if(pt.gt.0) r=rstk(pt)
      l0=0
      if(job.lt.0) goto 12
      if(r.eq.503) goto 11
      if(macr.gt.0.and.fin.ne.2) then
         k=lpt(1)-(13+nsiz)
         il=lin(k+7)
c        check if getlin is call in a macro or an exec 
         if(il.gt.0) goto 80
      endif
 11   call basin(ierr,rio,buf(1:lrecl),'*')
      if(ierr.ne.0) goto 50
 12   l0=l
      n = lrecl+1
 15   n = n-1
      if(n.le.0) goto 45
      if (buf(n:n) .eq. ' ') go to 15
      if (mod(lct(4),2) .eq. 1.and.rio.ne.rte) then
         call promptecho(wte,buf(1:n),n)
      endif
      if (rio.eq.rte) then
         if(wio.ne.0) then
            call promptecho(wio,buf(1:n),n)
         endif
         if (hio.gt.0) call basout(io,hio,buf(1:n))
         lct(1)=1
      endif
c
c     loop on read characters
      j=0
 17   j=j+1
      if(j.gt.n) goto 45
c      do 40 j = 1, n
         do 21 k = 1, csiz
         if (buf(j:j).eq.alfa(k)) then
            maj=.false.
            goto 25
         elseif(buf(j:j).eq.alfb(k)) then
            maj=.true.
            goto 25
         endif
 21   continue
         k = eol+1
         call xchar(buf(j:j),k)
         if (k .eq. eol) go to 45
         if (k .eq. 0) then
            call basout(io,wte,
     +           buf(j:j)//' is not a scilab character')
            go to 40
         endif
         maj=.false.
 25      k=k-1
c
c     special cases        //    ..
        if(buf(j+1:j+1).ne.buf(j:j)) goto 31

        if(k.eq.slash) then
c     .    check if // occurs in a string
           if(isinstring(lin(l0),l-l0+1)) then
c     .       // is part of a string
              if (l+1.ge.lsiz) then
                 call error(108)
                 return
              endif
              lin(l)=slash
              lin(l+1)=slash
              j=j+1
              l=l+2
              goto 40
           else
c     .       // marks beginning of a comment
              goto 45
           endif
        endif
c
        if(k.ne.dot) goto 31
        if(j.eq.1) goto 70
c     . .. find
c     check if .. is followed by more dots or //
        jj=j
 28     continue
        if(jj.eq.n)goto 29
        jj=jj+1
        if(buf(jj:jj).eq.buf(j:j)) goto 28
        if(buf(jj:jj).eq.' ') goto 28
        if(buf(jj:jj).ne.'/') goto 31
        if(jj.eq.n) goto 31
        if(buf(jj+1:jj+1).eq.'/') goto 29
        goto 31
c
 29     continue
c     next line is a continuation line
        if(job.ne.-1) goto 11
c     handle continuation lines when scilab is call as a procedure
        fin=-1
        lpt(6)=-l
        return
c     There is no continuation line or syntax error
 31     continue

         lin(l) = k
         if(maj) lin(l)=-k
         if (l.lt.lsiz) l = l+1
         if (l.ge.lsiz) then
            call error(108)
            return
         endif
   40 goto 17
c
 45   continue
      if(l.eq.l0) then
         lin(l)=blank
         l=l+1
      endif
      lin(l) = eol
      lin(l+1)=blank
      lpt(6) = l
      lpt(4) = l1
      lpt(3) = l1
      lpt(2) = l1
cc_ex      lct(1) = 0
      fin=0
      call getch
      return
c
   50 if (rio .eq. rte) go to 52
      call icopy(6,retu,1,lin(l),1)
      if(job.eq.1) then
         call error(47)
         return
      endif
c     rio=rte
      l = l + 6
      go to 45
   52 continue
      call icopy(4,quit,1,lin(l),1)
      l = l + 4
      go to 45
c
c
   70 continue
      if (n.gt.2) then
         call xscion(iflag)
         if(iflag.eq.1) then
            call cvstr(n-2+10,lin(l),'unix_x('''//buf(3:n)//''');',job)
         else
            call cvstr(n-2+10,lin(l),'unix_w('''//buf(3:n)//''');',job)
         endif
         l=l+n-2+10
         call basout(io,wte,' ')
      endif
      goto 45
c
   80 k=lpt(1)-(13+nsiz)
      ilk=lin(k+6)
      if(istk(ilk).eq.10) then
         mn=istk(ilk+1)*istk(ilk+2)
         lf=ilk+4+mn+istk(ilk+4+mn)
      else
         mlhs=istk(ilk+1)
         mrhs=istk(ilk+1+nsiz*mlhs+1)
         ll=ilk+4+nsiz*(mlhs+mrhs)
         lf= ll+istk(ll-1)+1
      endif
      il=lin(k+7)
      if(il.gt.lf)  goto 45

   81 if(istk(il).eq.eol) goto 82
      lin(l)=istk(il)
      l=l+1
      if(l.gt.lsiz) then
         call error(26)
         return
      endif
      il=il+1
      goto 81
   82 if(istk(il+1).ne.eol) goto 83

      lin(l)=eol
      l=l+1
      il=il+1
   83 lin(k+7)=il+1
c%%
      if((ddt .lt. 1 .or. ddt.gt.4).and.mod(lct(4),2) .ne. 1) goto 45
      l2=l1
   84 n=l-l2
      n1=n
      if(n.le.lct(5)) then
         call cvstr(n,lin(l2),buf,1)
      else
         n=lct(5)
         n1=n-3
         call cvstr(n1,lin(l2),buf,1)
         buf(n1+1:n1+3)='...'
         n1=n1-1
      endif
      call basout(io,wte,buf(1:n))
      l2=l2+n1+1
      if(l2.lt.l) goto 84
      goto 45
      end

      logical function isinstring(lin,l)
c     this function returns true if character l in lin belongs to a
c     string syntax
      integer lin(*)
c     lin is a vector of scilab codes
c
      integer dot,blank,quote,right,rparen
      integer qcount,pchar

      data dot/51/,blank/40/,quote/53/,right/55/,rparen/42/
c
      il=0
      qcount=0
      pchar=blank
 27   il=il+1
      if(il.ge.l) then
         if(qcount.eq.0) then
c     .  Not in string
            isinstring=.false.
            return
         else
            qcount=0
c     .     is part of a string
            isinstring=.true.
            return
         endif
      elseif(abs(lin(il)).eq.quote) then
         if(qcount.eq.0) then
            if(pchar.lt.blank.or.pchar.eq.right.or.
     $           pchar.eq.rparen.or.pchar.eq.dot) then
c     .          quote marks a tranposition
            else
               qcount=qcount+1
            endif
         else
c     .     a quote in a string
            if(lin(il+1).eq.quote) then
               il=il+1
            else
c     .        end of string
               qcount=0
            endif
         endif
      endif
      pchar=lin(il)
      if(pchar.eq.-blank) pchar=blank
      goto 27
      end

      subroutine promptecho(lunit,string,strl)
      include '../stack.h'
      character*(*) string
      character*(bsiz) temp
      character*10 prpt
      integer l,strl
      prpt=' '
      if(paus.eq.0) then
         prpt='-->'
      elseif(paus.lt.10) then
         write(prpt,'(''-'',i1,''->'')') paus
      elseif(paus.lt.100) then
         write(prpt,'(''-'',i2,''->'')') paus
      elseif(paus.lt.1000) then
         write(prpt,'(''-'',i3,''->'')') paus
      else
         prpt='-*->'
      endif
      l=lnblnk(prpt)
      temp = prpt(1:l)//string(1:strl)
      call basout(io,lunit,temp(1:l+strl))
      return 
      end

