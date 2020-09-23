      subroutine basout(io,lunit,string)
c     gestion des sorties sur le "standard output" de scilab.
c
      include '../stack.h'
      character*(*) string
      character ch*1
c
      if(lunit.eq.wte) then
c        Sortie sur la sortie standard
         call xscion(iflag)
         io=0
         if(lct(1).eq.-1) return
         if(lct(2).gt.0) then
c           Gestion de la pagination
            if(lct(1)+2.gt.lct(2)) then
c              nombre maxi de ligne atteint,gestion du more
               lct(1)=0
               if (iflag.eq.0) then 
c                 scilab n'a pas de  fenetre propre
                  write(wte, '('' more ?'',$)')
                  read(rte,'(a1,$)') ch
                  if(ch.ne.' ') ich=1
               else
c                 scilab a une  fenetre  en propre
                  call xscimore(ich)
               endif
               if(ich.eq.1) then
                  lct(1)=-1
                  io=-1
                  return
               endif
            else
               lct(1)=lct(1)+1
            endif
         endif
         if(iflag.eq.0) then
            write(lunit,'(a)') string
         else
            call xscistring(string,len(string))
         endif
c        impression eventuelle du "diary"
         if(wio.ne.0) write(wio,'(a)') string
      else
c        sortie sur fichier
         write(lunit,'(a)') string
      endif
      end

      subroutine basou1(lunit,string)
c     gestion des sorties sur le "standard output" de scilab.
c     la ligne editee n'est pas suivie de retour a la ligne
c
      include '../stack.h'
      character*(*) string
      if (lunit.eq.wte) then 
         call xscion(iflag)
         if (iflag.eq.0) then 
            write(lunit,'(a,$)') string
         else
            buf = string//char(0)
            call xscisncr(buf)
            if(wio.ne.0) write(wio,'(a,$)') string
         endif
      else
         write(lunit,'(a,$)') string
      endif
      end

