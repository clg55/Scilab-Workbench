      subroutine cosini(x,xptr,z,zptr,iz,izptr,told,inpptr,inplnk,
     $     outptr,outlnk,lnkptr,cord,rpar,rpptr,ipar,ipptr,funptr,
     $     funtyp,outtb,outt,w,ierr) 
C     
C     
C     
      double precision x(*),z(*),told,rpar(*),outtb(*),outt(*),w(*)
      integer xptr(*),zptr(*),iz(*),izptr(*)
      integer inpptr(*),inplnk(*),outptr(*),outlnk(*),lnkptr(*)
      integer cord(*)
      integer rpptr(*),ipar(*),ipptr(*),funptr(*),funtyp(*),ierr
c
      integer i,jj,flag,nclock,ntvec
      double precision tvec(1)
c
      integer nblk,nxblk,ncblk,ndblk,nout,ng,nrwp,
     &     niwp,ncord,noord,nzord
      common /cossiz/ nblk,nxblk,ncblk,ndblk,nout,ng,nrwp,
     &     niwp,ncord,noord,nzord
C     
      integer kfun
      common /curblk/ kfun

C     
      ierr = 0
C     initialization (flag 4)
C     loop on blocks
      tvec(1)=0.0d0
      ntvec=0
      call dset(nout,0.0d0,outt,1)

      do 5 kfun=1,nblk
         flag=4
         call callf(kfun,nclock,funptr,funtyp,told,x,x,xptr,z,zptr,iz,
     $        izptr,rpar,rpptr,ipar,ipptr,tvec,ntvec,inpptr,inplnk,
     $        outptr,outlnk,lnkptr,outtb,flag) 
         if(flag.lt.0) then
            ierr=5-flag
            return
         endif
 5    continue
 
C     initialization (flag 6)
c     update output of 'c' type blocks
      nclock = 0
      tvec(1)=0.0d0
      ntvec=0
      if(ncord.gt.0) then
         do 10 jj=1,ncord
            kfun=cord(jj)
            flag=1
            call callf(kfun,nclock,funptr,funtyp,told,x,x,xptr,z,zptr,iz
     $           ,izptr,rpar,rpptr,ipar,ipptr,tvec,ntvec,inpptr,inplnk
     $           ,outptr,outlnk,lnkptr,outtb,flag) 
            if (flag .lt. 0) then
               ierr = 5 - flag
               return
            endif
 10      continue
      endif

c     
c     point-fix iterations
c     
      do 50 i=1,nblk
C     loop on blocks
         do 11 kfun=1,nblk
            flag=6
            call callf(kfun,0,funptr,funtyp,told,w,x,xptr,z,
     $           zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $           ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $           outtb,flag) 
            if(flag.lt.0) then
               ierr=5-flag
               return
            endif
 11      continue
c         write(*,'(e10.3,e10.3,e10.3,e10.3,e10.3,e10.3,
c     &        e10.3,e10.3)') outtb(1),outtb(2),outtb(3),
c     &        outtb(4),outtb(5),outtb(6),outtb(7),outtb(8)

c     update outputs of 'c' type blocks
         nclock = 0
         tvec(1)=0.0d0
         ntvec=0
         if(ncord.gt.0) then
            do 12 jj=1,ncord
               kfun=cord(jj)
               flag=1
               call callf(kfun,nclock,funptr,funtyp,told,x,x,xptr,z,zptr
     $              ,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,ntvec,inpptr
     $              ,inplnk,outptr,outlnk,lnkptr,outtb,flag) 
               if (flag .lt. 0) then
                  ierr = 5 - flag
                  return
               endif
 12         continue
         endif
         do 20 jj=1,nout
            if(outtb(jj).ne.outt(jj)) goto 30
 20     continue
         return
 30     continue
         call dcopy(nout,outtb,1,outt,1)
 50   continue
      ierr=20
      end      
