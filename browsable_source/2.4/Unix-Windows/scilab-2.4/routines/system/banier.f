      subroutine banier( wwte )
c ====================================================================
c      prints entry message for scilab 
c      wwte   unite d'impression du terminal
c ================================== ( inria    ) =============
      integer    wwte
      integer    io
      if(wwte.ne.999) then 
         call basout(io,wwte,
     $'                           ===========')
         call basout(io,wwte,
     $'                           S c i l a b')
         call basout(io,wwte,
     $'                           ===========')
         call basout(io,wwte,' ')
         call basout(io,wwte,' ')
         call basout(io,wwte,
     $'                  Scilab-2.4  (July 12, 1998) ')
         call basout(io,wwte,
     $'                  Copyright (C) 1989-98 INRIA ')
      endif
      return 
      end
