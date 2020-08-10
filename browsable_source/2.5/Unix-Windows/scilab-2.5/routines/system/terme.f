      subroutine terme
c
c     Copyright INRIA
      include '../stack.h'
      integer r,op,bslash,star,slash,dot
c      integer plus,minus,ou,et
c      integer equal,less,great,not

      data bslash/49/,star/47/,slash/48/,dot/51/

c      data plus/45/,minus/46/,ou/57/,et/58/
c      data equal/50/,less/59/,great/60/,not/61/
c
      r = rstk(pt)
      if (ddt .eq. 4) then
         write(buf(1:8),'(2i4)') pt,r
         call basout(io,wte,' term   pt:'//buf(1:4)//' rstk(pt):'
     &               //buf(5:8))
      endif
c
      ir=r/100
      if(ir.ne.2) goto 01
      goto(05,25,26),r-200
      goto 99
c
c
c     premier facteur
c-------------------
   01 pt = pt+1
      rstk(pt) = 201
      icall=3
c     *call* factor
      return
   05 pt = pt-1
   10 op = 0
      if (sym .eq. dot) then
         op = dot
         call getsym
      endif
      if (sym.eq.star .or. sym.eq.slash .or. sym.eq.bslash ) go to 20
      if (op.ne.0) then
         call error(7)
         return
      endif
      return
c
c     facteurs suivants
c----------------------
   20 op = op + sym
      call getsym
      if (sym .eq. dot) op = op + 2*sym
      if (sym .eq. dot) call getsym
      pt = pt+1
      pstk(pt) = op
      rstk(pt) = 202
      icall=3
c     *call* factor
      return
   25 fin=pstk(pt)
c     evaluation
c---------------
      rstk(pt)=203
      rhs=2
      icall=4
c     *call* allops(op)
      return
   26 pt=pt-1
      go to 10
c
   99 call error(22)
      if (err .gt. 0) return
      return
      end
