      subroutine cblki(nbli,idimr,jdimr,kdimr,idimt,jdimt,kdimt,limblk,
     .                 isva,it,ir,iedge,xr,yr,zr,xt,yt,zt,ntime,lcnt,
     .                 geom_miss,mxbli)
c
c     $Id: cblki.F,v 1.2 2001/05/25 20:00:02 biedron Exp $
c
c***********************************************************************
c      Purpose: Check information transferred from block (ir) to
c      qi0 array of block (it).
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      dimension geom_miss(2*mxbli)
      dimension limblk(2,6),isva(2,2)
      dimension xr(jdimr,kdimr,idimr),xt(jdimt,kdimt,idimt),
     .          yr(jdimr,kdimr,idimr),yt(jdimt,kdimt,idimt),
     .          zr(jdimr,kdimr,idimr),zt(jdimt,kdimt,idimt)
c
      jst = limblk(it,2)
      jet = limblk(it,5)
      if (jst .eq. jet) then
         jinct = 1
      else
         jinct = (jet-jst)/abs(jet-jst)
      end if
c
      kst = limblk(it,3)
      ket = limblk(it,6)
      if (kst .eq. ket) then
         kinct = 1
      else
         kinct = (ket-kst)/abs(ket-kst)
      end if
c
      n1  = (jet-jst)/jinct + 1
      n2  = (ket-kst)/kinct + 1
      eps = 0.
      itn = 1
      if (iedge.eq.2) itn = idimt
c
      isr = limblk(ir,1)
      ier = limblk(ir,4)
      jsr = limblk(ir,2)
      jer = limblk(ir,5)
      ksr = limblk(ir,3)
      ker = limblk(ir,6)
c 
c     determine the side of the q array to transfer from
c
c     k = constant side
c
      if (isva(ir,1)+isva(ir,2) .eq. 3) then
      if (ksr.eq.1) then
         kloc1r = 1
         kloc2r = 2
      else
         kloc1r = kdimr-1
         kloc2r = kdimr-2
      end if
c
      if (kdimr.eq.2) then
         kloc1r = 1
         kloc2r = 1
      end if
c
      if (jer .eq. jsr) then
         jincr = 1
      else
         jincr = (jer-jsr)/abs(jer-jsr)
      end if
c
      if (ier .eq. isr) then
         iincr = 1
      else
         iincr = (ier-isr)/abs(ier-isr)
      end if
c
      kr = kloc1r
      if (kr.gt.1) kr = kdimr
      if ((isva(ir,1) .eq. isva(it,1)) .or. 
     .    (isva(ir,2) .eq. isva(it,2))) then
c
c     i varies with k     and     j varies with j
c
      icount = -1
      do 200 k=kst,ket,kinct
      icount = icount + 1
      jcount = -1
      do 100 j=jst,jet,jinct
      jcount = jcount + 1
      ilocr  = isr + iincr*icount
      jlocr  = jsr + jincr*jcount
      xr1    = .25*( xr(jlocr  ,kr,ilocr) + xr(jlocr  ,kr,ilocr+1)
     .            +  xr(jlocr+1,kr,ilocr) + xr(jlocr+1,kr,ilocr+1) )
      yr1    = .25*( yr(jlocr  ,kr,ilocr) + yr(jlocr  ,kr,ilocr+1)
     .            +  yr(jlocr+1,kr,ilocr) + yr(jlocr+1,kr,ilocr+1) )
      zr1    = .25*( zr(jlocr  ,kr,ilocr) + zr(jlocr  ,kr,ilocr+1)
     .            +  zr(jlocr+1,kr,ilocr) + zr(jlocr+1,kr,ilocr+1) )
      xt1    = .25*( xt(j  ,k,itn) + xt(j,  k+1,itn)
     .            +  xt(j+1,k,itn) + xt(j+1,k+1,itn) )
      yt1    = .25*( yt(j  ,k,itn) + yt(j,  k+1,itn)
     .            +  yt(j+1,k,itn) + yt(j+1,k+1,itn) )
      zt1    = .25*( zt(j  ,k,itn) + zt(j,  k+1,itn)
     .            +  zt(j+1,k,itn) + zt(j+1,k+1,itn) )
      eps = ccmax(eps,sqrt((xr1-xt1)**2+(yr1-yt1)**2+(zr1-zt1)**2))
  100 continue
  200 continue
      if (ntime.eq.1) then
         geom_miss(lcnt) = eps
      else
         geom_miss(lcnt) = 0.
      end if
c
      else
c
c     j varies with k     and     i varies with j
c
      jcount = -1
      do 500 k=kst,ket,kinct
      jcount = jcount + 1
      icount = -1
      do 400 j=jst,jet,jinct
      icount = icount + 1
      ilocr  = isr + iincr*icount
      jlocr  = jsr + jincr*jcount
      xr1    = .25*( xr(jlocr  ,kr,ilocr) + xr(jlocr  ,kr,ilocr+1)
     .            +  xr(jlocr+1,kr,ilocr) + xr(jlocr+1,kr,ilocr+1) )
      yr1    = .25*( yr(jlocr  ,kr,ilocr) + yr(jlocr  ,kr,ilocr+1)
     .            +  yr(jlocr+1,kr,ilocr) + yr(jlocr+1,kr,ilocr+1) )
      zr1    = .25*( zr(jlocr  ,kr,ilocr) + zr(jlocr  ,kr,ilocr+1)
     .            +  zr(jlocr+1,kr,ilocr) + zr(jlocr+1,kr,ilocr+1) )
      xt1    = .25*( xt(j  ,k,itn) + xt(j,  k+1,itn)
     .            +  xt(j+1,k,itn) + xt(j+1,k+1,itn) )
      yt1    = .25*( yt(j  ,k,itn) + yt(j,  k+1,itn)
     .            +  yt(j+1,k,itn) + yt(j+1,k+1,itn) )
      zt1    = .25*( zt(j  ,k,itn) + zt(j,  k+1,itn)
     .            +  zt(j+1,k,itn) + zt(j+1,k+1,itn) )
      eps = ccmax(eps,sqrt((xr1-xt1)**2+(yr1-yt1)**2+(zr1-zt1)**2))
  400 continue
  500 continue
      if (ntime.eq.1) then
         geom_miss(lcnt) = eps
      else
         geom_miss(lcnt) = 0.
      end if
c
      end if
c  
c     j = constant side
c
      else if (isva(ir,1)+isva(ir,2) .eq. 4) then
      if (jsr.eq.1) then
         jloc1r = 1
         jloc2r = 2
      else
         jloc1r = jdimr-1
         jloc2r = jdimr-2
      end if
c
      if (jdimr.eq.2) then
         jloc1r = 1
         jloc2r = 1
      end if
c
      if (ier .eq. isr) then
         iincr = 1
      else
         iincr = (ier-isr)/abs(ier-isr)
      end if
c
      if (ker .eq. ksr) then
         kincr = 1
      else
         kincr = (ker-ksr)/abs(ker-ksr)
      end if
c
      jr = jloc1r
      if (jr.gt.1) jr = jdimr
      if ((isva(ir,1) .eq. isva(it,1)) .or. 
     .    (isva(ir,2) .eq. isva(it,2))) then
c
c     i varies with j    and    k varies with k
c
      kcount = -1
      do 800 k=kst,ket,kinct
      kcount = kcount + 1
      icount = -1
      do 700 j=jst,jet,jinct
      icount = icount + 1
      ilocr  = isr + iincr*icount
      klocr  = ksr + kincr*kcount
      xr1    = .25*( xr(jr,klocr  ,ilocr) + xr(jr,klocr  ,ilocr+1)
     .            +  xr(jr,klocr+1,ilocr) + xr(jr,klocr+1,ilocr+1) )
      yr1    = .25*( yr(jr,klocr  ,ilocr) + yr(jr,klocr  ,ilocr+1)
     .            +  yr(jr,klocr+1,ilocr) + yr(jr,klocr+1,ilocr+1) )
      zr1    = .25*( zr(jr,klocr  ,ilocr) + zr(jr,klocr  ,ilocr+1)
     .            +  zr(jr,klocr+1,ilocr) + zr(jr,klocr+1,ilocr+1) )
      xt1    = .25*( xt(j  ,k,itn) + xt(j,  k+1,itn)
     .            +  xt(j+1,k,itn) + xt(j+1,k+1,itn) )
      yt1    = .25*( yt(j  ,k,itn) + yt(j,  k+1,itn)
     .            +  yt(j+1,k,itn) + yt(j+1,k+1,itn) )
      zt1    = .25*( zt(j  ,k,itn) + zt(j,  k+1,itn)
     .            +  zt(j+1,k,itn) + zt(j+1,k+1,itn) )
      eps = ccmax(eps,sqrt((xr1-xt1)**2+(yr1-yt1)**2+(zr1-zt1)**2))
  700 continue
  800 continue
      if (ntime.eq.1) then
         geom_miss(lcnt) = eps
      else
         geom_miss(lcnt) = 0.
      end if
c
      else
c
c     i varies with k    and    k varies with j
c
      icount = -1
      do 1100 k=kst,ket,kinct
      icount = icount + 1
      kcount = -1
      do 1000 j=jst,jet,jinct
      kcount = kcount + 1
      ilocr  = isr + iincr*icount
      klocr  = ksr + kincr*kcount
      xr1    = .25*( xr(jr,klocr  ,ilocr) + xr(jr,klocr  ,ilocr+1)
     .            +  xr(jr,klocr+1,ilocr) + xr(jr,klocr+1,ilocr+1) )
      yr1    = .25*( yr(jr,klocr  ,ilocr) + yr(jr,klocr  ,ilocr+1)
     .            +  yr(jr,klocr+1,ilocr) + yr(jr,klocr+1,ilocr+1) )
      zr1    = .25*( zr(jr,klocr  ,ilocr) + zr(jr,klocr  ,ilocr+1)
     .            +  zr(jr,klocr+1,ilocr) + zr(jr,klocr+1,ilocr+1) )
      xt1    = .25*( xt(j  ,k,itn) + xt(j,  k+1,itn)
     .            +  xt(j+1,k,itn) + xt(j+1,k+1,itn) )
      yt1    = .25*( yt(j  ,k,itn) + yt(j,  k+1,itn)
     .            +  yt(j+1,k,itn) + yt(j+1,k+1,itn) )
      zt1    = .25*( zt(j  ,k,itn) + zt(j,  k+1,itn)
     .            +  zt(j+1,k,itn) + zt(j+1,k+1,itn) )
      eps = ccmax(eps,sqrt((xr1-xt1)**2+(yr1-yt1)**2+(zr1-zt1)**2))
 1000 continue
 1100 continue
      if (ntime.eq.1) then
         geom_miss(lcnt) = eps
      else
         geom_miss(lcnt) = 0.
      end if
c
      end if
c 
c     i = constant side
c
      else if (isva(ir,1)+isva(ir,2) .eq. 5) then
      if (isr.eq.1) then
         iloc1r = 1
         iloc2r = 2
      else
         iloc1r = idimr-1
         iloc2r = idimr-2
      end if
c
      if (idimr.eq.2) then
         iloc1r = 1
         iloc2r = 1
      end if
c
      if (jer .eq. jsr) then
         jincr = 1
      else
         jincr = (jer-jsr)/abs(jer-jsr)
      end if
c
      if (ker .eq. ksr) then
         kincr = 1
      else
         kincr = (ker-ksr)/abs(ker-ksr)
      end if
c
      irn = iloc1r
      if (irn.gt.1) irn = idimr
      if ((isva(ir,1) .eq. isva(it,1)) .or. 
     .    (isva(ir,2) .eq. isva(it,2))) then
c
c     k varies with k    and    j varies with j
c
      kcount = -1
      do 1400 k=kst,ket,kinct
      kcount = kcount + 1
      jcount = -1
      do 1300 j=jst,jet,jinct
      jcount = jcount + 1
      jlocr  = jsr + jincr*jcount
      klocr  = ksr + kincr*kcount
      xr1    = .25*( xr(jlocr  ,klocr,irn) + xr(jlocr  ,klocr+1,irn)
     .            +  xr(jlocr+1,klocr,irn) + xr(jlocr+1,klocr+1,irn) )
      yr1    = .25*( yr(jlocr  ,klocr,irn) + yr(jlocr  ,klocr+1,irn)
     .            +  yr(jlocr+1,klocr,irn) + yr(jlocr+1,klocr+1,irn) )
      zr1    = .25*( zr(jlocr  ,klocr,irn) + zr(jlocr  ,klocr+1,irn)
     .            +  zr(jlocr+1,klocr,irn) + zr(jlocr+1,klocr+1,irn) )
      xt1    = .25*( xt(j  ,k,itn) + xt(j,  k+1,itn)
     .            +  xt(j+1,k,itn) + xt(j+1,k+1,itn) )
      yt1    = .25*( yt(j  ,k,itn) + yt(j,  k+1,itn)
     .            +  yt(j+1,k,itn) + yt(j+1,k+1,itn) )
      zt1    = .25*( zt(j  ,k,itn) + zt(j,  k+1,itn)
     .            +  zt(j+1,k,itn) + zt(j+1,k+1,itn) )
      eps = ccmax(eps,sqrt((xr1-xt1)**2+(yr1-yt1)**2+(zr1-zt1)**2))
 1300 continue
 1400 continue
      if (ntime.eq.1) then
         geom_miss(lcnt) = eps
      else
         geom_miss(lcnt) = 0.
      end if
c
      else
c
c     j varies with k    and    k varies with j
c
      jcount = -1
      do 1700 k=kst,ket,kinct
      jcount = jcount + 1
      kcount = -1
      do 1600 j=jst,jet,jinct
      kcount = kcount + 1
      jlocr  = jsr + jincr*jcount
      klocr  = ksr + kincr*kcount
      xr1    = .25*( xr(jlocr  ,klocr,irn) + xr(jlocr  ,klocr+1,irn)
     .            +  xr(jlocr+1,klocr,irn) + xr(jlocr+1,klocr+1,irn) )
      yr1    = .25*( yr(jlocr  ,klocr,irn) + yr(jlocr  ,klocr+1,irn)
     .            +  yr(jlocr+1,klocr,irn) + yr(jlocr+1,klocr+1,irn) )
      zr1    = .25*( zr(jlocr  ,klocr,irn) + zr(jlocr  ,klocr+1,irn)
     .            +  zr(jlocr+1,klocr,irn) + zr(jlocr+1,klocr+1,irn) )
      xt1    = .25*( xt(j  ,k,itn) + xt(j,  k+1,itn)
     .            +  xt(j+1,k,itn) + xt(j+1,k+1,itn) )
      yt1    = .25*( yt(j  ,k,itn) + yt(j,  k+1,itn)
     .            +  yt(j+1,k,itn) + yt(j+1,k+1,itn) )
      zt1    = .25*( zt(j  ,k,itn) + zt(j,  k+1,itn)
     .            +  zt(j+1,k,itn) + zt(j+1,k+1,itn) )
      eps = ccmax(eps,sqrt((xr1-xt1)**2+(yr1-yt1)**2+(zr1-zt1)**2))
 1600 continue
 1700 continue
      if (ntime.eq.1) then
         geom_miss(lcnt) = eps
      else
         geom_miss(lcnt) = 0.
      end if
c
      end if
      end if
      return
      end
