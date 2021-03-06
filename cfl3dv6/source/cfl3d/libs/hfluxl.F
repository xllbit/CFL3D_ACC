      subroutine hfluxl(i,npl,xkap,idf,jdim,kdim,idim,res,q,qk0,sk,
     .                  dhp,dhm,t,nvtq)
      use fvfds_x
c
c     $Id: hfluxl.F,v 1.2 2001/05/25 20:00:06 biedron Exp $
c
c***********************************************************************
c     Purpose:  Compute the left-hand flux contributions due to the 
c     inviscid terms for the K-direction.
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      dimension sk(jdim*kdim,idim-1,5)
      dimension q(jdim,kdim,idim,5),qk0(jdim,idim-1,5,4)
      dimension res(jdim,kdim,idim-1,5),t(nvtq,39)
      dimension dhp((jdim-1)*npl*kdim,5,5),dhm((jdim-1)*npl*kdim,5,5)
c
c      common /fvfds/ rkap0(3),ifds(3)
c
c     h-flux-p-m jacobians
c
      jdim1 = jdim-1
      kdim1 = kdim-1
      jv    = jdim1*npl
      js    = jv+1
c
      do 8008 ipl=1,npl
      ii = i+ipl-1
      do 8008 l=1,5
      do 8008 j=1,jdim
      q(j,kdim,ii,l) = qk0(j,ii,l,3)
 8008 continue
c
      do 8000 k=1,kdim
      jkv  = (k-1)*jdim1*npl + 1
      jk   = (k-1)*jdim + 1
      do 8000 ipl=1,npl
      jkv1 = jkv + (ipl-1)*jdim1
      ii   = i+ipl-1
      do 9000 l=1,4
cdir$ ivdep
      do 1000 izz=1,jdim1
      t(izz+jkv1-1,35+l) = sk(izz+jk-1,ii,l)
 1000 continue
 9000 continue
cdir$ ivdep
      do 1001 izz=1,jdim1
      t(izz+jkv1-1,20) = sk(izz+jk-1,ii,5)
 1001 continue
 8000 continue
c
      n = npl*jdim1*kdim
c
      do 40 k=1,kdim
      jkv  = (k-1)*jdim1*npl + 1
      do 40 ipl=1,npl
      ii   = i+ipl-1
      jkv1 = jkv + (ipl-1)*jdim1
      do 40 l=1,5
      if (k.gt.1) then
cdir$ ivdep
         do 1002 izz=1,jdim1
         t(izz+jkv1-1,20+l) = q(izz,k-1,ii,l)
 1002    continue
      else
cdir$ ivdep
         do 1003 izz=1,jdim1
         t(izz+jkv1-1,20+l) = qk0(izz,ii,l,1)
 1003    continue
      end if
cdir$ ivdep
      do 1004 izz=1,jdim1
      t(izz+jkv1-1,25+l) = q(izz,k,ii,l)
 1004 continue
   40 continue
c
      if (ifds(3).eq.0) then
         call dfluxpm(t(1,1), t(1,2), t(1,36),t(1,37),t(1,38),t(1,39),
     .                t(1,20),t(1,21),dhp,n,n,nvtq,+1)
      else
         call dfhat(t(1,36),t(1,37),t(1,38),t(1,39),t(1,20),t(1,21),dhp,
     .              n,nvtq,+1)
      end if
c
      if (ifds(3).eq.0) then
         call dfluxpm(t(1,1), t(1,2), t(1,36),t(1,37),t(1,38),t(1,39),
     .                t(1,20),t(1,26),dhm,n,n,nvtq,-1)
      else
         call dfhat(t(1,36),t(1,37),t(1,38),t(1,39),t(1,20),t(1,26),dhm,
     .              n,nvtq,-1)
      end if
      return
      end
