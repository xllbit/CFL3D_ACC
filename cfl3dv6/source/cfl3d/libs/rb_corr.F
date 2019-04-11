      subroutine rb_corr(cn,cm)
      use rbstmt1_x
      use rbstmt2_x
c
c     $Id: rb_corr.F,v 1.2 2001/05/25 20:00:08 biedron Exp $
c
c***********************************************************************
c     Purpose: Update the rigid body displacements and velocities via
c              a corrector step of the rigid body equations of motion.
c
c              
c        Reference: Vinh, Lam-Son, Edwards, J.W., Seidel, D. A., Batina,
c                   J. T., "Transonic Stability and Control of Aircraft
c                   Using CFD Methods," AIAA Paper 88-4374.
c
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
c      common /rbstmt1/ bmatrb(4,4),gforcnrb(4),gforcnmrb(4),gforcsrb(4),
c     .                 stmrb(4,4),stmirb(4,4),xsrb(4),xxnrb(4),xnmrb(4),
c     .                 x0rb(4)
c      common /rbstmt2/ tmass,yinert,uinfrb,qinfrb,greflrb,gaccel,crefrb,
c     .                 xtmref,areat 
c
c     rigid body displacement and velocity prediction via rigid body
c     equations of motion
c
         gforcsrb(1) = 0.
         gforcsrb(2) = tmass*gaccel-qinfrb*areat*greflrb*greflrb*cn 
         gforcsrb(3) = 0.
         gforcsrb(4) = qinfrb*areat*greflrb*greflrb*greflrb*(crefrb*cm
     .               + xtmref*cn) 
c
      do n=1,4
        xnmrb(n) = xsrb(n)
      enddo

      do n=1,4
         xsrb(n) = 0.
         do j=1,4
            xsrb(n) = xsrb(n) + stmrb(n,j)*xxnrb(j)
     .              + .5*stmirb(n,j)*(gforcsrb(j) + gforcnrb(j))
         end do
      end do
c
      return
      end
