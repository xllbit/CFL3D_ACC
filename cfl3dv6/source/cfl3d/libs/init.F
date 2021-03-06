      subroutine init(nbl,jdim,kdim,idim,q,qj0,qk0,qi0,tj0,tk0,ti0,
     .                vol,volj0,volk0,voli0)
      use fluid_x
      use info_x
      use ivals_x
      use reyue_x
      use maxiv_x
c
c     $Id: init.F,v 1.4 2002/07/30 18:23:24 rumsey Exp $
c
c***********************************************************************
c     Purpose:  Initialize the initial conditions on a mesh to be
c     freestream. Also initialize boundary volume arrays.
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      dimension q(jdim,kdim,idim,5), qi0(jdim,kdim,5,4),
     .          qj0(kdim,idim-1,5,4),qk0(jdim,idim-1,5,4)
      dimension tj0(kdim,idim-1,2,4),tk0(jdim,idim-1,2,4),
     .          ti0(jdim,kdim  ,2,4)
      dimension volj0(kdim,idim-1,4),volk0(jdim,idim-1,4),
     .          voli0(jdim,kdim  ,4),vol(jdim,kdim,idim-1)
c
c      common /fluid/ gamma,gm1,gp1,gm1g,gp1g,ggm1
c      common /info/ title(20),rkap(3),xmach,alpha,beta,dt,fmax,nit,ntt,
c     .        idiag(3),nitfo,iflagts,iflim(3),nres,levelb(5),mgflag,
c     .        iconsf,mseq,ncyc1(5),levelt(5),nitfo1(5),ngam,nsm(5),iipv
c      common /ivals/ p0,rho0,c0,u0,v0,w0,et0,h0,pt0,rhot0,qiv(5),
c     .        tur10,tur20
c      common /reyue/ reue,tinf,ivisc(3)
c      common /maxiv/ ivmx
c
c     write(15,904)nbl
  904 format(29h initial conditions for block,i3)
c
      rho0   = 1.e0
      c0     = 1.e0
      p0     = rho0*c0*c0/gamma
c   The wind axis system follows NASA SP-3070 (1972), with the exception that
c   positive beta is in the opposite direction
      u0     = xmach*cos(alpha)*cos(beta)
      w0     = xmach*sin(alpha)*cos(beta)
      v0     = -xmach*sin(beta)
      ei0    = p0/((gamma-1.e0)*rho0)
      et0    = rho0*(ei0+.5e0*(u0*u0+v0*v0+w0*w0))
      h0     = (et0+p0)/rho0
      pt0    = p0*(1.e0+.5e0*gm1*xmach*xmach)**(gamma/gm1)
      rhot0  = rho0*(1.e0+.5e0*gm1*xmach*xmach)**(1.e0/gm1)
      qiv(1) = rho0
      qiv(2) = u0
      qiv(3) = v0
      qiv(4) = w0
      qiv(5) = p0
c     write(15,499) idim,jdim,kdim
  499 format(/1x,20hinit idim,jdim,kdim=,3i10)
c     write(15,500) real(rho0),real(c0),real(p0),real(u0),real(v0),
c    .real(w0),real(ei0),real(et0),real(h0),real(pt0),real(qiv)
  500 format(1x,37h rho,c,p,u,v,w,ei,e,h,pt(0),qiv(1-5)=/(1x,5e12.5))
      a1    = u0
      a2    = v0
      a3    = w0
      jkpro = jdim*kdim
      idim1 = idim-1
      npl   = 999000/jkpro
      nplq  = npl
c
      do 1010 i=1,idim,nplq
      if (i+npl-1.gt.idim) npl = idim-i+1
      nv = npl*jkpro
cdir$ ivdep
      do 1000 izz=1,nv
      q(izz,1,i,1) = rho0
      q(izz,1,i,2) = a1
      q(izz,1,i,3) = a2
      q(izz,1,i,4) = a3
      q(izz,1,i,5) = p0
 1000 continue
 1010 continue
c
      npl  = 999000/kdim
      nplq = npl
      do 1020 i=1,idim1,nplq
      if (i+npl-1.gt.idim1) npl = idim1-i+1
      nv   = npl*kdim
      do 10 m=1,4
cdir$ ivdep
      do 1001 izz=1,nv
      qj0(izz,i,1,m) = rho0
      qj0(izz,i,2,m) = a1
      qj0(izz,i,3,m) = a2
      qj0(izz,i,4,m) = a3
      qj0(izz,i,5,m) = p0
 1001 continue
   10 continue
 1020 continue
c
      npl  = 999000/kdim
      nplq = npl
      do 1030 i=1,idim1,nplq
      if (i+npl-1.gt.idim1) npl = idim1-i+1
      nv   = jdim*npl
      do 20 m=1,4
cdir$ ivdep
      do 1002 izz=1,nv
      qk0(izz,i,1,m) = rho0
      qk0(izz,i,2,m) = a1
      qk0(izz,i,3,m) = a2
      qk0(izz,i,4,m) = a3
      qk0(izz,i,5,m) = p0
 1002 continue
   20 continue
 1030 continue
c
      do 30 m=1,4
cdir$ ivdep
      do 1003 izz=1,jkpro
      qi0(izz,1,1,m) = rho0
      qi0(izz,1,2,m) = a1
      qi0(izz,1,3,m) = a2
      qi0(izz,1,4,m) = a3
      qi0(izz,1,5,m) = p0
 1003 continue
   30 continue
c   For field eqn turbulence models:
      if (ivisc(1).ge.4 .or. ivisc(2).ge.4 .or. ivisc(3).ge.4) then
        if (ivisc(1).eq.4 .or. ivisc(2).eq.4 .or. ivisc(3).eq.4) then
          if (real(tur10) .lt. 0.) tur10=0.1
          if (real(tur20) .lt. 0.) tur20=0.
        else if (ivisc(1).eq.5 .or. ivisc(2).eq.5 .or.
     .           ivisc(3).eq.5) then
          if (real(tur10) .lt. 0.) tur10=1.341946
          if (real(tur20) .lt. 0.) tur20=0.
        else if (ivisc(1).eq.11 .or. ivisc(2).eq.11 .or.
     .           ivisc(3).eq.11 .or.
     .           ivisc(1).eq.10 .or. ivisc(2).eq.10 .or.
     .           ivisc(3).eq.10 .or.
     .           ivisc(1).eq. 9 .or. ivisc(2).eq. 9 .or.
     .           ivisc(3).eq. 9 .or. ivisc(1).eq.13 .or.
     .           ivisc(2).eq.13 .or. ivisc(3).eq.13) then
          if (real(tur10) .lt. 0.) tur10=1.e-17
          if (real(tur20) .lt. 0.) tur20=1.e-9
        else if (ivisc(1).eq. 8 .or. ivisc(2).eq. 8 .or.
     .           ivisc(3).eq. 8 .or.
     .           ivisc(1).eq.12 .or. ivisc(2).eq.12 .or.
     .           ivisc(3).eq.12 .or.
     .           ivisc(1).eq.14 .or. ivisc(2).eq.14 .or.
     .           ivisc(3).eq.14) then
          if (real(tur10) .lt. 0.) tur10=9.e-8
          if (real(tur20) .lt. 0.) tur20=9.e-9
        else
          if (real(tur10) .lt. 0.) tur10=1.e-6
          if (real(tur20) .lt. 0.) tur20=9.e-9
        end if
        do 4001 m=1,4
          do 4000 i=1,idim-1
            do 3999 j=1,jdim
              tk0(j,i,1,m)=tur10
              tk0(j,i,2,m)=tur20
 3999       continue
            do 3998 k=1,kdim
              tj0(k,i,1,m)=tur10
              tj0(k,i,2,m)=tur20
 3998       continue
 4000     continue
          do 4002 k=1,kdim
            do 4002 j=1,jdim
              ti0(j,k,1,m)=tur10
              ti0(j,k,2,m)=tur20
 4002     continue
 4001   continue
      end if
c
c     boundary volumes (default to interior cells)
c
      if (ivmx.gt.0) then
         do m=1,4
            if (m.eq.1) kk = 1
            if (m.eq.2) kk = min(2,kdim-1)
            if (m.eq.3) kk = kdim-1
            if (m.eq.4) kk = max(1,kdim-2)
            do i=1,idim-1
               do j=1,jdim
                 volk0(j,i,m) = vol(j,kk,i)
               end do
            end do
         end do
         do m=1,4
            if (m.eq.1) jj = 1
            if (m.eq.2) jj = min(2,jdim-1)
            if (m.eq.3) jj = jdim-1
            if (m.eq.4) jj = max(1,jdim-2)
c           the sgi f77 compiler with -O3 won't do the following 
c           assigmnment correctly if the k-loop is innermost
            do k=1,kdim
               do i=1,idim-1
                 volj0(k,i,m) = vol(jj,k,i)
               end do
            end do
         end do
         do m=1,4
            if (m.eq.1) ii = 1
            if (m.eq.2) ii = min(2,idim-1)
            if (m.eq.3) ii = idim-1
            if (m.eq.4) ii = max(1,idim-2)
            do k=1,kdim
               do j=1,jdim
                 voli0(j,k,m) = vol(j,k,ii)
               end do
            end do
         end do
      end if
c
      return
      end
