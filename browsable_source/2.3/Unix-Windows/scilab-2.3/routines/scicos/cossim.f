      subroutine cossim(neq,x,xptr,z,zptr,iz,izptr,told,tf
     $     ,tevts,evtspt,nevts,pointi,inpptr,inplnk,outptr
     $     ,outlnk,lnkptr,clkptr,ordptr,nptr,execlk,nexecl
     $     ,ordclk,nordcl,cord,iord,niord,oord,zord,critev,
     $     rpar,rpptr,ipar
     $     ,ipptr,funptr,funtyp,rhot,ihot,outtb,jroot,w,ierr) 
C     
C     
C..   Parameters .. 
c     maximum number of clock output for one block
      integer nts
      parameter (nts=100)
C     
      integer neq(*)
C     neq must contain after #states all integer data for simblk and grblk
      double precision x(*),z(*),told,tf,tevts(*),rpar(*),outtb(*)
      double precision w(*),rhot(*)
C     X must contain after state values all real data for simblk and grblk
      integer xptr(*),zptr(*),iz(*),izptr(*),evtspt(nevts),nevts,pointi
      integer inpptr(*),inplnk(*),outptr(*),outlnk(*),lnkptr(*)
      integer clkptr(*),ordptr(nptr,2),nptr,execlk(nexecl,2),nexecl
      integer ordclk(nordcl,2),nordcl,cord(*),iord(*),oord(*),zord(*)
      integer critev(*),rpptr(*),ipar(*),ipptr(*),funptr(*),funtyp(*)
      integer ihot(*),jroot(*),ierr
c
      logical hot,stuck
      integer i,k,ierr1,iopt,istate,itask,j,jdum,jt,
     &     ksz,flag,keve,kpo,nord,nclock
      double precision t
      double precision tvec(nts)
c
      external grblk,simblk

      integer otimer,ntimer,stimer
      external stimer

      integer         nblk,nxblk,ncblk,ndblk,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
      common /cossiz/ nblk,nxblk,ncblk,ndblk,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
C     
      integer halt
      common /coshlt/ halt
c
      integer kfun
      common /curblk/ kfun
c     
      double precision atol,rtol,ttol,deltat
      common /costol/ atol,rtol,ttol,deltat
c
      save otimer
      data otimer/0/
c    
      ierr = 0
      hot = .false.
      stuck=.false.
      call xscion(inxsci)
C     initialization
      call iset(niwp,0,ihot,1)
      call dset(nrwp,0.0d0,rhot,1)

      ntvec=0
      nclock = 0
c     initialisation (propagation of constant blocks outputs)
      if(niord.eq.0) goto 10
      do 05 jj=1,niord
          kfun=iord(jj)
         flag=1
         call callf(kfun,nclock,funptr,funtyp,told,x,x,xptr,z,zptr,iz,
     $        izptr,rpar,rpptr,ipar,ipptr,tvec,ntvec,inpptr,inplnk
     $        ,outptr,outlnk,lnkptr,outtb,flag) 
         if (flag .lt. 0) then
            ierr = 5 - flag
            return
         endif
 05   continue
C     main loop on time
 10   continue
      if (told .ge. tf) return
      if (inxsci.eq.1) then
         ntimer=stimer()
         if (ntimer.ne.otimer) then
            call sxevents()
            otimer=ntimer
            if (halt.ne.0) then
               halt=0
               return
            endif
         endif
      endif
      if (pointi.eq.0) then
         t = tf
      else
         t = tevts(pointi)
      endif
      if (abs(t-told) .lt. ttol) then
         t = told
C     update output part
      endif
      if (told .gt. t) then
C     !  scheduling problem
         ierr = 1
         return
      endif
      if (told .ne. t) then
         if (nxblk .eq. 0) then
C     no continuous state
            if(told+deltat+ttol.gt.t) then
               told=t
            else
               told=told+deltat
            endif
c     .     update outputs of 'c' type blocks
            ntvec=0
            nclock = 0
            if (ncord.gt.0) then
               do 19 jj=1,ncord
                  kfun=cord(jj)
                  flag=1
                  call callf(kfun,nclock,funptr,funtyp,told,x,x,xptr,z,
     $                 zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,ntvec,
     $                 inpptr,inplnk,outptr,outlnk,lnkptr,outtb,flag) 
                  if (flag .lt. 0) then
                     ierr = 5 - flag
                     return
                  endif
 19            continue
            endif
         else
C     integrate
            if (hot) then
               istate = 2
            else
               istate = 1
            endif
            itask = 4
C     Compute tcrit (rhot(1))
            rhot(1)=tf+ttol
            kpo=pointi
 20         if(critev(kpo).eq.1) then
               rhot(1)=tevts(kpo)
               goto 30
            endif
            kpo=evtspt(kpo)
            if(kpo.ne.0) goto 20
 30         continue
c     
            
c     .     form initial zero crossing input signs
            ig=1
            if (ng.gt.0) then
c     .        loop on zero crossing block
               do 35 kfun=ncblk+ndblk+1,nblk
c     .           loop on block ports
                  do 34 kport=inpptr(kfun),inpptr(kfun+1)-1
                     klink=inplnk(kport)
                     do 33 i=lnkptr(klink),lnkptr(klink+1)-1
                        if (outtb(i).gt.0.d0) then
                           jroot(ng+ig) = 1
                        else
                           jroot(ng+ig) = 0
                        endif
                        ig=ig+1
 33                  continue
 34               continue
 35            continue
            endif
c     
            iopt = 0
c
            jt = 2
            t=min(told+deltat,min(t,tf+ttol))
c     
c
            call lsodar(simblk,neq,x,told,t,1,rtol,atol,itask,
     &           istate,iopt,rhot,nrwp,ihot,niwp,jdum,jt,grblk,
     &           ng,jroot)
            if (istate .le. 0) then
               if (istate .eq. -3) then
                  if(stuck) then
                     ierr= 2
                     return
                  endif
                  itask = 2
                  istate = 1
                  call lsoda(simblk,neq,x,told,t,
     &                 1,rtol,atol,itask,
     &                 istate,iopt,rhot,nrwp,ihot,niwp,jdum,jt)
                  hot = .false.
                  stuck=.true.
                  if (istate .gt. 0) goto 38
               endif
C     !        integration problem
               ierr = 100-istate
               return
            endif
            hot = .true.
            stuck=.false.
 38         continue
c     .     update outputs of 'c' type  blocks
            nclock = 0
            ntvec=0
            if (ncord.gt.0) then
               do 39 jj=1,ncord
                  kfun=cord(jj)
                  flag=1
                  call callf(kfun,nclock,funptr,funtyp,told,x,x,xptr,z,
     $                 zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,ntvec,
     $                 inpptr,inplnk,outptr,outlnk,lnkptr,outtb,flag) 
                  if (flag .lt. 0) then
                     ierr = 5 - flag
                     return
                  endif
 39            continue
            endif
            if (istate .eq. 3) then
C     .        at a least one root has been found
               ig = 1
               do 50 kfun = ncblk+ndblk+1,nblk
c     .           loop on block input ports
                  ksz=0
                  do 42 kport=inpptr(kfun),inpptr(kfun+1)-1
c     .              get corresponding link pointer 
                     klink=inplnk(kport)
                     ksz=ksz+lnkptr(klink+1)-lnkptr(klink)
 42               continue
c     .           kev is a base 2 coding of reached zero crossing surfaces
                  kev=0
                  do 44 j = 1,ksz
                     kev=2*kev+jroot(ig+ksz-j)
 44               continue
                  jjflg=1
                  if (kev.eq.0) jjflg=0
                  do 45 j = 1,ksz
                     kev=2*kev+jroot(ng+ig+ksz-j)
 45               continue
                  ig=ig+ksz
                  if (jjflg .ne. 0) then
                     flag=3
                     ntvec=clkptr(kfun+1)-clkptr(kfun)
c     .              call corresponding block to determine output event (kev)
                     call callf(kfun,kev,funptr,funtyp,told,x,x,xptr,z,
     $                    zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $                    ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $                    outtb,flag) 
                     if(flag.lt.0) then
                        ierr=5-flag
                        return
                     endif
c     .              update event agenda
                     do 47 k=1,clkptr(kfun+1)-clkptr(kfun)
                        if (tvec(k).ge.told) then
                           if (critev(k+clkptr(kfun)-1).eq.1)
     $                          hot=.false.
                           call addevs(tevts,evtspt,nevts,pointi,
     &                          tvec(k),k+clkptr(kfun)-1,ierr1)
                           if (ierr1 .ne. 0) then
C     .                       nevts too small
                              ierr = 3
                              return
                           endif
                        endif
 47                  continue
                  endif
 50            continue
            endif
c     !     save initial signs of zero crossing surface
c     
         endif
      else
C     .  t==told
         keve = pointi
         pointi=evtspt(keve)
         evtspt(keve)=-1
c
         nord=ordptr(keve+1,1)-ordptr(keve,1)
         if(nord.eq.0) goto 79
c     .  update continuous and discrete states on event
         do 61 ii=ordptr(keve,1),ordptr(keve+1,1)-1
            kfun=execlk(ii,1)
            if(xptr(kfun+1)-xptr(kfun)+zptr(kfun+1)-zptr(kfun)
     $           .gt.0) then
C     .     If continuous state jumps, do cold restart
               if(kfun.le.nxblk) hot=.false.
               flag=2
               call callf(kfun,execlk(ii,2),funptr,funtyp,told,w,x,
     $              xptr,z,zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $              ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $              outtb,flag) 
               if(flag.lt.0) then
                  ierr=5-flag
                  return
               endif
            endif
 61      continue

 79      continue
c 
         nord=ordptr(keve+1,2)-ordptr(keve,2)
c         
         if(nord.gt.0) then
            do 80 jj=1,nord
               kfun=ordclk(ordptr(keve,2)-1+jj,1)
               nclock=ordclk(ordptr(keve,2)-1+jj,2)
               flag=1
               call callf(kfun,nclock,funptr,funtyp,told,w,x,xptr,z,
     $              zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $              ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $              outtb,flag) 
               if(flag.lt.0) then
                  ierr=5-flag
                  return
               endif
 80         continue
         endif

c
         nord=ordptr(keve+1,1)-ordptr(keve,1)
         if(nord.eq.0) goto 10
c
         do 60 ii=ordptr(keve,1),ordptr(keve+1,1)-1
            kfun=execlk(ii,1)
c     .     Initialize tvec
            ntvec=clkptr(kfun+1)-clkptr(kfun)
            if(ntvec.gt.0) then
               call dset(ntvec,told-1.0d0,tvec,1)
c     
               flag=3
               call callf(kfun,execlk(ii,2),funptr,funtyp,told,w,x,
     $              xptr,z,zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $              ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $              outtb,flag) 
               if(flag.lt.0) then
                  ierr=5-flag
                  return
               endif
c     
               if (ntvec.ge.1) then 
                  do 70 i = 1,ntvec
                     if (tvec(i) .ge. told) then
                        call addevs(tevts,evtspt,nevts,pointi,
     &                       tvec(i),i+clkptr(kfun)-1,ierr1)
                        if (ierr1 .ne. 0) then
C     !                 event conflict
                           ierr = 3
                           return
                        endif
                     endif
 70               continue
               endif
            endif
 60      continue
      endif
C     end of main loop on time
      goto 10
      end

 
