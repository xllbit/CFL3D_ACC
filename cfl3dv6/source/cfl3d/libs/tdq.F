      subroutine tdq(n,r1,r2,r3,r4,r5,kx,ky,kz,lx,ly,lz,mx,my,mz,c,
     .               ub,rho,u,v,w,max,eig2,eig3,xm2a)
      use precond_x
c
c     $Id: tdq.F,v 1.2 2001/05/25 20:00:09 biedron Exp $
c
c***********************************************************************
c     Purpose:  Multiply the inverse of the diagonalizing matrix
c     T times the change in characteristic combination of variables.
c     Modified for Weiss-Smith preconditioning by J.R. Edwards, NCSU
c       cprec = 0 ---> original code used
c             > 0 ---> modified code used
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      dimension  r1(max),r2(max),r3(max),r4(max),r5(max)
      dimension  c(max),ub(max), u(max), v(max), w(max),rho(max)
      dimension  xm2a(max),eig2(max), eig3(max)
      dimension  kx(max),ky(max),kz(max)
      dimension  lx(max),ly(max),lz(max)
      dimension  mx(max),my(max),mz(max)
c
#   ifdef CMPLX
      complex kx,ky,kz,lx,ly,lz,mx,my,mz
#   else
      real kx,ky,kz,lx,ly,lz,mx,my,mz
#   endif
c
c      common /precond/ cprec,uref,avn
c
c     M(inverse)*T*R
c
      if (real(cprec) .eq. 0.) then
cdir$ ivdep
         do 1000 m=1,n
         t1      = 1.0/rho(m)
         t2      = t1*r2(m)
         t3      = t1*r3(m)
         t5      = t1* c(m)*(r4(m)-r5(m))
c
         r5(m) = r4(m)+r5(m)
         r1(m) = r1(m)+r5(m)
         r5(m) = c(m)*c(m)*r5(m)
c
         r2(m) = lx(m)*t2+mx(m)*t3+kx(m)*t5
         r3(m) = ly(m)*t2+my(m)*t3+ky(m)*t5
         r4(m) = lz(m)*t2+mz(m)*t3+kz(m)*t5
 1000    continue
      else
cdir$ ivdep
         do 10001 m=1,n
c
c        modifications for preconditioning
c
         xm2ar = 1.0/xm2a(m)
         fplus = (eig2(m)-ub(m))*xm2ar
         fmins = -(eig3(m)-ub(m))*xm2ar
         fsum = 2.0/(fplus+fmins)
c
         t1      = 1.0/rho(m)
         t2      = t1*r2(m)
         t3      = t1*r3(m)
         t5      = t1* c(m)*(fmins*r4(m)-fplus*r5(m))*fsum
c
         r5(m) = (r4(m)+r5(m))*fsum
         r1(m) = r1(m)+r5(m)
         r5(m) = c(m)*c(m)*r5(m)
c
         r2(m) = lx(m)*t2+mx(m)*t3+kx(m)*t5
         r3(m) = ly(m)*t2+my(m)*t3+ky(m)*t5
         r4(m) = lz(m)*t2+mz(m)*t3+kz(m)*t5
10001    continue
      end if
      return
      end
