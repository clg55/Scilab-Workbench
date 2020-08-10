      subroutine intelm
      include '../stack.h'
      integer less,great,equal
      data less/59/,great/60/,equal/50/
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' intelm '//buf(1:4))
      endif
c
      if(fin.eq.1) then 
c     int32
         call convert(4)
      elseif(fin.eq.2) then
c     int16
         call convert(2)
      elseif(fin.eq.3) then
c     int8
         call convert(1)
      elseif(fin.eq.4) then
         call intinttype
      elseif(fin.eq.5) then
c     double
         call convert(0)
      elseif(fin.eq.6) then 
c     uint32
         call convert(14)
      elseif(fin.eq.7) then
c     uint16
         call convert(12)
      elseif(fin.eq.8) then
c     uint8
         call convert(11)
      elseif(fin.eq.9) then
         call i_mget
      elseif(fin.eq.10) then
         call i_mget
      elseif(fin.eq.11) then
         call i_mput
      elseif(fin.eq.12) then
         call i_convert
      elseif(fin.eq.13) then
         call i_abs
      elseif(fin.eq.14) then
         call i_diag
      elseif(fin.eq.15) then
         call i_triu
      elseif(fin.eq.16) then
         call i_tril
      elseif(fin.eq.17) then
         call i_sum
      elseif(fin.eq.18) then
c     %i_cumsum
         call i_cumsum
      elseif(fin.eq.19) then
c     %i_max
         call i_maxi
      elseif(fin.eq.20) then
c     %i_max
         call i_mini
      elseif(fin.eq.21) then
c         call readgif
      elseif(fin.eq.22) then
c         call readxbm
      elseif(fin.eq.23) then
         call i_p
      elseif(fin.eq.24) then
         call i_convert
      elseif(fin.eq.25) then
         call i_matrix
      endif
      return
      end

