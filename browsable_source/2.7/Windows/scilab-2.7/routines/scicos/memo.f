      subroutine memo(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,
     &     rpar,nrpar,ipar,nipar,u,nu,y,ny)
c     Copyright INRIA

c     Scicos block simulator
c     returns sample and hold  of the input
c
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*)
      integer nipar,nu,ny
c
      if(flag.eq.2) then
         do 15 i=1,nu
            y(i)=u(i)
 15      continue
      elseif(flag.eq.4) then
         do 25 i=1,nu
            y(i)=rpar(i)
 25      continue
       endif
      end
