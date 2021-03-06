      subroutine i2xsk_d(jc,kc,ic,qc,jf,kf,if,qkf,js,ks,is,
     .                   je,ke,ie,nblc,ldim,nbl,bckf,nface)
c
c     $Id: i2xsk_d.F,v 1.2 2001/05/25 20:00:06 biedron Exp $
c
c***********************************************************************
c     Purpose:  Interpolate primative variables from coarser
c     meshes onto twice finer meshes, for k=constant surfaces.
c     This version of i2x requires only a 3-plane subset of the
c     full qc array to be stored.
c***********************************************************************
c
c      interpolate from coarser mesh onto twice finer mesh
c      planes of constant k-index
c
c      jc,kc,ic    : dimension of coarser mesh (kc is unused)
c      qc          : 3-plane subset of q-array coarser mesh
c      jf,kf,if    : dimension of finer mesh
c      qkf         : q-array for interpolated points of finer mesh
c      js,ks,is    : starting indices of coarser mesh grid points
c                    defining boundary of finer mesh (ks is unused)
c      je,ke,ie    : ending indices of coarser mesh grid points
c                    defining boundary of finer mesh (ke is unused)
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      dimension qc(jc,3,ic,ldim)
      dimension qkf(jf,if-1,ldim,4)
      dimension bckf(jf,if-1,2)
      dimension q(3)
c
      jem = je-1
      iem = ie-1
c
      f1  = .75
      f2  = .25
c
c     k = constant planes
c
      if (nface.eq.5) then
c
c     interpolate left boundary
c
         do 200 l=1,ldim
         ii = 0
         do 200 i=is,iem
         ii = ii+1
         do 200 j=js,jem
         do 200 jl=1,2
         jj = (j-js)*2+jl
         j2 = max(j-1+(jl-1)*2,1)
         j2 = min(jc-1,j2)
         do 201 k=1,3
         q(k) = f1*qc(j,k,i,l)+f2*qc(j2,k,i,l)
  201    continue
         qkf(jj,ii,l,1) = .25*q(1)+.75*q(2)
         qkf(jj,ii,l,2) = .75*q(2)+.25*q(3)
         bckf(jj,ii,1) = 0.0
  200    continue
      end if
c
      if (nface.eq.6) then
c
c     interpolate right boundary
c
         do 210 l=1,ldim
         ii = 0
         do 210 i=is,iem
         ii = ii+1
         do 210 j=js,jem
         do 210 jl=1,2
         jj = (j-js)*2+jl
         j2 = max(j-1+(jl-1)*2,1)
         j2 = min(jc-1,j2)
         do 211 k=1,3
         q(k) = f1*qc(j,k,i,l)+f2*qc(j2,k,i,l)
  211    continue
         qkf(jj,ii,l,3) = .25*q(1)+.75*q(2)
         qkf(jj,ii,l,4) = .75*q(2)+.25*q(3)
         bckf(jj,ii,2) = 0.0
  210    continue
      end if
c
c     **for safety**
c
      do 30 m=1,4
      do 30 l=1,ldim
      do 10 i=1,if-1
      qkf(jf,i,l,m) = qkf(jf-1,i,l,m)
   10 continue
   30 continue
c
      return
      end
