      subroutine chksym(nbl,nbci0,nbcidim,nbcj0,nbcjdim,nbck0,nbckdim,
     .                  ibcinfo,jbcinfo,kbcinfo,nface,idim,jdim,kdim,
     .                  nn,maxxseg,ista,iend,jsta,jend,ksta,kend,isym,
     .                  jsym,ksym,nou,bou,nbuf,ibufdim,myid)
c
c     $Id: chksym.F,v 1.2 2001/05/25 20:00:03 biedron Exp $
c
c***********************************************************************
c     Purpose:  Check for symmetry boundary conditions in j, k or i 
c     directions in order to apply bctype 1011 (singular axis with
c     half-plane symmetry)
c***********************************************************************
c
#   ifdef CMPLX
      implicit complex(a-h,o-z)
#   endif
c
      character*120 bou(ibufdim,nbuf)
c
      dimension nou(nbuf)
      dimension nbci0(nn),nbcidim(nn),nbcj0(nn),nbcjdim(nn),
     .           nbck0(nn),nbckdim(nn),ibcinfo(nn,maxxseg,7,2),
     .           jbcinfo(nn,maxxseg,7,2),kbcinfo(nn,maxxseg,7,2)
c
      ioksym = 0
      isym = 0
      jsym = 0
      ksym = 0
c
c***********************************************************************
c     k=1 or k=kdim is a singular axis
c***********************************************************************
c
      if(nface.eq.5.or.nface.eq.6) then
c
c       check for symmetry condition on j=1 face, adjacent to k-axis, 
c       within same i-range as the singular axis segment
c
        jsym = 1
        do 10 nseg=1,nbcj0(nbl)
        ista1 = jbcinfo(nbl,nseg,2,1)
        iend1 = jbcinfo(nbl,nseg,3,1)
        ksta1 = jbcinfo(nbl,nseg,4,1)
        kend1 = jbcinfo(nbl,nseg,5,1)
        if((nface.eq.5 .and. ksta1.eq.1) .or.
     .  (nface.eq.6 .and. kend1.eq.kdim)) then 
          if(ista1.lt.iend .and. iend1.gt.ista) then
c           this segment on the j=1 face must have a symmetry condition in 
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            jbc = jbcinfo(nbl,nseg,1,1)
            if(jbc.ne.1001) jsym = 0
c
c           if(jbc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off jsym on j0',
c    .        ' segment ', nseg
c
          end if
        end if
   10   continue
c
c       check for symmetry condition on j=jdim face, adjacent to k-axis, 
c       within same i-range as the singular axis segment
c
        do 11 nseg=1,nbcjdim(nbl)
        ista1 = jbcinfo(nbl,nseg,2,2)
        iend1 = jbcinfo(nbl,nseg,3,2)
        ksta1 = jbcinfo(nbl,nseg,4,2)
        kend1 = jbcinfo(nbl,nseg,5,2)
        if((nface.eq.5 .and. ksta1.eq.1) .or.
     .  (nface.eq.6 .and. kend1.eq.kdim)) then
          if(ista1.lt.iend .and. iend1.gt.ista) then
c           this segment on the j=jdim face must have a symmetry condition in 
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            jbc = jbcinfo(nbl,nseg,1,2)
            if(jbc.ne.1001) jsym = 0 
c  
c           if(jbc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off jsym on jdim',
c    .        ' segment ', nseg
c
          end if
        end if
   11   continue
c
c       check for symmetry condition in i=1 face, adjacent to k-axis,
c       within same j-range as the singular axis segment
c
        isym = 1
        do 12 nseg=1,nbci0(nbl)
        jsta1 = ibcinfo(nbl,nseg,2,1)
        jend1 = ibcinfo(nbl,nseg,3,1)
        ksta1 = ibcinfo(nbl,nseg,4,1)
        kend1 = ibcinfo(nbl,nseg,5,1)
        if((nface.eq.5 .and. ksta1.eq.1) .or.
     .  (nface.eq.6 .and. kend1.eq.kdim)) then
          if(jsta1.lt.jend .and. jend1.gt.jsta) then
c           this segment on the i=1 face must have a symmetry condition in
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            ibc = ibcinfo(nbl,nseg,1,1)
            if(ibc.ne.1001) isym = 0
c   
c           if(ibc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off isym on i0',
c    .        ' segment ', nseg
c
          end if
        end if
   12   continue
c
c       check for symmetry condition in i=idim face, adjacent to k-axis,
c       within same j-range as the singular axis segment
c
        do 13 nseg=1,nbcidim(nbl)
        jsta1 = ibcinfo(nbl,nseg,2,2)
        jend1 = ibcinfo(nbl,nseg,3,2)
        ksta1 = ibcinfo(nbl,nseg,4,2)
        kend1 = ibcinfo(nbl,nseg,5,2)
        if((nface.eq.5 .and. ksta1.eq.1) .or.
     .  (nface.eq.6 .and. kend1.eq.kdim)) then
          if(jsta1.lt.jend .and. jend1.gt.jsta) then
c           this segment on the i=idim face must have a symmetry condition in
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            ibc = ibcinfo(nbl,nseg,1,2)
            if(ibc.ne.1001) isym = 0
c   
c           if(ibc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off isym on idim',
c    .        ' segment ', nseg
c
          end if
        end if
   13   continue
c
c       MUST have proper symmetry conditions set in either i or j
c       directions in order to use bctype 1011 on k=1 or k=kdim
c
        if(jsym.gt.0 .or. isym.gt.0) then
          ioksym = 1
        else
          if(nface.eq.5) then
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) ' error in applying bctype 1011 on ',
     .      'k=1 boundary:'
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) '    must have symmetry conditions',
     .      ' in i or j directions'
          else 
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) ' error in applying bctype 1011 on ',
     .      'k=kdim boundary:'
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) '    must have symmetry conditions',
     .      ' in i or j directions'
          end if
          call termn8(myid,-1,ibufdim,nbuf,bou,nou)
        end if
c
      end if
c
c***********************************************************************
c     j=1 or j=jdim is a singular axis
c***********************************************************************
c
      if(nface.eq.3 .or. nface.eq.4) then
c
c       check for symmetry condition in k=1 face, adjacent to j-axis, 
c       within same i-range as the singular axis segment
c
        ksym = 1
        do 30 nseg=1,nbck0(nbl)
        ista1 = kbcinfo(nbl,nseg,2,1)
        iend1 = kbcinfo(nbl,nseg,3,1)
        jsta1 = kbcinfo(nbl,nseg,4,1)
        jend1 = kbcinfo(nbl,nseg,5,1)
        if((nface.eq.3 .and. jsta1.eq.1) .or.
     .  (nface.eq.4 .and. jend1.eq.jdim)) then
          if(ista1.lt.iend .and. iend1.gt.ista) then
c           this segment on the k=1 face must have a symmetry condition in 
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            kbc = kbcinfo(nbl,nseg,1,1)
            if(kbc.ne.1001) ksym = 0 
c
c           if(kbc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off ksym on k0',
c    .        ' segment ', nseg
c
          end if
        end if
   30   continue
c
c       check for symmetry condition in k=kdim face, adjacent to j-axis, 
c       within same i-range as the singular axis segment
c
        do 31 nseg=1,nbckdim(nbl)
        ista1 = kbcinfo(nbl,nseg,2,2)
        iend1 = kbcinfo(nbl,nseg,3,2)
        jsta1 = kbcinfo(nbl,nseg,4,2)
        jend1 = kbcinfo(nbl,nseg,5,2)
        if((nface.eq.3 .and. jsta1.eq.1) .or.
     .  (nface.eq.4 .and. jend1.eq.jdim)) then
          if(ista1.lt.iend .and. iend1.gt.ista) then
c           this segment on the k=1 face must have a symmetry condition in 
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            kbc = kbcinfo(nbl,nseg,1,2)
            if(kbc.ne.1001) ksym = 0
c   
c           if(kbc.ne.1001)
c    .         write(61,*) 'block ',nbl,' turning off ksym on kdim',
c    .         ' segment ', nseg
c
          end if
        end if
   31   continue
c
c       check for symmetry condition in i=1 face, adjacent to j-axis,
c       within same k-range as the singular axis segment
c
        isym = 1
        do 32 nseg=1,nbci0(nbl)
        jsta1 = ibcinfo(nbl,nseg,2,1)
        jend1 = ibcinfo(nbl,nseg,3,1)
        ksta1 = ibcinfo(nbl,nseg,4,1)
        kend1 = ibcinfo(nbl,nseg,5,1)
        if((nface.eq.3 .and. jsta1.eq.1) .or.
     .  (nface.eq.4 .and. jend1.eq.jdim)) then
          if(ksta1.lt.kend .and. kend1.gt.ksta) then
c           this segment on the i=1 face must have a symmetry condition in
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            ibc = ibcinfo(nbl,nseg,1,1)
            if(ibc.ne.1001) isym = 0
c   
c           if(ibc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off isym on i0',
c    .        ' segment ', nseg
c
          end if
        end if
   32   continue
c
c       check for symmetry condition on i=idim face, adjacent to j-axis,
c       within same k-range as the singular axis segment
c
        do 33 nseg=1,nbcidim(nbl)
        jsta1 = ibcinfo(nbl,nseg,2,2)
        jend1 = ibcinfo(nbl,nseg,3,2)
        ksta1 = ibcinfo(nbl,nseg,4,2)
        kend1 = ibcinfo(nbl,nseg,5,2)
        if((nface.eq.3 .and. jsta1.eq.1) .or.
     .  (nface.eq.4 .and. jend1.eq.jdim)) then
          if(ksta1.lt.kend .and. kend1.gt.ksta) then
c           this segment on the i=1 face must have a symmetry condition in
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            ibc = ibcinfo(nbl,nseg,1,2)
            if(ibc.ne.1001) isym = 0
c   
c           if(ibc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off isym on idim',
c    .        ' segment ', nseg
c
          end if
        end if
   33   continue
c
c       MUST have proper symmetry conditions set in either i or k
c       directions in order to use bctype 1011 on j=1 or j=jdim
c
        if(ksym.gt.0 .or. isym.gt.0) then
          ioksym = 1
        else
          if(nface.eq.3) then
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) ' error in applying bctype 1011 on ', 
     .      'j=1 boundary:'
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) '    must have symmetry conditions',
     .      ' in i or k directions'
          else   
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) ' error in applying bctype 1011 on ',
     .      'j=jdim boundary:'
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) '    must have symmetry conditions',
     .      ' in i or k directions'
          end if
          call termn8(myid,-1,ibufdim,nbuf,bou,nou)
        end if
c
      end if
c
c***********************************************************************
c     i=1 or i=idim is a singular axis
c***********************************************************************
c
      if(nface.eq.1 .or. nface.eq.2) then
c
c       check for symmetry condition in j=1 face, adjacent to i-axis, 
c       within same k-range as the singular axis segment
c
        jsym = 1
        do 50 nseg=1,nbcj0(nbl)
        ista1 = jbcinfo(nbl,nseg,2,1)
        iend1 = jbcinfo(nbl,nseg,3,1)
        ksta1 = jbcinfo(nbl,nseg,4,1)
        kend1 = jbcinfo(nbl,nseg,5,1)
        if((nface.eq.1 .and. ista1.eq.1) .or.
     .  (nface.eq.2 .and. iend1.eq.idim)) then
          if(ksta1.lt.kend .and. kend1.gt.ksta) then
c           this segment on the j=1 face must have a symmetry condition in 
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            jbc = jbcinfo(nbl,nseg,1,1)
            if(jbc.ne.1001) jsym = 0
c
c           if(jbc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off jsym on j0',
c    .        ' segment ', nseg
c
          end if
        end if
   50   continue
c
c       check for symmetry condition in j=jdim face, adjacent to i-axis, 
c       within same k-range as the singular axis segment
c
        do 51 nseg=1,nbcjdim(nbl)
        ista1 = jbcinfo(nbl,nseg,2,2)
        iend1 = jbcinfo(nbl,nseg,3,2)
        ksta1 = jbcinfo(nbl,nseg,4,2)
        kend1 = jbcinfo(nbl,nseg,5,2)
        if((nface.eq.1 .and. ista1.eq.1) .or.
     .  (nface.eq.2 .and. iend1.eq.idim)) then
         if(ksta1.lt.kend .and. kend1.gt.ksta) then
c          this segment on the j=jdim face must have a symmetry condition in 
c          order to apply bctype 1011 - turn OFF symmetry flag if not
           jbc = jbcinfo(nbl,nseg,1,2)
           if(jbc.ne.1001) jsym = 0 
c   
c          if(jbc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off jsym on jdim',
c    .        ' segment ', nseg
c
         end if
        end if
   51   continue
c
c       check for symmetry condition in k=1 face, adjacent to i-axis,
c       within same j-range as the singular axis segment
c
        ksym = 1
        do 52 nseg=1,nbck0(nbl)
        ista1 = kbcinfo(nbl,nseg,2,1)
        iend1 = kbcinfo(nbl,nseg,3,1)
        jsta1 = kbcinfo(nbl,nseg,4,1)
        jend1 = kbcinfo(nbl,nseg,5,1)
        if((nface.eq.1 .and. ista1.eq.1) .or.
     .  (nface.eq.2 .and. iend1.eq.idim)) then
          if(jsta1.lt.jend .and. jend1.gt.jsta) then
c           this segment on the k=1 face must have a symmetry condition in
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            kbc = kbcinfo(nbl,nseg,1,1)
            if(kbc.ne.1001) ksym = 0
c   
c           if(kbc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off ksym on k0',
c    .        ' segment ', nseg
c
          end if
        end if
   52   continue
c
c       check for symmetry condition in k=kdim face, adjacent to i-axis,
c       within same j-range as the singular axis segment
c
        do 53 nseg=1,nbckdim(nbl)
        ista1 = kbcinfo(nbl,nseg,2,2)
        iend1 = kbcinfo(nbl,nseg,3,2)
        jsta1 = kbcinfo(nbl,nseg,4,2)
        jend1 = kbcinfo(nbl,nseg,5,2)
        if((nface.eq.1 .and. ista1.eq.1) .or.
     .  (nface.eq.2 .and. iend1.eq.idim)) then
          if(jsta1.lt.jend .and. jend1.gt.jsta) then
c           this segment on the k=kdim face must have a symmetry condition in
c           order to apply bctype 1011 - turn OFF symmetry flag if not
            kbc = kbcinfo(nbl,nseg,1,2)
            if(kbc.ne.1001) ksym = 0
c   
c           if(kbc.ne.1001)
c    .        write(61,*) 'block ',nbl,' turning off ksym on kdim',
c    .        ' segment ', nseg
c
          end if
        end if
   53   continue
c
c       MUST have proper symmetry conditions set in either k or j
c       directions in order to use bctype 1011 on i=1 or i=idim
c
        if(jsym.gt.0 .or. ksym.gt.0) then
          ioksym = 1
        else
          if(nface.eq.1) then
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) ' error in applying bctype 1011 on ',
     .      'i=1 boundary:'
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) '    must have symmetry conditions',
     .      ' in k or j directions'
          else   
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) ' error in applying bctype 1011 on ',
     .      'i=idim boundary:'
            nou(1) = min(nou(1)+1,ibufdim)
            write(bou(nou(1),1),*) '    must have symmetry conditions',
     .      ' in k or j directions'
          end if
          call termn8(myid,-1,ibufdim,nbuf,bou,nou)
        end if
c
      end if
c
      return
      end
