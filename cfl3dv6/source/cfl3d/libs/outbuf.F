      subroutine outbuf(str,iunit)
c
c     $Id: outbuf.F,v 1.4 2003/07/07 14:15:04 biedron Exp $
c
c***********************************************************************
c     Purpose:  Write the output buffer (array).
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      character*1 str(120)
      do i=120,1,-1
         if(str(i).ne.' ') go to 10
      end do
   10 continue
      write(iunit,1) (str(k),k=1,i)
    1 format(120a1)
      call my_flush(iunit)
      return
      end
