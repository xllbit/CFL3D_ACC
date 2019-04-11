      subroutine prolim(n,x1,x2,xc,leq)
      use fluid_x
      use info_x
      use ivals_x
!!$acc routine seq
!!$acc routine(ccmax,ccmin) seq      
c
c     $Id: prolim.F,v 1.2 2001/05/25 20:00:07 biedron Exp $
c
c***********************************************************************
c     Purpose: to limit static pressure and static density to be less
c              than or equal to the stagnation value, and greater than
c              or equal to a minimum value set via the data statement.
c              For points that have the pressure/density so limited,
c              the difference stencil is also make locally first order
c              accurate.
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      dimension x1(n),x2(n),xc(n)
c
c      common /fluid/ gamma,gm1,gp1,gm1g,gp1g,ggm1
c      common /info/ title(20),rkap(3),xmach,alpha,beta,dt,fmax,nit,ntt,
c     .        idiag(3),nitfo,iflagts,iflim(3),nres,levelb(5),mgflag,
c     .        iconsf,mseq,ncyc1(5),levelt(5),nitfo1(5),ngam,nsm(5),iipv
c      common /ivals/ p0,rho0,c0,u0,v0,w0,et0,h0,pt0,rhot0,qiv(5),
c     .        tur10,tur20
c
      data pmin,rhomin /0.1,0.1/
c
      if (leq.eq.1) then
         do 100 izz = 1,n
         xc(izz) = ccmax(xc(izz),rhomin)
         xc(izz) = ccmin(xc(izz),rhot0 )
         if (real(xc(izz)-rhomin)*real(xc(izz)-rhot0).eq.0.) then
            x1(izz) = 0.
            x2(izz) = 0.
c           write(6,*)'in PROLIM: rho,izz = ',real(xc(izz)),izz
         end if
100      continue
      else if (leq.eq.5) then
         do 200 izz = 1,n
         xc(izz) = ccmax(xc(izz),pmin)
         xc(izz) = ccmin(xc(izz),pt0 )
         if (real(xc(izz)-pmin)*real(xc(izz)-pt0).eq.0.) then
            x1(izz) = 0.
            x2(izz) = 0.
c           write(6,*)'in PROLIM: p,izz = ',real(xc(izz)),izz
         end if
200      continue
      end if
c
      return
      end
