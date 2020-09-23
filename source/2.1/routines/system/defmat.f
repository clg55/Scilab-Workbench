      subroutine defmat
c     ---------------------------------
C     Add an empty matrix on the stack 
C     and blank var on vars
C     ---------------------------------
      include '../stack.h'
      logical compil,cremat
      integer bl(nsiz)
      data bl/nsiz*673720360/
      if(err1.gt.0) return
c     compilation  [4]
      if(compil(4,0,0,0,0)) return 
      if(top.eq.0) lstk(1)=1
      if(top+2 .ge. bot) then
         call error(18)
         return
      endif
      top = top+1
      call putid(idstk(1,top),bl)
      if (.not.cremat(fname,top,0,0,0,lr,lc)) return      
      return
      end
