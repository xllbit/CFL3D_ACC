#   ifdef CMPLX
      complex function q8sdot(n,a,idum1,b)
#   else
      real function q8sdot(n,a,idum1,b)
#   endif
c
c     $Id: q8sdot.F,v 1.2 2001/05/25 20:00:07 biedron Exp $
c
c***********************************************************************
c     Purpose:  Compute the dot product between two vectors.
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      dimension a(n),b(n)
      q8sdot = 0.
      do 10 i=1,n
   10 q8sdot = q8sdot+a(i)*b(i)
      return
      end
