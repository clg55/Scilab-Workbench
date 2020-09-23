      subroutine badd(ny,t,y,ml,mu,p,nrowp)
c
c ======================================================================
c      interface pour l'external add de IMPL
c ======================================================================
c
      INCLUDE '../stack.h'
      integer iadr,sadr
c     
      double precision y(ny),p(nrowp,ny),t(*)
      common/ierode/iero
c     
      integer vol,tops,nordre
      data nordre/2/,mlhs/1/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
c     nordre est le numero d'ordre de cet external dans la structure
c     de donnee,
c     mlhs (mrhs) est le nombre de parametres de sortie (entree)
c     du simulateur 
c     
      iero=0
      mrhs=3
c     
      ilp=iadr(lstk(top))
      il=istk(ilp+nordre)
c     
c     transfert des arguments d'entree minimaux du simulateur
c     la valeur de ces arguments vient du contexte fortran (liste d'appel)
c     la structure vient du contexte 
c+    
      call ftob(t,1,istk(il+1))
      if(err.gt.0) goto 9999
      call ftob(y,ny,istk(il+2))
      if(err.gt.0) goto 9999
c     
      top=top+1
      if(top+1.ge.bot) then
         call error(18)
         if(err.gt.0) return
      endif
      err=lstk(top)+2+ny*ny-lstk(bot)
      if(err.gt.0) then
         call error(17)
         if(err.gt.0) return
      endif
      ilp1=iadr(lstk(top))
      istk(ilp1)=1
      istk(ilp1+1)=ny
      istk(ilp1+2)=ny
      istk(ilp1+3)=0
      lp1=sadr(ilp1+4)
      call dcopy(ny*ny,p,1,stk(lp1),1)
      lstk(top+1)=lp1+ny*ny
c     call ftob(p,ny,istk(il+3))
c+    
c     
      tops=istk(il)
      ils=iadr(lstk(tops))
      if(istk(ils).eq.15) goto 10
c     
c     recuperation de l'adresse du simulateur
      fin=lstk(tops)
c     
      goto 40
c     cas ou le simulateur est decrit par une liste
 10   nelt=istk(ils+1)
      l=sadr(ils+3+nelt)
      ils=ils+2
c     
c     recuperation de l'adresse du simulateur
      fin=l
c     
c     gestion des parametres supplementaires du simulateur
c     proviennent du contexte  (elements de la liste
c     decrivant le simulateur
c     
      nelt=nelt-1
      if(nelt.eq.0) goto 40
      l=l+istk(ils+1)-istk(ils)
      vol=istk(ils+nelt+1)-istk(ils+1)
      if(top+1+nelt.ge.bot) then
         call error(18)
         if(err.gt.0) goto 9999
      endif
      err=lstk(top+1)+vol-lstk(bot)
      if(err.gt.0) then
         call error(17)
         if(err.gt.0) goto 9999
      endif
      call dcopy(vol,stk(l),1,stk(lstk(top+1)),1)
      do 11 i=1,nelt
         top=top+1
         lstk(top+1)=lstk(top)+istk(ils+i+1)-istk(ils+i)
 11   continue
      mrhs=mrhs+nelt
 40   continue
c     
c     execution de la macro definissant le simulateur
c     
      iero=0
      pt=pt+1
      if(pt.gt.psiz) then
         call error(26)
         if(err.gt.0) goto 9999
      endif
      ids(1,pt)=lhs
      ids(2,pt)=rhs
      rstk(pt)=1001
      lhs=mlhs
      rhs=mrhs
      niv=niv+1
      fun=0
c     
      icall=5
      krec=12
c
      include '../callinter.h'
c     
 200  lhs=ids(1,pt)
      rhs=ids(2,pt)
      pt=pt-1
c+    
c     transfert des variables  de sortie vers fortran
      call btof(p,ny*ny)
      if(err.gt.0) goto 9999
c+    
      niv=niv-1
      return
c     
 9999 continue
      iero=1
      niv=niv-1
      return

      end

