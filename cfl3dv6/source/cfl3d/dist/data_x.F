      module cgns_x
        implicit none
        integer icgns,iccg,ibase,nzones,nsoluse,irind,jrind,krind
      end module 
      
      module filenam_x
        implicit none
        character*80 grid,plt3dg,plt3dq,output,residual,turbres,blomx,
     .         output2,printout,pplunge,ovrlap,patch,restrt,
     .         subres,subtur,grdmov,alphahist,errfile,preout,
     .        aeinp,aeout,sdhist,avgg,avgq
      end module

      module key_x
        implicit none
        integer nkey
      end module

      module mydist2_x
        implicit none
        integer nnodes,myhost,myid,mycomm
      end module  

      module proces_x
        implicit none
        integer numprocs
      end module
      
      module unit5_x
        implicit none
        integer iunit5
      end module  

      module wrestq_x
        implicit none
        integer irest,irest2
      end module

      module zero_x
        implicit none
        integer iexp
      end module

      module elastic_x
        implicit none
        integer ndefrm,naesrf
      end module
      module elastic_ss_x
        implicit none
        integer idef_ss
      end module
      module alphait_x
        implicit none
        integer ialphit,cltarg,rlxalph,dalim,dalpha,icycupdt
      end module

      module params_x
              implicit none
              integer lmaxgr,lmaxbl,lmxseg,lmaxcs,lnplts,lmxbli,lmaxxe,
     .                lnsub1,lintmx,lmxxe,liitot,isum,lncycm,
     .                isum_n,lminnode,isumi,isumi_n,lmptch,
     .                lmsub1,lintmax,libufdim,lnbuf,llbcprd,
     .                llbcemb,llbcrad,lnmds,lmaxaes,lnslave,lmxsegdg,
     .                lnmaster
      end module

      module fluid_x
              implicit none
              real gamma,gm1,gp1,gm1g,gp1g,ggm1
!$acc declare create(gamma,gm1,gp1,gm1g,gp1g,ggm1)
      end module

      module ginfo_x
              implicit none

              integer jdim,kdim,idim,jj2,kk2,ii2,nblc,js,ks,is,je,ke,ie,
     .        lq,lqj0,lqk0,lqi0,lsj,lsk,lsi,lvol,ldtj,lx,ly,lz,lvis,
     .        lsnk0,lsni0,lq1,lqr,lblk,lxib,lsig,lsqtq,lg,
     .        ltj0,ltk0,lti0,lxkb,lnbl,lvj0,lvk0,lvi0,lbcj,lbck,lbci,
     .        lqc0,ldqc0,lxtbi,lxtbj,lxtbk,latbi,latbj,latbk,
c    .        lbcdj,lbcdk,lbcdi,lxib2,lux,lcmuv,lvolj0,lvolk0,lvoli0
     .        lbcdj,lbcdk,lbcdi,lxib2,lux,lcmuv,lvolj0,lvolk0,lvoli0,
     .        lxmdj,lxmdk,lxmdi,lvelg,ldeltj,ldeltk,ldelti,
     .        lxnm2,lynm2,lznm2,lxnm1,lynm1,lznm1,lqavg
!$acc declare create(jdim,kdim,idim,jj2,kk2,ii2,nblc,js,ks,is,je,ke,ie)
!$acc declare create(lq,lqj0,lqk0,lqi0,lsj,lsk,lsi,lvol,ldtj,lx,ly,lz)
!$acc declare create(lvis,lsnk0,lsni0,lq1,lqr,lblk,lxib,lsig,lsqtq,lg)
!$acc declare create(ltj0,ltk0,lti0,lxkb,lnbl,lvj0,lvk0,lvi0,lbcj,lbck)              
!$acc declare create(lqc0,ldqc0,lxtbi,lxtbj,lxtbk,latbi,latbj,latbk)
!$acc declare create(lbcdj,lbcdk,lbcdi,lxib2,lux,lcmuv,lvolj0,lvolk0)
!$acc declare create(lxmdj,lxmdk,lxmdi,lvelg,ldeltj,ldeltk,ldelti,lbci)
!$acc declare create(lxnm2,lynm2,lznm2,lxnm1,lynm1,lznm1,lqavg,lvoli0)    
      end module

      module info_x
              implicit none
              real title(20),rkap(3),xmach,alpha,beta,dt,fmax
              integer nit,ntt,
     .        idiag(3),nitfo,iflagts,iflim(3),nres,levelb(5),mgflag,
     .        iconsf,mseq,ncyc1(5),levelt(5),nitfo1(5),ngam,nsm(5),iipv
!$acc declare create(title(20),rkap(3),xmach,alpha,beta,dt,fmax)
!$acc declare create(nit,ntt,idiag(3),nitfo,iflagts,iflim(3),nres)
!$acc declare create(levelb(5),mgflag,iconsf,mseq,ncyc1(5),levelt(5))
!$acc declare create(nitfo1(5),ngam,nsm(5),iipv)              
      end module
      module maxiv_x
              implicit none
              integer ivmx
      end module
      module mgrd_x
              implicit none
              integer levt,kode,mode,ncyc,mtt,icyc,level,lglobal
      end module
      module reyue_x
              implicit none
              real reue,tinf
              integer ivisc(3)
!$acc declare create(ivisc(3))              
      end module
      module unst_x
              implicit none
              real time,cfltau
              integer ntstep,ita,iunst
      end module
      module twod_x
              implicit none
              integer i2d
      end module
      module is_blockbc_x
              implicit none
              integer is_blk(5),ie_blk(5),ivolint
      end module
      module is_perbc_x
              implicit none
              integer is_prd(5),ie_prd(5),nbcprd
      end module
      module is_patch_x
              implicit none
              integer is_pat(5),ie_pat(5)
      end module
      module is_embedbc_x
              implicit none
              integer is_emb(5),ie_emb(5),nbcemb
      end module
      module conversion_x
              implicit none
              real radtodeg
      end module
      module moov_x
              implicit none
              integer movie,nframes,icall1,lhdr
      end module
      module memory_x
              implicit none
              integer memadd,memaddi
      end module
      module cpurate_x
              implicit none
              real rate(5),ratesub(5)
              integer ncell(20)
      end module
      module cfl_x
              implicit none
              real dt0,dtold
      end module
      module sklton_x
              implicit none
              integer isklton
      end module
      module time1_x
              implicit none
              real*4 tim(3,3),tm(3)
      end module
      module motionmc_x
              implicit none
              real xmc0,ymc0,zmc0,utransmc,vtransmc,wtransmc,
     .             omegaxmc,omegaymc,omegazmc,xorigmc,yorigmc,
     .             zorigmc,xorig0mc,yorig0mc,zorig0mc,thetaxmc,
     .             thetaymc,thetazmc,dxmxmc,dymxmc,dzmxmc,
     .             dthxmxmc,dthymxmc,dthzmxmc,rfreqtmc,
     .             rfreqrmc,itransmc,irotatmc,time2mc    
      end module
      module bin_x
              implicit none
              integer ibin,iblnk,iblnkfr,ip3dgrad
      end module
      module avgdata_x
              implicit none
              real xnumavg
              integer iteravg
      end module
      module complx_x
              implicit none
              real xmach_img,alpha_img,beta_img,reue_img,tinf_img,
     .             geom_img,surf_img,xrotrate_img,yrotrate_img,
     .             zrotrate_img
      end module
      module des_x
              implicit none
              real cdes
              integer ides
      end module
      module precond_x
              implicit none
              real cprec,uref,avn
!$acc declare create(cprec,uref,avn)
      end module
      module chk_x
              implicit none
              integer ichk
!$acc declare create(ichk)
      end module
      module degshf_x
              implicit none
              integer ideg(3)
!$acc declare create(ideg(3))              
      end module
      module fsum_x
              implicit none
              real sref,cref,bref,xmc,ymc,zmc
      end module
      module fvfds_x
              implicit none
              real rkap0(3)
              integer ifds(3)
!$acc declare create(rkap0(3),ifds(3))              
      end module
      module lam_x
              implicit none
              integer ilamlo,ilamhi,jlamlo,jlamhi,klamlo,klamhi
!$acc declare create(ilamlo,ilamhi,jlamlo,jlamhi,klamlo,klamhi)
      end module
      module mgv_x
              implicit none
              real epsssc(3),epsssr(3)
              integer issc,issr
      end module
      module ncyct_x
              implicit none
              integer ncyctot
      end module
      module sminn_x
              implicit none
              integer isminc
      end module
      module wallfun_x
              implicit none
              integer iwf(3)
!$acc declare create(iwf(3))              
      end module
      module wrbl_x
              implicit none
              integer nwrest
      end module
      module igrdtyp_x
              implicit none
              integer ip3dgrd,ialph
      end module
      module deformz_x
              implicit none
              real beta1
              integer ismooth,negvol
      end module
      module turbconv_x
              implicit none
              real cflturb,edvislim,tur1cut
              integer iturbprod,nsubturb,nfreeze,iwarneddy,
     .                itime2read,itaturb
      end module
      module ivals_x
              implicit none
              real p0,rho0,c0,u0,v0,w0,et0,h0,pt0,rhot0,qiv(5),
     .        tur10,tur20
!$acc declare create(p0,rho0,c0,u0,v0,w0,et0,h0,pt0,rhot0)
!$acc declare create(qiv(5),tur10,tur20)
      end module
      module alloc_x
              implicit none
              integer iptr,imax,ifptr,ifmax
      end module
      module bbcom_x
              implicit none
              integer nbbv,minpbb,maxlev,nwv,nbb,totbbv
              real bbmin(3),bbmax(3)
      end module
      module ghost_x
              implicit none
              integer irghost,iwghost
      end module
      module fluid2_x
              implicit none
              real pr,prt,cbar 
      end module
      module tol_x
              implicit none
              real epsc,epsc0,epsreen,epscoll
      end module
      module sklt1_x
              implicit none
              integer isklt1
      end module
      module save_x
              implicit none
              integer locv,ireq
      end module
      module is_dpatch_x
              implicit none
              real maxdcnt
      end module
      module rigidbody_x
              implicit none
              integer irigb,irbtrim
      end module
      module noninertial_x
              implicit none
              real xcentrot,ycentrot,zcentrot,xrotrate,
     .                     yrotrate,zrotrate
              integer noninflag
      end module
      module girdtrans_x
              implicit none
              real roll_angle
      end module
      module account_x
              implicit none
              integer iaccnt,ioutsub
      end module
      module drag_x
              implicit none
              real cdv,cdp
      end module
      module subit_x
              implicit none
              real cltsub,cdtsub,cxtsub,cytsub,cztsub,
     .        cmxtsub,cmytsub,cmztsub,cdptsub,cdvtsub,
     .        sxsub,sysub,szsub,stotsub,fmdotsub,cfxpsub,
     .        cfypsub,cfzpsub,cflpsub,cfdpsub,cftpsub,cfxvsub,
     .        cfyvsub,cfzvsub,cflvsub,cfdvsub,cftvsub,cfxmomsub,
     .        cfymomsub,cfzmomsub,cflmomsub,cfdmomsub,cftmomsub,
     .        cfxtotsub,cfytotsub,cfztotsub,cfdtotsub,cfltotsub,
     .        cfttotsub 
      end module
      module nfablk_x
              implicit none
              integer nfajki(3)
      end module
      module trim_x
              implicit none
              real dmtrmn,dmtrmnm,dlcln,dlclnm,trtol,cmy,cnw,alf0,
     .             alf1,dzdt,thtd0,thtd1,zrg0,zrg1,dtrmsmx,dtrmsmn,
     .             dalfmx,ddtmx,ddtrm0,ddtrm1,fp(4,4),
     .             tp(4,4)
              integer itrmt,itrminc
      end module
      module singular_x
              implicit none
              real atol     
      end module
      module entfix_x
              implicit none
              real epsa_l,epsa_r
      end module
      module gridtrans_x
              implicit none
              real roll_angle
      end module
      module ypinfo_x
              implicit none
              real ypsumb,ypsumsqb,ypmaxb,ypminb,dnmaxb,dnminb,ypchk
              integer nptsb,jypmaxb,kypmaxb,iypmaxb,jypminb,kypminb,
     .                iypminb,jdnmaxb,kdnmaxb,idnmaxb,jdnminb,
     .                kdnminb,idnminb,nypchkb
      end module
      module time2_x
              implicit none
              real*4 tim_nd(3,3)
      end module
      module savnint_x
              implicit none
              integer ninter0
      end module
      module tracer_x
              implicit none
              integer itrace
      end module
      module grid1_x
              implicit none
              real algepmn,coef(2)
      end module
      module grid2_x
              implicit none
              integer kimx(2),jtel(2),
     .                jflp(2,2),icsi(2),icso(2),iafmv1(2),jsp1(2),  
     .                jsp2(2),jsp3(2),itecs(2),ispcs(2),itp(2,2),
     .                iaxrt(2)
      end module
      module grid4_x
              implicit none
              real time0
      end module
      module grid8_x
              implicit none
              real fc3,dxave
      end module
      module grid15_x
              implicit none
              integer igtyp(2),idmg(2),jdmg(2),kdmg(2)
      end module
      module areas_x
              implicit none
              real ap(3)
              integer imaxa
      end module
      module tacos_x
              implicit none
              integer iretry
      end module
      module hist_x
              implicit none
              real histry(4)
      end module
      module rbstmt1_x
              implicit none
              real bmatrb(4,4),gforcnrb(4),gforcnmrb(4),gforcsrb(4),
     .             stmrb(4,4),stmirb(4,4),xsrb(4),xxnrb(4),xnmrb(4),
     .             x0rb(4)

      end module
      module rbstmt2_x
              implicit none
              real tmass,yinert,uinfrb,qinfrb,greflrb,gaccel,crefrb,
     .                 xtmref,areat 
      end module
      module easmv_x
              implicit none
              real c1,c2,c3,c4,c5,sigk1,cmuc1 
      end module
      module chkbc_x
              implicit none
              integer isym,jsym,ksym,iwrap,jwrap,kwrap
      end module
