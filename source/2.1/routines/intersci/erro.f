      subroutine erro(str)
      include '../stack.h'
      character *(*) str
      buf = str
      call error(9999)
      end
