      subroutine foptim (indsim,n,x,f,g,izs,rzs,dzs)
c!
c interface for use with optim
c!
      include '../stack.h'
      integer indsim,n,izs(*)
      double precision dzs(*),g(*),x(*),f
      real rzs(*)
c
      integer it1
c
      character*80   name,nam1
      common /optim/ name
c
      call majmin(80,name,nam1)
c
c INSERT CALL TO YOUR OWN ROUTINE HERE 
c The routine genros is an example: it is called when the
c string 'rosen' is given as a parameter 
c in the calling sequence of scilab's optim built-in
c function 
c+
      if (nam1.eq.'genros') then
c  Rosenbrock test (n>=3)
        call genros(indsim,n,x,f,g,izs,rzs,dzs)
        return
      elseif (nam1.eq.'topt2') then
c two level optimization
        call topt2(indsim,n,x,f,g,izs,rzs,dzs)
        return
      elseif (nam1.eq.'icsemc') then
c  ICSE
        call icsemc(indsim,n,x,f,g,izs,rzs,dzs)
        return
      endif
c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,indsim,n,x,f,g,izs,rzs,dzs)
cc fin
      return
c
 2000 indsim=0
      buf=name
      call error(50)
      return
      end

      subroutine genros(ind,n,x,f,g,izs,rzs,dzs)
c     Example of cost function given by a subroutine
c     if n<=2 returns ind=0
c     f.bonnans, oct 86
      implicit double precision (a-h,o-z)
      real rzs(1)
      double precision dzs(*)
      dimension x(n),g(n),izs(*)
      common/nird/nizs,nrzs,ndzs
      if (n.lt.3) then
        ind=0
        return
      endif
      if(ind.eq.10) then
         nizs=2
         nrzs=1
         ndzs=2
         return
      endif
      if(ind.eq.11) then
         izs(1)=5
         izs(2)=10
         dzs(2)=100.0d+0
         return
      endif
      if(ind.eq.2)go to 5
      if(ind.eq.3)go to 20
      if(ind.eq.4)go to 5
      ind=-1
      return
5     f=1.0d+0
      do 10 i=2,n
        im1=i-1
10      f=f + dzs(2)*(x(i)-x(im1)**2)**2 + (1.0d+0-x(i))**2
      if(ind.eq.2)return
20    g(1)=-4.0d+0*dzs(2)*(x(2)-x(1)**2)*x(1)
      nm1=n-1
      do 30 i=2,nm1
        im1=i-1
        ip1=i+1
        g(i)=2.0d+0*dzs(2)*(x(i)-x(im1)**2)
30      g(i)=g(i) -4.0d+0*dzs(2)*(x(ip1)-x(i)**2)*x(i) - 
     &        2.0d+0*(1.0d+0-x(i))
      g(n)=2.0d+0*dzs(2)*(x(n)-x(nm1)**2) - 2.0d+0*(1.0d+0-x(n))
      return
      end



      subroutine topt2(i,n,x,f,g,izs,rzs,dzs)
c     2 levels optimization test
      implicit double precision (a-h,o-z)
      dimension x(2),g(2),dzs(1)
      i=1
      f=(x(1)-dzs(1))**2 + 10* x(2)**2
      g(1)=2*(x(1)-dzs(1))
      g(2)=20*x(2)
      end


      subroutine icsemc(ind,nu,u,co,g,itv,rtv,dtv)
      external mcsec,icsec2,icsei
c      least square of LQ problems
      call icse(ind,nu,u,co,g,itv,rtv,dtv,mcsec,icsec2,icsei)
      end

      subroutine mcsec(indf,t,y,uc,uv,f,fy,fu,b,itu,dtu,
     & t0,tf,dti,dtf,ermx,iu,nuc,nuv,ilin,nti,ntf,ny,nea,
     & itmx,nex,nob,ntob,ntobi,nitu,ndtu)
c
c      RHS of state equation
c       input parameters:
c        indf     : 1,2,3 repectively if f,fy,fu is to be calculated
c        t        : current time
c        y(ny)    : state vector
c        uc(nuc)  : time independent control
c        uv(nuv)  : time dependent control
c        b(ny)    : constant term in the LQ case
c       output parameters :
c         indf    : >0 if computation is correct,<=0 if not
c        f(ny)    : rhs
c        fy(ny,ny): jacobian of f wrt y
c        fu(ny,nuc+nuv) : derivative of f wrt u
c       Working arrays (for the user) :
c        itu(nitu): integer array
c        dtu(ndtu): double precision array
c       (nitu and  ndtu are initialized in common icsez).
c!
      implicit double precision (a-h,o-z)
      dimension y(ny),uc(*),uv(*),f(ny),fy(ny,ny),fu(ny,*),
     &     b(ny),itu(*),dtu(*),iu(5)
c
      if (indf.eq.1) then
         do 50 i=1,ny
            fii=b(i)
            do 20 j=1,ny
               fii=fii+fy(i,j)*y(j)
 20         continue
            if(nuc.gt.0) then
               do 30 j=1,nuc
                  fii=fii+fu(i,j)*uc(j)
 30            continue
            endif
            if(nuv.gt.0) then
               jj=0
               do 40 j=1+nuc,nuv+nuc
                  jj=jj+1
                  fii=fii+fu(i,j)*uv(jj)
 40            continue
            endif
            f(i)=fii
 50      continue
         return
      endif
      end

