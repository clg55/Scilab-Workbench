c     The main program is written in C for gc-win32
c     this routine is mainly used for transfer to Fortran 
c     from C main 
c     ---------------------------------------------
      subroutine mainsci(nos1)
      integer nos,now,idisp,mem,nos1
      common /comnos/nos,mem
      data now,idisp /0,0/
      nos=nos1
      mem=0
      idisp=0
      now=0
      mem=max(mem,180000)
      if (nos.eq.0) call settmpdir()
      call scilab(nos)
      end

