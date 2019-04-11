#   ifdef CMPLX
      complex function q8smin(n,a)
#   else
      real function q8smin(n,a)
#   endif
c
c     $Id: q8smin.F,v 1.2 2001/05/25 20:00:07 biedron Exp $
c
c***********************************************************************
c     Purpose:  Find the minimum value in an array.
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      dimension a(n)
      q8smin = a(1)
      do 10 i=2,n
   10 if (real(q8smin).gt.real(a(i))) q8smin = a(i)
      return
      end
