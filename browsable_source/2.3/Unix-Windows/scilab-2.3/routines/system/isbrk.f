      subroutine isbrk(l)
c ====================================================================
c
c       retourne la valeur de l'indicateur d'interruption
c
c ===================================== ( Inria    ) ==========
c
      logical         iflag
      common /basbrk/ iflag
      l=0
      if(iflag) l=1
      return
      end
