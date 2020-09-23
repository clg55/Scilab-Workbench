      subroutine scope(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c     ipar(1) = win_num
c     ipar(2) = 0/1 color flag
c     ipar(2+i) = line type for ith curve
c
c     rpar(1)=dt
c     rpar(2)=ymin
c     rpar(3)=ymax
c     rpar(4)=periode
c
      double precision dt,ymin,ymax,per,rect(4),tsave
      integer i,n,verb,cur,na,v,wid,nax(4)
      character*20 strf,buf
      double precision dv
      double precision frect(4)
      character*(4) logf
      common /dbcos/ idb
      data frect / 0.00d0,0.00d0,1.00d0,1.00d0/
      data cur/0/

c     
      if(idb.eq.1) then
         write(6,'(''Scope t='',e10.3,'' flag='',i1,''window='',i3)') t
     $        ,flag,ipar(1) 
      endif
c     
      if(flag.eq.2) then
         dt=rpar(1)
         ymin=rpar(2)
         ymax=rpar(3)
         per=rpar(4)
         wid=ipar(1)
         N=ipar(3)

         K=int(z(1))
         n1=int(z(1+K)/per)
         if(z(1+K).lt.0.0d0) n1=n1-1
c     
         tsave=t
         if(dt.gt.0.0d0) t=z(1+K)+dt
c     
         n2=int(t/per)
         if(t.lt.0.0d0) n2=n2-1
c     
c     add new point to the buffer
         K=K+1
         z(1+K)=t
         do 01 i=1,nu
            z(1+N+(i-1)*N+K)=u(i)
 01      continue
         z(1)=K
         if(n1.eq.n2.and.K.lt.N) then
            t=tsave
            return
         endif
c     
c     plot 1:K points of the buffer
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
         call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &        0,0,v,dv,dv,dv,dv)
         buf='xlines'//char(0)
         do 10 i=1,nu
            call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(3+i),
     &           1,K,v,z(2),z(2+N+(i-1)*N),dv,dv)
 10      continue
c     shift buffer left
         z(2)=z(1+K)
         do 15 i=1,nu
            z(1+N+(i-1)*N+1)=z(1+N+(i-1)*N+K)
 15      continue
         z(1)=1.0d0
         if(n1.ne.n2) then
c     clear window
            nax(1)=2
            nax(2)=10
            nax(3)=2
            nax(4)=10
            call dr1('xclear'//char(0),'v'//char(0),v,v,v,v,v,v,
     $           dv,dv,dv,dv)
            call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &           0,0,v,dv,dv,dv,dv)
            call dr('xstart'//char(0),'v'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
            buf='t@ @input and output'
            strf='011'//char(0)
            rect(1)=per*(1+n1)
            rect(2)=ymin
            rect(3)=per*(2+n1)
            rect(4)=ymax
            call dr1('xset'//char(0),'dashes'//char(0),0,0,0,
     &           0,0,v,dv,dv,dv,dv)
c            call dr1('xset'//char(0),'clipping-p'//char(0),-1.0d0,
c     &           -1.0d0,200000.0d0,200000.0d0,v,dv,dv,dv,dv)
            call plot2d(rect(1),rect(2),1,1,-1,strf,buf,rect,nax)
c            call dr1('xset'//char(0),'clipping'//char(0),rect(1),ymin,per,
c     &           ymax,v,dv,dv,dv,dv)
         endif

c         if(cur.ne.wid) then
c            call dr1('xset'//char(0),'window'//char(0),cur,v,v,v,v,v,
c     &           dv,dv,dv,dv)
c         endif
c
         t=tsave
c
      elseif(flag.eq.4) then
         wid=ipar(1)
         N=ipar(3)
         ymin=rpar(2)
         ymax=rpar(3)
         per=rpar(4)
         nax(1)=2
         nax(2)=10
         nax(3)=2
         nax(4)=10
         n1=int(t)/per
         if(t.le.0.0d0) n1=n1-1
         call sciwin()
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
         logf='nn'//char(0)
         call  setscale2d(frect,frect,logf)
         call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &        0,0,v,dv,dv,dv,dv)
         call dr1('xclear'//char(0),'v'//char(0),v,v,v,v,v,v,
     $        dv,dv,dv,dv)
         call dr('xstart'//char(0),'v'//char(0),wid,v,v,v,v,v,
     $        dv,dv,dv,dv)
         buf='t@ @input and output'
         strf='011'//char(0)
         rect(1)=per*(1+n1)
         rect(2)=ymin
         rect(3)=per*(2+n1)
         rect(4)=ymax
         call  setscale2d(frect,rect,'nn'//char(0))
         call dr1('xset'//char(0),'dashes'//char(0),0,0,0,
     &        0,0,v,dv,dv,dv,dv)
c        call dr1('xset'//char(0),'clipping-p'//char(0),-1.0d0,
c     &        -1.0d0,200000.0d0,200000.0d0,v,dv,dv,dv,dv)
         call plot2d(rect(1),rect(2),1,1,-1,strf,buf,rect,nax)
c        call dr1('xset'//char(0),'clipping'//char(0),rect(1),ymin,per,
c     &           ymax,v,dv,dv,dv,dv)

c         if(cur.ne.wid) then
c            call dr1('xset'//char(0),'window'//char(0),cur,v,v,v,v,v,
c     &           dv,dv,dv,dv)
c         endif
         z(1)=1
         z(2)=t
         call dset(nu*N,0.0d0,z(3),1)
      elseif(flag.eq.5) then
         wid=ipar(1)
         N=ipar(3)
         K=int(z(1))
         if(K.eq.1) return
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
         call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &        0,0,v,dv,dv,dv,dv)
         buf='xlines'//char(0)
         do 30 i=1,nu
            call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(3+i),
     &           n1,K-1,v,z(2),z(2+N+(i-1)*nu),dv,dv)
 30      continue
c         if(cur.ne.wid) then
c            call dr1('xset'//char(0),'window'//char(0),cur,v,v,v,v,v,
c     $           dv,dv,dv,dv)
c         endif
      endif
      end
