      subroutine af3f(nbl,jdim,kdim,idim,q,vol,qj0,qk0,qi0,dtj,sj,sk,si,
     .                res,vist3d,x,y,z,blank,vmuk,resid,wk,nwork,wk0,
     .                nwk0,iover,vk0,bcj,bck,bci,nou,bou,nbuf,ibufdim,
     .                myid,mblk2nd,maxbl,volk0,iadvance)
      use fvfds_x
      use info_x
      use mgrd_x
      use reyue_x
      use sklton_x
      use twod_x
      use unst_x
c
c     $Id: af3f.F,v 1.2 2001/05/25 20:00:00 biedron Exp $
c
c***********************************************************************
c     Purpose:  Advance the solution in time using a 3-factor
c     spatially-split approximate factorization algorithm.
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      character*120 bou(ibufdim,nbuf)
c
      dimension nou(nbuf)
      dimension x(jdim,kdim,idim),y(jdim,kdim,idim),z(jdim,kdim,idim)
      dimension res(jdim*kdim*(idim-1),5),vmuk(jdim-1,idim-1,2)
      dimension wk0(nwk0),wk(nwork)
      dimension q(jdim*kdim*idim,5),   qj0(kdim*(idim-1),5,4),
     .          qk0(jdim*(idim-1),5,4),qi0(jdim*kdim,5,4)
      dimension si(jdim*kdim*idim,5),sj(jdim*kdim*(idim-1),5),
     .          sk(jdim*kdim*(idim-1),5)
      dimension vol(jdim*kdim*(idim-1)),dtj(jdim*kdim*(idim-1)),
     .          vist3d(jdim,kdim,idim),blank(jdim,kdim,idim),
     .          vk0(jdim,idim-1,1,4)
      dimension bcj(kdim,idim-1,2),bck(jdim,idim-1,2),bci(jdim,kdim,2)
      dimension mblk2nd(maxbl),volk0(jdim,idim-1,4)
      dimension iadvance(nbl)
c
c      common /fvfds/ rkap0(3),ifds(3)
c      common /info/ title(20),rkap(3),xmach,alpha,beta,dt,fmax,nit,ntt,
c     .        idiag(3),nitfo,iflagts,iflim(3),nres,levelb(5),mgflag,
c     .        iconsf,mseq,ncyc1(5),levelt(5),nitfo1(5),ngam,nsm(5),iipv
c      common /mgrd/ levt,kode,mode,ncyc,mtt,icyc,level,lglobal
c      common /reyue/ reue,tinf,ivisc(3)
c      common /sklton/ isklton
c      common /twod/ i2d
c      common /unst/ time,cfltau,ntstep,ita,iunst
c
      jdim1 = jdim-1
      kdim1 = kdim-1
      idim1 = idim-1
c
      if (isklton.gt.0) then
        if (abs(ita).eq.2) then
           nou(1) = min(nou(1)+1,ibufdim)
           write(bou(nou(1),1),1011) 
        else
           nou(1) = min(nou(1)+1,ibufdim)
           write(bou(nou(1),1),1012)
        end if
      end if
 1011 format(3x,36husing second order time differencing)
 1012 format(3x,35husing first order time differencing)
c
c****************** spatially-split af ***********************
c
c      idiag(l)=1  diagonal inversion for l direction
c      idiag(l)=0  block inversion
c
cc     implicit   J direction
c
      imult = 1
      if (ifds(2).eq.0.or.idiag(2).eq.0) then
      if (isklton.gt.0) nou(1) = min(nou(1)+1,ibufdim)
      if (isklton.gt.0) write(bou(nou(1),1),*)
     .               '   5x5 block inversion in J-direction'
      nvtq = min(999000,nwork/145)
      n    = jdim*kdim
      nplq = min(idim1,nvtq/n)
      if (imult.eq.0) nplq = 1
      npl = nplq
      if (npl.lt.1) then
         nou(1) = min(nou(1)+1,ibufdim)
         write(bou(nou(1),1),8989)
         call termn8(myid,-1,ibufdim,nbuf,bou,nou)
      end if
 8989 format(39h insufficient memory - stopping in af3f)
      iperd = 0
      do 250 i=1,idim1,nplq
      if( i+npl-1.gt.idim1) npl = idim1-i+1
c
      nvtq = npl*jdim*kdim 
      iwka = nvtq*20+1
      iwkb = nvtq*45+1
      iwkc = nvtq*70+1
      iwkd = nvtq*95+1
      iwke = nvtq*120+1
c
      call gfluxl(i,npl,rkap(2),1,jdim,kdim,idim,res,q,qj0,sj,wk(iwkd),
     .            wk(iwke),wk,nvtq)
c
      call amafj(i,npl,jdim,kdim,idim,q,wk(iwka),wk(iwkb),wk(iwkc),dtj,
     .           wk,nvtq,wk(iwkd),wk(iwke))
c
      if (iover.eq.1)
     .call abcjz(i,npl,jdim,kdim,idim,wk(iwka),wk(iwkb),wk(iwkc),blank)
c
      nvmax = npl*kdim1
      if (iperd.eq.0) then
         call vlutr(nvmax,nvmax,jdim,1,jdim1,wk(iwka),wk(iwkb),wk(iwkc),
     .              nou,bou,nbuf,ibufdim)
      else
         if (isklton.eq.1) nou(1) = min(nou(1)+1,ibufdim)
         if (isklton.eq.1) write(bou(nou(1),1),702)
         call vlutrp(nvmax,nvmax,jdim,1,jdim1,wk(iwka),wk(iwkb),
     .               wk(iwkc),wk(iwkd),wk(iwke))
      end if
  702 format(' periodic matrix equation in J-direction')
c     
      call swafj(i,npl,jdim,kdim,idim,wk(iwka),wk(iwkb),wk(iwkc),
     .           wk,nvtq,res,iperd,wk(iwkd),wk(iwke))
  250 continue
c
      else
c
      if (isklton.gt.0) nou(1) = min(nou(1)+1,ibufdim)
      if (isklton.gt.0) write(bou(nou(1),1),
     .   '(''   diagonal inversion in J-direction'')')
      nvtq = min(999000,nwork/35)
      n    = jdim*kdim
      nplq = min(idim1,nvtq/n)
      if (imult.eq.0) nplq = 1
      npl  = nplq
      if (npl.lt.1) then
         nou(1) = min(nou(1)+1,ibufdim)
         write(bou(nou(1),1),8989)
         call termn8(myid,-1,ibufdim,nbuf,bou,nou)
      end if
      iperd = 0
      if (isklton.gt.0 .and. iperd.eq.1) nou(1) = min(nou(1)+1,ibufdim)
      if (isklton.gt.0 .and. iperd.eq.1)
     . write(bou(nou(1),1),*)'  periodic matrix equation in J-direction'
      do 251 i=1,idim1,nplq
      if (i+npl-1.gt.idim1) npl = idim1-i+1
      call diagj(i,npl,jdim,kdim,idim,q,res,dtj,sj,wk,iperd,vol,
     .           vist3d,blank,iover)
  251 continue
      end if
c
c      l2-norm of delta q
c
      if (icyc.le.2 .or. icyc.eq.ncyc)
     .call l2norm(nbl,icyc,resid,1,jdim,kdim,idim,res,vol)
c
cc     implicit   K direction
c
      if (ifds(3).eq.0.or.idiag(3).eq.0) then
      if (isklton.gt.0) nou(1) = min(nou(1)+1,ibufdim)
      if (isklton.gt.0) write(bou(nou(1),1),*)
     .               '   5x5 block inversion in K-direction'
      nvtq = min(999000,nwork/145)
      n    = jdim*kdim
      nplq = min(idim1,nvtq/n)
      if (imult.eq.0) nplq = 1
      npl  = nplq
      if (npl.lt.1) then
         nou(1) = min(nou(1)+1,ibufdim)
         write(bou(nou(1),1),8989)
         call termn8(myid,-1,ibufdim,nbuf,bou,nou)
      end if
      jz   = npl*jdim
      do 260 il=1,idim1,nplq
      if (il+npl-1.gt.idim1) npl = idim1-il+1
      i    = idim1-il-npl+2
c
      nvtq = npl*jdim*kdim
      iwka = nvtq*20+1
      iwkb = nvtq*45+1
      iwkc = nvtq*70+1
      iwkd = nvtq*95+1
      iwke = nvtq*120+1
c
      call hfluxl(i,npl,rkap(3),1,jdim,kdim,idim,res,q,qk0,sk,wk(iwkd),
     .            wk(iwke),wk,nvtq)
c
      call amafk(i,npl,jdim,kdim,idim,q,wk(iwka),wk(iwkb),wk(iwkc),dtj,
     .           wk,nvtq,wk(iwkd),wk(iwke))
c
      if (ivisc(3).gt.0) then
c        Call viscous LHS.  Last 3 parameters currently not used when 
c        implicit (idf=1), so just send dummy variables (wk(iwke)).
         call hfluxv(i,npl,jdim,kdim,idim,1,wk(iwka),wk(iwkb),wk(iwkc),
     .               res,q,qk0,sk,vol,wk(iwkd),nvtq,wk0,vist3d,vmuk,
     .               vk0,bck,wk(iwke),wk(iwke),wk(iwke),
     .               volk0,nou,bou,nbuf,ibufdim,iadvance(nbl))
      end if
c
      if (iover.eq.1) call abckz(i,npl,jdim,kdim,idim,wk(iwka),wk(iwkb),
     .                           wk(iwkc),blank)
c
      imw = 0 
      nvmax = npl*(jdim-1)/(imw+1)
      nrec  = kdim1*(imw+1)
      call vlutr(nvmax,nvmax,nrec,1,nrec,wk(iwka),wk(iwkb),wk(iwkc),
     .           nou,bou,nbuf,ibufdim)
      call swafk(i,npl,jdim,kdim,idim,q,wk(iwka),wk(iwkb),wk(iwkc),
     .           dtj,wk,nvtq,res,imw)
  260 continue
c
      else
c
      if (isklton.gt.0) nou(1) = min(nou(1)+1,ibufdim)
      if (isklton.gt.0) write(bou(nou(1),1),
     .   '(''   diagonal inversion in K-direction'')')
      nvtq = min(999000,nwork/35)
      n    = jdim*kdim
      nplq = min(idim1,nvtq/n)
      if (imult.eq.0) nplq = 1
      npl  = nplq
      if (npl.lt.1) then
         nou(1) = min(nou(1)+1,ibufdim)
         write(bou(nou(1),1),8989)
         call termn8(myid,-1,ibufdim,nbuf,bou,nou)
      end if
      do 261 i=1,idim1,nplq
      if (i+npl-1.gt.idim1) npl = idim1-i+1
      call diagk(i,npl,jdim,kdim,idim,q,res,dtj,sk,wk,vol,vist3d,
     .           blank,iover)
  261 continue
      end if
c
c      l2-norm of delta q
c
      if (icyc.le.2 .or. icyc.eq.ncyc)
     .call l2norm(nbl,icyc,resid,1,jdim,kdim,idim,res,vol)
c
cc     implicit in I direction
c
      if (i2d.ne.1) then
      if (ifds(1).eq.0.or.idiag(1).eq.0) then
      if (isklton.gt.0) nou(1) = min(nou(1)+1,ibufdim)
      if (isklton.gt.0) write(bou(nou(1),1),*)
     .          '   5x5 block inversion in I-direction'
      n    = jdim*idim
      nvtq = min(999000,nwork/145)
      nplq = min(kdim1,nvtq/n)
      if (imult.eq.0) nplq = 1
      npl  = nplq
      if (npl.lt.1) then
         nou(1) = min(nou(1)+1,ibufdim)
         write(bou(nou(1),1),8989)
         call termn8(myid,-1,ibufdim,nbuf,bou,nou)
      end if
      do 350 k=1,kdim1,nplq
      if (k+npl-1.gt.kdim1) npl = kdim1-k+1
c
      nvtq = npl*jdim*idim 
      iwka = nvtq*20+1
      iwkb = nvtq*45+1
      iwkc = nvtq*70+1
      iwkd = nvtq*95+1
      iwke = nvtq*120+1
      call ffluxl(k,npl,rkap(1),1,jdim,kdim,idim,res,q,qi0,si,wk(iwkd),
     .            wk(iwke),wk,nvtq)
c
      imw = 0
      call amafi(k,npl,jdim,kdim,idim,q,wk(iwka),wk(iwkb),wk(iwkc),dtj,
     .           wk,nvtq,wk(iwkd),wk(iwke),imw)
c
      if (iover.eq.1)
     .call abciz(k,npl,jdim,kdim,idim,wk(iwka),wk(iwkb),wk(iwkc),blank)
c
      nvmax = npl*(jdim-1)/(imw+1)
      nrec  = idim1*(imw+1)
      call vlutr(nvmax,nvmax,nrec,1,nrec,wk(iwka),wk(iwkb),wk(iwkc),
     .           nou,bou,nbuf,ibufdim)
c
      call swafi(k,npl,jdim,kdim,idim,q,wk(iwka),wk(iwkb),wk(iwkc),dtj,
     .           wk,nvtq,res,imw)
  350 continue
c
      else
c
      if (isklton.gt.0) nou(1) = min(nou(1)+1,ibufdim)
      if (isklton.gt.0) write(bou(nou(1),1),
     .   '(''   diagonal inversion in I-direction'')')
      n    = jdim*idim
      nvtq = min(999000,nwork/35)
      nplq = min(kdim1,nvtq/n)
      if (imult.eq.0) nplq = 1
      npl  = nplq
      if (npl.lt.1) then
         nou(1) = min(nou(1)+1,ibufdim)
         write(bou(nou(1),1),8989)
         call termn8(myid,-1,ibufdim,nbuf,bou,nou)
      end if
      do 351 k=1,kdim1,nplq
      if (k+npl-1.gt.kdim1) npl = kdim1-k+1
      call diagi(k,npl,jdim,kdim,idim,q,res,dtj,si,wk,vol,vist3d,
     .           blank,iover)
  351 continue
      end if
c
c      l2-norm of delta q
c
      if (icyc.le.2 .or. icyc.eq.ncyc)
     .call l2norm(nbl,icyc,resid,1,jdim,kdim,idim,res,vol)
      end if
c
c****************** spatially-split af ***********************
c
      return
      end
