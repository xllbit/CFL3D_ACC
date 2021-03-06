      subroutine rcfl(x,y,z,jdim,kdim,idim,igrid,ialph,igeom_img,irr)
c
c     $Id: rcfl.F,v 1.4 2002/05/10 13:53:13 rumsey Exp $
c
c***********************************************************************
c     Purpose:  Read grids in cfl3d format.
c     ialph     - flag to interpret angle of attack
c               = 0 alpha measured in x-z plane (cfl3d standard)
c               > 0 alpha measured in x-y plane (tlns3d standard)
c     igeom_img - flag for complex grid file
c               = 0 input grid is real valued
c               > 0 input grid is complex valued
c***********************************************************************
c
#ifdef CMPLX
      implicit complex(a-h,o-z)
c
      integer stats
c
      real, dimension(:,:,:), allocatable :: xr
      real, dimension(:,:,:), allocatable :: yr
      real, dimension(:,:,:), allocatable :: zr
c
#endif
c
      dimension x(jdim,kdim,idim),y(jdim,kdim,idim),z(jdim,kdim,idim)
c
#ifdef CMPLX
c     allocate real arrays in which to read grid data
c     (for non-geometric derivatives)
c
      memuse = 0
      allocate( xr(jdim,kdim,idim), stat=stats )
      call umalloc(jdim*kdim*idim,0,'xr',memuse,stats)
      allocate( yr(jdim,kdim,idim), stat=stats )
      call umalloc(jdim*kdim*idim,0,'yr',memuse,stats)
      allocate( zr(jdim,kdim,idim), stat=stats )
      call umalloc(jdim*kdim*idim,0,'zr',memuse,stats)
#endif
c
      if (ialph.eq.0) then
#ifdef CMPLX
         if (igeom_img .eq. 0) then
c
c           for non-geometric derivatives, input grid is real
c
            read(1,end=999,err=999)
     .              (((xr(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .              (((yr(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .              (((zr(j,k,i),j=1,jdim),k=1,kdim),i=1,idim)
            do i=1,idim
               do j=1,jdim
                  do k=1,kdim
                     x(j,k,i) = xr(j,k,i)
                     y(j,k,i) = yr(j,k,i)
                     z(j,k,i) = zr(j,k,i)
                  end do
               end do
            end do
         else
c
c           for geometric derivatives, input grid is complex
c
            read(1,end=999,err=999) 
     .              (((x(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .              (((y(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .              (((z(j,k,i),j=1,jdim),k=1,kdim),i=1,idim)
         end if
#else
         read(1,end=999,err=999) 
     .           (((x(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .           (((y(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .           (((z(j,k,i),j=1,jdim),k=1,kdim),i=1,idim)
#endif
      else
#ifdef CMPLX
         if (igeom_img .eq. 0) then
c
c           for non-geometric derivatives, input grid is real
c
            read(1,end=999,err=999) 
     .              (((xr(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .              (((zr(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .              (((yr(j,k,i),j=1,jdim),k=1,kdim),i=1,idim)
            do i=1,idim
               do j=1,jdim
                  do k=1,kdim
                     x(j,k,i) = xr(j,k,i)
                     y(j,k,i) = yr(j,k,i)
                     z(j,k,i) = zr(j,k,i)
                  end do
               end do
            end do
         else
            read(1,end=999,err=999) 
     .              (((x(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .              (((z(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .              (((y(j,k,i),j=1,jdim),k=1,kdim),i=1,idim)
         end if
#else
         read(1,end=999,err=999) 
     .           (((x(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .           (((z(j,k,i),j=1,jdim),k=1,kdim),i=1,idim),
     .           (((y(j,k,i),j=1,jdim),k=1,kdim),i=1,idim)
#endif
         do i=1,idim
            do j=1,jdim
               do k=1,kdim
                  y(j,k,i) = -y(j,k,i)
               end do
            end do
         end do
      end if
#ifdef CMPLX
c
c     deallocate real arrays in which grid data was read
c
      deallocate(xr)
      deallocate(yr)
      deallocate(zr)
#endif
c
      return
 999  continue
      irr=1
      return
      end	
