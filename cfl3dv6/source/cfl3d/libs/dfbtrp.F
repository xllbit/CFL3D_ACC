      subroutine dfbtrp(nvmax,n,nmax,il,iu,a,b,c,f,g,h)
c
c     $Id: dfbtrp.F,v 1.2 2001/05/25 20:00:04 biedron Exp $
c
c***********************************************************************
c     Purpose:  Perform the back substitution for a periodic scalar
c     tridiagonal system of equations.
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      dimension a(nvmax,nmax),b(nvmax,nmax),c(nvmax,nmax)
      dimension g(nvmax,nmax),h(nvmax,nmax),f(nvmax,nmax)
c
c      periodic solver  5-3-85
c
c      inversion of block tridiagonal...a,b,c are scalars
c      f is forcing function and solution is output in f
c      solution is by upper triangularization with unity diagonal
c      block inversions use nonpivoted lu decomposition
c      il and iu are starting and finishing indices
c      b,c,and e are overloaded
c
      il1 = il+1
      is  = il
c
c      f=binv*f
c
cdir$ ivdep
      do 1000 izz=1,n
      f(izz,is) = b(izz,is)*(f(izz,is))
 1000 continue
c
c      forward sweep
c
      iux = iu
      iux = iu-1
      do 9100 is=il1,iux
      ir  = is-1
      it  = is+1
c      first row reduction
cdir$ ivdep
      do 1001 izz=1,n
      f(izz,is) = b(izz,is)*(f(izz,is)-a(izz,is)*f(izz,ir)) 
c
c      f=binv*f
c
 1001 continue
 9100 continue
      is = iu
      ir = is-1
      it = is+1
c      first row reduction
cdir$ ivdep
      do 1002 izz=1,n
      f(izz,is) = f(izz,is)-a(izz,is)*f(izz,ir)
 1002 continue
 9121 continue
      iu2 = iu-2
      do 9101 ix=il,iu2
cdir$ ivdep
      do 1003 izz=1,n
      f(izz,is) = f(izz,is)-h(izz,ix)*f(izz,ix)
 1003 continue
 9101 continue
c
c      f=binv*f
c
cdir$ ivdep
      do 1004 izz=1,n
      f(izz,is) = b(izz,is)*(f(izz,is))
 1004 continue
c
c      back substitution
c
      iux = iu
      iux = il1
      do 9179 ii=il1,iux
      is  = il+iu-ii
      it  = is+1
cdir$ ivdep
      do 1005 izz=1,n
      f(izz,is) = f(izz,is)-c(izz,is)*f(izz,it)
 1005 continue
 9179 continue
      il11 = il1+1
      do 9180 ii=il11,iu
      is   = il+iu-ii
      it   = is+1
cdir$ ivdep
      do 1006 izz=1,n
      f(izz,is) = f(izz,is)-c(izz,is)*f(izz,it)-g(izz,is)*f(izz,iu)
 1006 continue
 9180 continue
      return
      end
