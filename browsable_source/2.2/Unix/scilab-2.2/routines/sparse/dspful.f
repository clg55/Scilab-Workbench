      subroutine dspful(ma,na,a,nela,inda,r)
      double precision a(*),r(*)
      integer ma,na,nela,inda(*)
c
      call dset(ma*na,0.0d0,r,1)
      i0=0
      i1=i0
      i=1
      do 10 k=1,nela
 08      i0=i0+1
         if(i0-i1.gt.inda(i)) then
            i1=i0
            i=i+1
            goto 08
         endif
         j=inda(ma+k)
         r(1+(i-1)+(j-1)*ma)=a(k)
 10   continue
      end
