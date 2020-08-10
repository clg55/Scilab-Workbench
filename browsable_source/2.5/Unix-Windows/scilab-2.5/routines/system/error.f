      subroutine error(n)
c     -------------------------
c     error display and handling
c     n : the error number
c!
c     Copyright INRIA
      integer n
      include '../stack.h'

      integer num,imess,imode,errtyp,lct1
      logical trace
c
      call errmds(num,imess,imode)
      trace=.not.((num.lt.0.or.num.eq.n).and.imess.ne.0)
c
c     de-activate output control
      lct1=lct(1)
      lct(1)=0
c
      errtyp=0
      if(err1.eq.0.and.err2.eq.0) then
c     . locate the error in the current statement
        if(trace) call errloc(n)
c     . output error message
        if(.not.trace) lct(1)=-1
        call errmsg(n,errtyp)
        lct(1)=0
      endif
c
c     handle the error
      call errmgr(n,errtyp)
c
c     re-activate output control
      lct(1)=lct1
c
      return
      end

      subroutine errmgr(n,errtyp)
c     -------------------------
c     this routines handle errors: recursion stack cleaning, error
c     recovery, display of calling tree
c     n      : the error number
c     errtyp : error type (recoverable:0 or not:1)
c!
      include '../stack.h'
      integer errtyp,n
c
      integer sadr
c
      integer num,imess,imode,lunit
      integer l1,ilk,m,lk,km,k,ll,r,p,mode(2),lpts(6),pt0
      logical first,trace,pflag,erecmode
c
c      sadr(l)=(l/2)+1
c
      ll=lct(5)
      first=.true.
      lunit=wte
c
      call errmds(num,imess,imode)
      trace=.not.((num.lt.0.or.num.eq.n).and.imess.ne.0)
c
      erecmode=(num.eq.n.or.num.lt.0).and.imode.ne.0.and.imode.ne.3
c     
      pt0=0
      if(erecmode) then

c     error recovery mode
         p=pt+1
c        . looking if error has occured in execstr deff getf or comp
 20      p=p-1
         if(p.le.errpt) then
            pt0=pt
            goto 50
         endif
         if(rstk(p).eq.502) then 
            if(rstk(p-1).eq.903) then
c     .     error has occured in execstr
               errtyp=0
               pt0=p
            elseif(rstk(p-1).eq.904.or.rstk(p-1).eq.901) then
c     .     error has occured in comp
               errtyp=0
               pt0=p
            else
               goto 20
            endif
         else
            goto 20
         endif
      endif


 30   continue
c
c depilement de l'environnement
      lct(4)=2
      pt=pt+1
 35   pt=pt-1
      if(pt.eq.pt0) goto 50
      r=rstk(pt)
      goto(36,36,37) r-500
      if(r.eq.904) then
         if (ids(2,pt).ne.0) then
c     .     fermeture du fichier dans le cas getf(  'c')
            mode(1)=0
            call clunit(-ids(2,pt),buf,mode)
         endif
      endif
      goto 35
c     
c     on depile une fonction
 36   call depfun(lunit,trace,first)
      goto 35
c     
c     on depile un exec ou une pause
 37   call depexec(lunit,trace,first,pflag)
      if(.not.pflag) goto 35
c     
 50   continue
      if(erecmode) then
         if(errtyp.eq.0) then
c     .     recoverable error
            top=toperr
            if(err2.eq.0) then
               err1=n
            else
               err1=err2
            endif
            err=0
         else
            comp(1)=0
            comp(3)=0
            err=n
         endif
      else
         comp(1)=0
         comp(3)=0
         err=n
      endif
      if(trace) call basout(io,lunit,' ')
c     
      return
      end

      subroutine errmsg(n,errtyp)
c     -------------------------
c     this routine displays the error message and set if the error is
c     recoverable by errcatch or not:
c     errtyp=0  : recoverable error
c     errtyp=1  : unrecoverable error
c
c     n : error number, if n execeeds the maximum error number this
c         routines displays the error message contained in buf
c!
      include '../stack.h'
      integer n,errtyp
      integer lunit,sadr,nl,io
      character line*340
c
c      sadr(l)=(l/2)+1
c
      ll=lct(5)
      lunit=wte
      errtyp=0
c

      goto (
     +   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
     +  16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
     +  31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
     +  46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
     +  61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
     +  76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
     +  91, 92, 93, 94, 95, 96, 97, 98, 99,100,101,102,103,104,105,
     + 106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,
     + 121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,
     + 136,137,138,139,140,141,142,143
     + ),n

      goto (
     +     200,201,202,203,204,205,206,207,208,209,
     +     210,211,212,213,214,215,216,217,218,219,
     +     220,221,222,223,224,225,226,227,228,229,
     +     230,231,232,233,234,235,236,237,238,239,
     +     240,241,242,243,244,245,246,247,248,249,
     +     250,251,252,253,254,255,256,257,258,259,
     +     260,261,262,263,264,265,266,267,268,269,
     +     270),n-199
      if(n.ge.10000) return
      goto 998
c
    1 call basout(io,lunit,'incorrect assignment')
      go to 999
    2 call basout(io,lunit,'invalid factor')
      errtyp=1
      go to 999
    3 call basout(io,lunit,'waiting for right parenthesis')
      errtyp=1
      go to 999
    4 call cvname(ids(1,pt+1),buf,1)
      call basout(io,lunit,'undefined variable : '//buf(1:nlgh))
      go to 999
    5 call basout(io,lunit,'inconsistent column/row dimensions')
      go to 999
    6 call basout(io,lunit,'inconsistent row/column dimensions')
      go to 999
    7 continue
      call basout(io,lunit,
     $     'dot cannot be used as modifier for this operator')
      go to 999
    8 call basout(io,lunit,'inconsistent addition')
      go to 999
    9 call basout(io,lunit,'inconsistent subtraction')
      go to 999
   10 call basout(io,lunit,'inconsistent multiplication')
       go to 999
   11 call basout(io,lunit,'inconsistent right division ')
      go to 999
   12 call basout(io,lunit,'inconsistent left division')
      go to 999
   13 call basout(io,lunit,'redefining permanent variable')
      go to 999
   14 call basout(io,lunit,
     &        'eye variable undefined in this context')
      go to 999
   15 call basout(io,lunit,'submatrix incorrectly defined')
      go to 999
   16 call basout(io,lunit,'incorrect command!')
      errtyp=1
      go to 999
   17 lb = lstk(isiz) - lstk(bot) + 1
      lt = err + lstk(bot)-lstk(1)
      call basout(io,lunit,'stack size exceeded!'//
     &     ' (Use stacksize function to increase it)')
      write(buf(1:40),'(4i10)') lb,lt,lstk(isiz)-lstk(1)+1
      call basout(io,lunit,'Memory used for variables :'//buf(1:10))
      call basout(io,lunit,'Intermediate memory needed:'//buf(11:20))
      call basout(io,lunit,'Total  memory available   :'//buf(21:30))
      go to 999
   18 call basout(io,lunit,'too many names!')
      go to 999
   19 call basout(io,lunit,
     &           'singular matrix')
      go to 999
   20 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be square matrix')
      else
         call basout(io,lunit,
     +        'first argument must be square matrix')
      endif
      go to 999
   21 call basout(io,lunit,'invalid index')
      go to 999
   22 call basout(io,lunit,' recursion problems. Sorry....')
      go to 999
   23 call basout(io,lunit,
     &     ' Matrix norms available are 1, 2, inf, and fro')
      go to 999
   24 call basout(io,lunit,'convergence problem...')
      go to 999
   25 call cvname(ids(1,pt+1),line(1:nlgh),1)
      nl=lnblnk(line(1:nlgh))
      call  basout(io,lunit,
     &     'bad call to primitive :'//line(1:nl))
      go to 999
   26 call basout(io,lunit,
     &     'too complex recursion! (recursion tables are full))')
      errtyp=1
      pt=min(pt,psiz)
      go to 999
   27 call basout(io,lunit,'division by zero...')
      go to 999
   28 call basout(io,lunit,'empty function...')
      go to 999
   29 call basout(io,lunit,'matrix is not positive definite')
      go to 999
   30 call basout(io,lunit,'invalid exponent')
      go to 999
   31 call basout(io,lunit,'incorrect string')
      errtyp=1
      go to 999
   32 call basout(io,lunit,'singularity of log or tan function')
      go to 999
   33 call basout(io,lunit,'too many '':''')
      go to 999
   34 call basout(io,lunit,'incorrect clause ')
      errtyp=1
      go to 999
   35 continue
      call cvname(ids(1,pt),buf,1)
      call basout(io,lunit,'error in '//buf(1:nlgh))
      errtyp=1
      go to 999
   36 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument is incorrect here')
      else
         call basout(io,lunit,
     +   'first argument is incorrect')
      endif
      go to 999
   37 write(buf(1:6),'(i6)') err
      call basout(io,lunit,'incorrect function at line '//buf(1:6))
      go to 999
   38 call basout(io,lunit,'file name incorrect')
      go to 999
   39 call basout(io,lunit,'incorrect number of arguments')
      go to 999
   40 call basout(io,lunit,'waiting for end of command')
      errtyp=1
      go to 999
   41 call basout(io,lunit,'incompatible LHS')
      goto 999
   42 call basout(io,lunit,'incompatible RHS' )
      goto 999
   43 call basout(io,lunit,'not implemented in scilab....')
      goto 999
c
   44 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument is incorrect')
      else
         call basout(io,lunit,
     +        'first argument is incorrect')
      endif
      goto 999
   45 write(buf(1:3),'(i3)') err
      call basout(io,lunit,'null matrix (argument # '//buf(1:3)//')')
      goto 999
   46 call basout(io,lunit,'incorrect syntax')
      errtyp=1
      goto 999
   47 call basout(io,lunit,' end or else is missing...')
      errtyp=1
      goto 999
   48 continue
      goto 999
   49 call basout(io,lunit,'incorrect file or format')
      goto 999
   50 call basout(io,lunit,'subroutine not found : '//buf(1:32))
      goto 999
   51 continue
      goto 999
   52 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a real matrix')
      else
         call basout(io,lunit,
     +        'argument must be a real matrix')
      endif
      goto 999
   53 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +   'th input is invalid (waiting for real or complex matrix) ')
      else
         call basout(io,lunit,
     +    'invalid input (waiting for real or complex matrix) ')
      endif
      goto 999
   54 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument type must be polynomial')
      else
         call basout(io,lunit,
     +        'argument type must be polynomial')
      endif
      goto 999
   55 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument type must be character string')
      else
         call basout(io,lunit,
     +        'argument type must be  character string')
      endif
      goto 999
   56 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a list')
      else
         call basout(io,lunit,
     +        'argument must be a list')
      endif
      goto 999
   57 call basout(io,lunit,
     +     'problem with comparison symbol...')
      goto 999
   58 continue
      if(rhs.eq.0) then
             call basout(io,lunit,
     &       'function has no input argument...')
                   else
              call basout(io,lunit,
     &       'incorrect number of arguments in function call...')
              call basout(io,lunit,'arguments are :')
              call prntid(istk(pstk(pt)),rhs,wte)
      endif
      goto 999
   59 continue
      if(lhs.eq.0) then
         call basout(io,lunit,
     &        'function has no output')
      else
         call basout(io,lunit,
     &        'incorrect # of outputs in the function')
         call basout(io,lunit,'arguments are :')
         call prntid(istk(pstk(pt)),lhs,wte)
      endif
      goto 999
   60 call basout(io,lunit,'argument with incompatible dimensions')
      goto 999
   61 call basout(io,lunit,'direct acces : give format')
      goto 999
   62 write(buf(1:8),'(i8)') err
      call basout(io,lunit,'end of file at line '//buf(1:8))
      goto 999
   63 write(buf(1:8),'(i8)') err
      call basout(io,lunit,buf(1:8)//'graphic terminal?')
      goto 999
   64 continue
      call basout(io,lunit,'integration fails')
      goto 999
   65 write(buf(1:8),'(i8)') err
      call basout(io,lunit,buf(1:8)//': logical unit already used')
      goto 999
   66 call basout(io,lunit,'no more logical units available!')
      goto 999
   67 call basout(io,lunit,'unknown file format ')
      goto 999
   68 call inffic( 5, buf, nc)
      nc = max ( 1 , nc )
      call basout(io,lunit,
     +  'fatal error!!! your variables are saved in file :'
     +  //buf(1:nc))
      call basout(io,lunit,' bad call to a scilab function ? check')
      call basout(io,lunit,' ... otherwise send a bug report to : '//
     +     'the Scilab group')
      goto 999
   69 call basout(io,lunit,'floating point exception')
      goto 999
   70 call basout(io,lunit,'too many arguments in fort (max 30)')
      goto 999
   71 call basout(io,lunit,'this variable is not valid in fort')
      goto 999
   72 call cvname(ids(1,pt),buf,1)
      call basout(io,lunit,
     +     buf(1:nlgh)//'is not valid in this context')
      goto 999
   73 call basout(io,lunit,'error while linking')
      goto 999
   74 call basout(io,lunit,'Leading coefficient is zero')
      goto 999
   75 call basout(io,lunit,'Too high degree (max 100)')
      goto 999
   76 continue
      write(buf(1:3),'(i3)') err
      call basout(io,lunit,'for x=val with type(val)='//buf(1:3)//
     $     ' is not implemented in Scilab')
      goto 999
   77 continue
      call cvname(ids(1,pt+1),buf,1)
      nl=lnblnk(buf(1:nlgh))
      call basout(io,lunit,
     +     buf(1:nl)//' : wrong number of rhs arguments')
      go to 999
   78 continue
      call cvname(ids(1,pt+1),buf,1)
      nl=lnblnk(buf(1:nlgh))
      call basout(io,lunit,
     +     buf(1:nl)//' : wrong number of lhs arguments')
      go to 999
   79 continue
      go to 999
   80 write(buf(1:3),'(i3)') err
      call  basout(io,lunit,
     +    ' incorrect function (argument n:'//buf(1:3)//')')
      go to 999
   81 continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +        ' : wrong type argument, expecting a '//
     +        ' real or complex matrix')

      go to 999
   82 continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +        ' : wrong type argument, expecting a real matrix')
      goto 999
   83 continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +        ' : wrong type argument, expecting a real vector')
      goto 999
   84 continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +        ' : wrong type argument, expecting a scalar')

      goto 999
   85 call basout(io,lunit,'host does not answer...')
      goto 999
   86 call basout(io,lunit,'uncontrollable system')
      goto 999
   87 call basout(io,lunit,'unobservable system')
      goto 999
   88 call basout(io,lunit,
     +     'sfact : singular  or assymetric problem')
      goto 999
   89 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument has incorrect dimensions')
      else
         call basout(io,lunit,
     +        'argument has incorrect dimensions')
      endif
      goto 999
 90   if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a transfer matrix')
      else
         call basout(io,lunit,
     +   'argument must be a transfer matrix')
      endif
      go to 999
   91 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be in state space form')
      else
         call basout(io,lunit,
     +   'argument must be in state space form')
      endif
      goto 999
   92 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     + 'th argument must be a rational matrix')
      else
         call basout(io,lunit,
     +   'argument must be a rational matrix')
      endif
      goto 999
   93 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be in continuous time')
      else
         call basout(io,lunit,
     +   'waiting for continuous time...')
      endif
      goto 999
   94 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be in discrete time')
      else
         call basout(io,lunit,
     +   'argument must be in discrete time')
      endif
      goto 999
   95 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//'th argument must '//
     &        'be SISO')
      else
         call basout(io,lunit,'argument must be '//
     &        'SISO')
      endif
      goto 999
   96 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,'time domain of  '//buf(1:3)//
     +        ' th argument is not defined')
      else
         call basout(io,lunit,'time domain of '//
     +        'argument is not defined')
      endif
      goto 999
   97 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a system ' //
     +        'in state space or transfer matrix form')
      else
         call basout(io,lunit,'input argument must be '//
     &        'a system in state space or transfer matrix form')
      endif
      goto 999
   98 call basout(io,lunit,' variable returned by scilab argument '//
     &     'function is incorrect')
      goto 999
   99 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,' elements of '//buf(1:3)//
     &        'th must be in increasing order!')
      else
         call basout(io,lunit,'elements of first'//
     &        ' argument are not (strictly) increasing')
      endif
      goto 999
 100  if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,'the elements of  '//buf(1:3)//
     &        'th argument are not in (strictly) decreasing order')
      else
         call basout(io,lunit,'elements of first '//
     &        'argument are not in (strictly) decreasing order')
      endif
      goto 999
 101  if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,'last element of '//buf(1:3)//
     &        'th argument <>  first')
      else
         call basout(io,lunit,'last element of first'//
     &        ' argument does not matches the first one')
      endif
      goto 999
 102  call cvname(ids(1,pt+1),line(1:nlgh),1)
      nl=lnblnk(line(1:nlgh))
      nb=lnblnk(buf)
      call basout(io,lunit,'variable or function '//line(1:nl)//
     +     ' is not in file '//buf(1:nb))
      goto 999
 103  call basout(io,lunit,' variable '//buf(1:nlgh) //
     +     ' is not a valid rational function ')
      goto 999
 104  call basout(io,lunit,' variable '//buf(1:nlgh) //
     +     ' is not a valid state space representation')
      goto 999
 105  call basout(io,lunit,'undefined fonction')
      goto 999
 106  call basout(io,lunit,' fonction name already used')
      goto 999
 107  write(buf(1:3),'(i3)') err
      call basout(io,lunit,'too many functions are defined (maximum #:'
     $     //buf(1:3)//')')
      goto 999
 108  continue
      call basout(io,lunit,'too complex for scilab, may be a too long'
     $     //'control instruction')
      goto 999
 109  continue
      call basout(io,lunit,'too large, can''t be displayed')
      goto 999
 110  call cvname(ids(1,pt+1),line(1:nlgh),1)
      nl=lnblnk(line(1:nlgh))
      call basout(io,lunit,line(1:nl)//' was a function when'//
     +     ' compiled but is now a primitive!')
      goto 999
 111  call cvname(ids(1,pt+1),line(1:nlgh),1)
      nl=lnblnk(line(1:nlgh))
      call basout(io,lunit,'trying to re-define  function '
     +     //line(1:nl))
      goto 999
 112  call basout(io,lunit,
     $     'Cannot allocate more memory')
      goto 999
 113  continue
      call basout(io,lunit,'too large string')
      goto 999
 114  continue
      call basout(io,lunit,'too many linked routines')
      goto 999
 115  continue
      call basout(io,lunit,'Stack problem detected within a loop')
      call basout(io,lunit,
     $     ' a primitive function has been called with wrong number')
      call basout(io,lunit,
     $     ' of lhs arguments. No lhs test made for this function; ')
      call basout(io,lunit,
     $     ' please report this bug')
      call showstack()
      goto 999
 116  continue
      if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument has incorrect value')
      else
         call basout(io,lunit,
     +        'first argument has incorrect value')
      endif
      goto 999
 117  continue
      write(buf(1:6),'(i6)') err
      call basout(io,lunit,'List element' //buf(1:6)//' is Undefined')
      goto 999
 118  continue
      if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a named variable not an expression')
      else
         call basout(io,lunit,
     +        'argument must be a named variable not an expression ')
      endif
      goto 999
 119  continue
      goto 999
 120  call basout(io,lunit,'indices for non-zero elements '//
     $     'must be given by a 2 column matrix')
      goto 999
 121  call basout(io,wte,
     $     'incompatible indices for non-zero elements ')
      goto 999
 122  write(buf(1:3),'(i3)') err
      call basout(io,lunit,' logical unit number should be '//
     $     '  larger than '//buf(1:3))
      goto 999
 123  call basout(io,lunit,' fonction not bounded from below')
      goto 999
 124  continue
      goto 999
 125  call basout(io,lunit,' problem may be unbounded :'//
     $     'too high distance between two consecutive iterations')
      goto 999
 126  continue
      call basout(io,wte,'Inconsistent constraints')
      goto 999
 127  continue
      call basout(io,wte,'no feasible solution')
      goto 999
 128  continue
      call basout(io,wte,'degenerate starting point')
      goto 999
 129  continue
      call basout(io,wte,'no feasible point has been found')
      goto 999
 130  continue
      call basout(io,wte,
     &     '  optimization fails: back to initial point')
      goto 999
 131  continue
      call basout(io,wte,
     &     ' optim: stop requested by simulator (ind=0)')
      goto 999
 132  continue
      call basout(io,wte,
     &     ' optim: incorrect input parameters')
      goto 999
 133  continue
      call basout(io,wte,' too small memory')
      goto 999
 134  continue
      call basout(io,wte,
     &     'optim: problem with initial constants in simul ')
      goto 999
 135  call basout(io,lunit,
     +     'optim : bounds and initial guess are incompatible')
      goto 999
 136  call basout(io,lunit,'optim : this method is NOT implemented ')
      goto 999
 137  call basout(io,lunit,
     +     'NO hot restart available in this method')
      goto 999
 138  call basout(io,lunit,'optim : incorrect stopping parameters')
      go to 999
 139  call basout(io,lunit,'optim : incorrect bounds')
      go to 999
 140  continue
      go to 999
 141  write(buf(1:3),'(i3)') err
      call  basout(io,lunit,
     +    ' incorrect function (argument n:'//buf(1:3)//')')
      go to 999
 142  write(buf(1:3),'(i3)') err
      call basout(io,lunit,'hot restart : dimension of '//
     &     'working table (argument n:'//buf(1:3)//')')
      go to 999
 143  call basout(io,lunit,
     +   'optim : df0 must be positive !')
      goto 999
 200  continue
      goto 999
 201  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +        ' : wrong type argument,')
      call basout(io,lunit,' expecting a real or complex matrix')
      go to 999
 202  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +        ' : wrong type argument,')
      call basout(io,lunit,' expecting a real matrix')
      goto 999
 203  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +        ' : wrong type argument,')
      call basout(io,lunit,' expecting a real vector')
      goto 999
 204  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +        ' : wrong type argument,')
      call basout(io,lunit,' expecting a scalar')
      goto 999
 205  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      i1=4+nlgh
      write(buf(i1:i1+6),'(i3,'','',i3)') pstk(pt+1),pstk(pt+2)

      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +     ' : wrong matrix size ('//buf(i1:i1+6)//') expected ')
      goto 999
 206  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      i1=4+nlgh
      write(buf(i1:i1+3),'(i3)') pstk(pt+1)

      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +     ' : wrong vector size ('//buf(i1:i1+2)//') expected ')
      goto 999
 207  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +     ' : wrong type argument, expecting a matrix of strings')
      goto 999
 208  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +     ' : wrong type argument, expecting a booleen matrix')

      goto 999
 209  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +     ' : wrong type argument, expecting a matrix')
      goto 999
 210  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +     ' : wrong type argument, expecting a list')
      goto 999
 211  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +     ' : wrong type argument, expecting a function'
     +       //' or string (external function)')
      goto 999
 212  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +     ' : wrong type argument, expecting a polynomial matrix')
      goto 999
 213  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +     ' : wrong type argument, expecting a working'//
     +     ' integer matrix')
      goto 999
 214  continue
      write(buf(1:3),'(i3)') err
      call cvname(ids(1,pt+1),buf(4:4+nlgh),1)
      nl=lnblnk(buf(4:3+nlgh))
      call basout(io,lunit,
     +     'Argument '//buf(1:3)//' of '//buf(4:3+nl)//
     +        ' : wrong type argument,')
      call basout(io,lunit,' expecting a  vector')
      goto 999
 215  continue
      if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument type must be boolean')
      else
         call basout(io,lunit,
     +        'argument type must be boolean')
      endif
      goto 999
 216  continue 
      if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument type must be boolean or scalar')
      else
         call basout(io,lunit,
     +        'argument type must be boolean or scalar')
      endif
      goto 999
 217  continue
      if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument  must be a sparse matrix of scalars')
      else
         call basout(io,lunit,
     +        'argument type must be a sparse matrix of scalars')
      endif
      goto 999
 218  continue
      if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument  must be a  handle to sparse lu factors')
      else
         call basout(io,lunit,
     +        'argument type must be a  handle to sparse lu factors')
      endif
      goto 999
 219  continue
      if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument  must be a sparse or full scalar matrix')
      else
         call basout(io,lunit,
     +        'argument type must be a sparse or full scalar matrix')
      endif
      goto 999
 220  continue
      call basout(io,lunit,'null variable cannot be used here')
      goto 999
 221  continue
      call basout(io,lunit,'A sparse matrix entry is defined with' //
     &     ' two differents values')
      goto 999
 222  continue
      call basout(io,lunit,'lusolve not yet implemented for full RHS')
      goto 999
 223  continue
      call cvname(ids(1,pt+1),buf(1:nlgh),1)
      ln=lnblnk(buf(1:nlgh))
      call basout(io,lunit,'It is not possible to redefine the '//
     &     buf(1:ln)//' primitive this way (see clearfun).')
      goto 999
 224  continue
      call basout(io,lunit,'Type data base is full')
      goto 999
 225  continue
      call basout(io,lunit,'This data type is already defined')
      goto 999
 226  continue
      call basout(io,lunit,'Inequality comparison with empty matrix')
      goto 999
 227  continue
      call basout(io,lunit,'Missing index')
      goto 999
 228  continue
      call cvname(ids(1,pt+1),buf(1:nlgh),1)
      call basout(io,wte,'reference to the cleared global variable '//
     $     buf(1:nlgh))
      goto 999
 229  continue
      goto 999
C     errors from semidef
 230  continue
         call basout(io,lunit,'semidef fails')
      goto 999
 231  continue
      call basout(io,wte,'First argument must be a single string')
      goto 999
 232  continue
      call basout(io,wte,'Entry name not found')
      goto 999
 233  continue
      call basout(io,wte,'Maximum number of dynamic interfaces '//
     &     'reached')
      goto 999
 234  continue
      call basout(io,wte,'link: expecting more than one argument')
      goto 999
 235  continue
      call basout(io,wte,'link: problem with one of the entry point')
      goto 999
 236  continue
      call basout(io,wte,'link: the shared archive was not loaded') 
      goto 999
 237  continue
      call basout(io,wte,'link: Only one entry point allowed '//
     &     'On this operating system')
      goto 999
 238  continue
      call basout(io,wte,'link: First argument  cannot be a number') 
      goto 999
 239  continue
      call basout(io,wte,'You cannot link more functions, '//
     &     'maxentry reached')
      goto 999
 240  continue
      l1=lnblnk(buf)
      call basout(io,lunit,
     &     'File '//buf(1:l1)//' already exists or '//
     &     'directory write access denied ')
      goto 999
 241  continue
      l1=lnblnk(buf)
      call basout(io,lunit,
     &     'File '//buf(1:l1)//' does not exist or '//
     &     'read access denied ')
      goto 999
 242  continue
      call basout(io,lunit,'binary direct acces files '//
     &     'must be opened by ''file''')
      goto 999
 243  continue
      call basout(io,lunit,'C file logical unit not allowed here')
      goto 999
 244  continue
      call basout(io,lunit,'Fortran file logical unit not allowed here')
      goto 999
 245  continue
      write(buf(1:3),'(i3)') err
      call basout(io,lunit,'No input file associated to logical unit '//
     &     buf(1:3))
      goto 999
 246  continue
      goto 999
 247  continue
      goto 999
 248  continue
      if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument is not a valid variable name')
      else
         call basout(io,lunit,
     +        'argument is not a valid variable name')
      endif
      goto 999
 249  continue
      if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must not be an empty string')
      else
         call basout(io,lunit,
     +        'argument must not be an empty string')
      endif
      goto 999

 250  continue
      call basout(io,lunit
     $     ,'Recursive extraction is not valid in this context')
      goto 999


 251  continue
      call basout(io,lunit,'bvode: ipar dimensioned at least 11')
      goto 999
 252  continue
      call basout(io,lunit,'bvode: ltol must be of size ipar(4)')
      goto 999
 253  continue
      call basout(io,lunit,'bvode: fixpnt must be of size ipar(11)')
      goto 999
 254  continue
      call basout(io,lunit,'bvode: ncomp < 20 requested ')
      goto 999
 255  continue
      call basout(io,lunit,'bvode: m must be of size ncomp')
      goto 999
 256  continue
      call basout(io,lunit,'bvode: sum(m) must be less than 40')
      goto 999
 257  continue
      call basout(io,lunit,'bvode: sum(m) must be less than 40')

      goto 999
 258  continue
      call basout(io,lunit,'bvode: input data error')
      goto 999
 259  continue
      call basout(io,lunit,'bvode: no. of subintervals exceeds storage')
      goto 999
 260  continue
      call basout(io,lunit,'bvode: Th colocation matrix is singular')
      goto 999
 261  continue
      call basout(io,lunit,'Interface property table is full')
      goto 999
 262  continue
      goto 999
 263  continue
      goto 999
 264  continue
      goto 999
 265  continue
      goto 999
 266  continue
      goto 999
 267  continue
      goto 999
 268  continue
      goto 999
 269  continue
      goto 999
 270  continue
      goto 999
c
c
c---------------------------------------------------------------------
 998  continue
c     message d'erreur soft
      call basout(io,lunit,buf(1:80))
c
 999  return
      end

      subroutine errmds(num,imess,imode)
c     -------------------------
c     this routine extract error modes out of errct variable
c     imess:  if 0 error message is displayed
c     imode:  error recovery mode
c     num  : error to catch, if num=-1 all errors are catched
      include '../stack.h'
      integer num,imode,imess
c
      num=0
      if(errct.gt.0) then
        num=errct-100000*int(errct/100000)
        imode=errct/100000
       else if(errct.lt.0) then
        num=-1
        imode=-errct/100000
      endif
      imess=imode/8
      imode=imode-8*imess
c
      return
      end


      subroutine depfun(lunit,trace,first)
c     depile une macro pu un execstr
      include '../stack.h'
      integer lunit
      logical trace,first
      integer sadr,ll

c
      sadr(l)=(l/2)+1
c
      ll=lct(5)
      k=lpt(1)-(13+nsiz)
      lpt(1)=lin(k+1)
      lpt(2)=lin(k+2)
      lpt(6)=k

c     recherche du nom de la function correspondant a ce niveau
      lk=sadr(lin(k+6))
      if(lk.le.lstk(top+1)) then
         km=0
      else
         km=lin(k+5)-1
      endif
 1503 km=km+1
      if(km.gt.isiz)goto 1513
      if(lstk(km).ne.lk) goto 1503
c
 1513 continue
      ilk=lin(k+6)
      if(trace) then
         if(istk(ilk).ne.10) then
            if(first) then
               buf='at line '
               m=11
               first=.false.
               nlc=0
            else
               buf='line '
               m=6
               call whatln(lpt(1),lpt(2),lpt(6),nlc,l1,ifin)
            endif
            write(buf(m+1:m+5),'(i4)') lct(8)-nlc
            m=m+4
            buf(m+1:m+18)=' of function     '
            m=m+13
            if (km.le.isiz) call cvname(idstk(1,km),buf(m+1:m+nlgh),1)
            m=m+nlgh
         else
            buf='in  execstr instruction'
            m=26
         endif
         buf(m+1:m+14)=' called by :'
         m=m+14
         call basout(io,lunit,buf(1:m))
         lct(8)=lin(k+12+nsiz)
c     
         call whatln(lpt(1),lpt(2),lpt(6),nlc,l1,ifin)
         m=ifin-l1+1
         if(m.gt.ll) then
            l1=max(l1,lpt(2)-ll/2)
            m=min(ifin-l1,ll)
         endif

         if(l1.gt.0.and.m.gt.0.and.m+l1-1.le.lsiz) then
            call cvstr(m,lin(l1),buf(1:m),1)
            call basout(io,lunit,buf(1:m))
         endif
      endif
c
      macr=macr-1
      if(istk(ilk).ne.10.and.rstk(pt-1).ne.909) bot=lin(k+5)
      return
      end

      subroutine depexec(lunit,trace,first,pflag)
c     pflag ,indique si c'est une pause qui a ete depilee
      include '../stack.h'
      logical trace,first,pflag
      integer mode(2),lunit,ll

      ll=lct(5)
      if(rio.ne.rte) then
c     exec
         k=lpt(1)-(13+nsiz)
         lpt(1)=lin(k+1)
         lpt(2)=lin(k+4)
         lpt(6)=k
c
         if (trace) then
            if(first) then
               buf='at line '
               m=11
               first=.false.
               nlc=0
            else
               buf='line '
               m=6
            endif
            write(buf(m+1:m+5),'(i4)') lct(8)-nlc
            m=m+4
            buf(m+1:m+29)=' of exec file called by :'
            m=m+29
            call basout(io,lunit,buf(1:m))
            lct(8)=lin(k+12+nsiz)
c     
            call whatln(lpt(1),lpt(2),lpt(6),nlc,l1,ifin)
            m=ifin-l1+1
            if(m.gt.ll) then
               l1=max(l1,lpt(2)-ll/2)
               m=min(ifin-l1,ll)
            endif
            call cvstr(m,lin(l1),buf,1)
            call basout(io,lunit,buf(1:m))
         endif
         mode(1)=0
         call clunit(-rio,buf,mode)
 1505    pt=pt-1
         if(rstk(pt).ne.902) goto 1505
         rio=pstk(pt)
         pflag=.false.
      else
c     pause
         top=ids(2,pt-1)
         pflag=.true.
      endif
      return
      end


      subroutine errloc(n)
c     this routines shows the approximate location of the error in the
c     current statement
c!
      include '../stack.h'

      integer sadr

c
      character mg*9,bel*1,line*340
      integer n,ll,m,m1
      data mg /' !--error'/,bel/' '/
c
c      sadr(l)=(l/2)+1
c
      ll=lct(5)

      lunit = wte
      m1=lpt(2)-lpt(1)
      if(m1.lt.1) m1=1
c
      if(macr.eq.0.and.rio.eq.rte) goto 1000
      call whatln(lpt(1),lpt(2),lpt(6),nlc,l1,ifin)
      m=ifin-l1+1
      if(m.gt.ll) then
         l1=max(l1,lpt(2)-ll/2)
         m=min(ifin-l1,ll)
      endif
      m1=max(0,lpt(2)-l1)

      if(m.gt.0) then
         call cvstr(m,lin(l1),line,1)
         call basout(io,lunit,line(1:max(m,1)))
      endif
 1000 line=' '
      line(m1+1:m1+9)=mg
      write(line(m1+11:m1+15),'(i5)') n
      line(m1+16:m1+16)=bel
      call basout(io,lunit,line(1:m1+16))
      if(hio.gt.0) call basout(io,hio,line(1:m1+15))
      return
      end

