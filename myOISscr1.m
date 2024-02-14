function myOISscr1(fname,saveid,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16)
% Usage ... myOISscr1(fname,saveid,p1,a1,p2,a2,...)
%
% p#s = do_load, do_loadall, do_motc, do_maskreg, do_intc, do_motc_apply, do_intc_apply, do_keepalldata
% average_parms = [#off, #ims_per_trial, #trials]
%
% ex. 
% myOISscr1('20160517mouse_avxc1_ledstim01.stk','avxc1_ledstim01','do_load',[1:6100],...
%    'do_crop','do_motc','do_realign','do_intc','do_maskreg','do_bin',[2 2 2]);

if nargin==2,
  p1={'do_loadall','do_crop','do_motc','do_realign','do_intc','do_maskreg','do_bin',[2 2 2],'do_binfirst'};
end;
if ischar(p1),
  if strcmp(p1,'default')|strcmp(p1,'def')|strcmp(p1,'Default')|strcmp(p1,'defaults'),
    disp('  using defaults...');
    p1={'do_loadall','do_crop','do_motc','do_intc','do_maskreg','do_bin',[2 2 2]};
    if nargin>3, 
      for mm=2:nargin-2, 
        disp(sprintf('  adding p%d',mm));
        eval(sprintf('p1{end+1}=p%d;',mm)); 
      end; 
    end;
  end;
end;


vars={'do_load','do_loadall','do_crop','do_motc','do_maskreg','do_intc','do_bin',...
      'do_ffilt','do_arfilt','do_detrend','do_motc_apply','do_intc_apply','do_motcmask',...
      'do_arfilt_apply','do_keepalldata','do_binfirst','do_average','do_timing','do_sequential','do_seqinterp'};
nvars=length(vars);

if iscell(p1),
  p1cell=p1;
  for mm=1:length(p1cell), eval(sprintf('p%d=p1cell{mm};',mm)); end;
  mynargin=length(p1cell)+2;
else,
  mynargin=nargin;
end;

% initialize parse
disp(sprintf('nvars=%d',nvars));
for mm=1:length(vars), 
  eval(sprintf('%s=0;',vars{mm}));
end;

% parse settings
disp(sprintf('nargs=%d',nargin));
for mm=1:mynargin-2,
  for nn=1:nvars,
    eval(sprintf('tmptest=strcmp(p%d,''%s'');',mm,vars{nn}));
    if tmptest,
      disp(sprintf('%s=1;',vars{nn}));
      eval(sprintf('%s=1;',vars{nn}));
      if mm<mynargin-2,
        eval(sprintf('%s_parms=p%d;',vars{nn}(4:end),mm+1));
        eval(sprintf('tmptest2=p%d;',mm+1));
        if isstr(tmptest2),
          disp(sprintf('%s_parms=[];',vars{nn}(4:end)));
          eval(sprintf('%s_parms=[];',vars{nn}(4:end)));
        else,
          disp(sprintf('%s_parms=p%d;',vars{nn}(4:end),mm+1));
          eval(sprintf('%s_parms=p%d;',vars{nn}(4:end),mm+1));
        end;
      else,
        eval(sprintf('%s_parms=[];',vars{nn}(4:end)));
      end;
    end;
  end;
end;

%fname='20160517mouse_avxc1_ledstim01.stk';
%saveid='avxc1_ledstim01';
%nbin=[2 2 2];
%
%do_load=1;
%do_crop=1;
%do_figs=1;
%do_regmask=1;
%do_motdetect=1;
%do_realign=1;
%do_motregress=1;



sname=sprintf('%s_res.mat',saveid);
if exist(sname),
  tmpin=input(sprintf('--file %s exists [0=quit, 1=replace, 2=load]: ',sname));
  %if isempty(tmpin), return; end;
  if tmpin==2,
    disp(sprintf('  reloading...'));
    eval(sprintf('load %s',sname));
  elseif tmpin==0,
    return;
  else,
    disp('--continuing...');
  end;
else,
  eval(sprintf('save %s do_* fname sname saveid',sname));
end;
%if exist('tmp_scr.mat'),
%  tmpin=input('  tmp file found, use it? [0=no, 1=yes]: ');
%  if ~isempty(tmpin), if tmpin==1, load('tmp_scr.mat'), end; end;
%else,
%  save tmp_scr fname
%end;

if do_binfirst, if do_bin, do_bin=0; end; end;

if exist('do_crop_done','var'), do_crop=0; end;
if exist('do_load_done','var'), do_load=0; do_loadall=0; end;
if exist('do_loadall_done','var'), do_loadall=0; end;
if exist('do_motc_done','var'), do_motc=0; end;
if exist('do_realign_done','var'), do_realign=0; end;
if exist('do_maskreg_done','var'), do_maskreg=0; end;
if exist('do_intc_done','var'), do_intc=0; end;
if exist('do_bin_done','var'), do_bin=0; end;
if exist('do_binfirst_done','var'), do_binfirst=0; end;
if exist('do_average_done','var'), do_average=0; end;
if exist('do_timing_done','var'), do_timing=0; end;
if exist('do_sequential_done','var'), do_sequential=0; end;
if exist('do_seqinterp_done','var'), do_seqinterp=0; end;

if ~exist('do_load','var'), do_load=0; do_load_all=1; end;

if do_crop,
  disp('  do_crop...');
  tmpim=readOIS3(fname,1);
  if isempty(crop_parms),
    tmpok=0;
    while(~tmpok),
      figure(1), clf,
      show(tmpim),
      disp('  select upper-left and lower-right corners...');
      tmpii=round(ginput(2));
      if tmpii(1,1)<1, tmpii(1,1)=1; end;
      if tmpii(1,1)>size(tmpim,2), tmpii(1,1)=size(tmpim,2); end;
      if tmpii(1,2)<1, tmpii(1,2)=1; end;
      if tmpii(1,2)>size(tmpim,1), tmpii(1,2)=size(tmpim,1); end;
      if tmpii(2,1)<1, tmpii(2,1)=1; end;
      if tmpii(2,1)>size(tmpim,2), tmpii(2,1)=size(tmpim,2); end;
      if tmpii(2,2)<1, tmpii(2,2)=1; end;
      if tmpii(2,2)>size(tmpim,1), tmpii(2,2)=size(tmpim,1); end;
      crop_ii=[min(tmpii(:,2)) max(tmpii(:,2)) min(tmpii(:,1)) max(tmpii(:,1))];
      tmpmask=zeros(size(tmpim));
      tmpmask(crop_ii(1):crop_ii(2),crop_ii(3):crop_ii(4))=1;
      show(im_super(tmpim,tmpmask,0.5)), drawnow;
      tmpin=input('  selection ok? [0=no, 1=yes, 9=no+exit]: ');
      if isempty(tmpin),
        tmpok=1;
      elseif tmpin==1,
        tmpok=1;
      elseif tmpin==9,
        crop_ii=[1 size(tmpim,2) 1 size(tmpim,1)];
        tmpok=1;
      end;
    end;
    disp(sprintf('  crop_ii=[%d %d %d %d]',crop_ii(1),crop_ii(2),crop_ii(3),crop_ii(4)));
    crop_parms=crop_ii;
  else,
    crop_ii=crop_parms;
  end;
  tmpim=tmpim(crop_ii(1):crop_ii(2),crop_ii(3):crop_ii(4));
  show(tmpim), drawnow,
  %eval(sprintf('print -dpng samplefig_%s_cropim',saveid));
  clear tmpim tmpok tmpii tmpin
  do_crop_done=1;
  eval(sprintf('save %s -append crop_parms crop_ii do_crop_done',sname));
else,
  tmpim=readOIS3(fname,1);
  crop_ii=[1 size(tmpim,1) 1 size(tmpim,2)];
  %crop_parms=crop_ii;
end;

if do_loadall,
  disp('  do_loadall...');
  data=[];
  cnt=1;
  tmpfnd=0;
  while(~tmpfnd),
    tmpim=readOIS3(fname,cnt);
    if isempty(tmpim),
      tmpfnd=1;
      cnt=cnt-1;
    else,
      if do_crop, tmpim=tmpim(crop_ii(1):crop_ii(2),crop_ii(3):crop_ii(4)); end;
      data(:,:,cnt)=single(tmpim);
      cnt=cnt+1;
    end;
  end;
  disp(sprintf('  vol_dim=[%d %d %d]',size(data,1),size(data,2),size(data,3)));
  nims=size(data,3);
  avgim_raw=mean(data,3); stdim_raw=std(data,[],3);
  avgtc_raw=squeeze(mean(mean(data,1),2));
  figure(2), clf,
  plot(avgtc_raw), axis('tight'), grid('on'),
  xlabel('im#'), ylabel('data mean intensity'),
  eval(sprintf('print -dpng samplefig_%s_data_avgtc',saveid));
  do_loadall_done=1;
  if do_keepalldata,
    data_raw=data;
    eval(sprintf('save %s -append data_raw',sname));
    clear data_raw
  end;
  %disp(sprintf('save %s -append data avgim_raw stdim_raw avgtc_raw nims do_loadall_done',sname));
  eval(sprintf('save %s -append data avgim_raw stdim_raw avgtc_raw nims do_loadall_done',sname));
end;

if do_load,
  disp('  do_load...');
  nims=load_parms;
  tmpim=readOIS3(fname,nims(1));
  if do_crop, 
    tmpim=tmpim(crop_ii(1):crop_ii(2),crop_ii(3):crop_ii(4)); 
  else,
    crop_ii=[1 size(tmpim,2) 1 size(tmpim,1)];
  end;
  if do_binfirst,
    disp('  do_binfirst also...');
    tmpim=imbin(tmpim,bin_parms(1:2));
    tmpdim=[size(tmpim) floor(length(nims)/bin_parms(3))];
    data=single(zeros(tmpdim));
    cnt=0;
    for mm=1:bin_parms(3):length(nims),
      cnt=cnt+1;
      if cnt<4, disp(sprintf('  reading %d',nims(mm))); end; 
      tmpim=mean(readOIS3(fname,nims(mm)+[0:bin_parms(3)-1]),3);
      data(:,:,cnt)=single(imbin(tmpim(crop_ii(1):crop_ii(2),crop_ii(3):crop_ii(4)),bin_parms(1:2)));
    end;
    disp(sprintf('  ... last im %d',nims(mm)));
    clear tmpim tmpdim cnt
    avgim_bin=mean(data,3); stdim_bin=std(data,[],3);
    avgtc_bin=squeeze(mean(mean(data,1),2));
    do_binfirst=0; do_bin=0;
  else,
    tmpdim=[size(tmpim) length(nims)];
    data=single(zeros(tmpdim));
    for mm=1:length(nims),
      if mm<4, disp(sprintf('  reading %d',nims(mm))); end; 
      tmpim=readOIS3(fname,nims(mm));
      data(:,:,mm)=single(tmpim);
    end;
    clear tmpim tmpdim
  end;
  avgim_raw=mean(data,3); stdim_raw=std(data,[],3);
  avgtc_raw=squeeze(mean(mean(data,1),2));
  figure(2), clf,
  if length(avgtc_raw)==length(nims),
    plot(nims,avgtc_raw), axis('tight'), grid('on'),
  else,
    plot(avgtc_raw), axis('tight'), grid('on'),
  end;
  xlabel('im#'), ylabel('data mean intensity'),
  eval(sprintf('print -dpng samplefig_%s_data_avgtc',saveid));
  do_load_done=1;
  if do_keepalldata,
    data_raw=data;
    eval(sprintf('save %s -append data_raw',sname));
    clear data_raw
  end;
  %disp(sprintf('save %s -append data avgtc_raw avgim_raw stdim_raw nims load_parms do_load_done',sname));
  eval(sprintf('save %s -append data avgtc_raw avgim_raw stdim_raw nims load_parms do_load_done',sname));
  if exist('avgtc_bin','var'),
    do_binfirst_done=1; do_bin_done=1;
    eval(sprintf('save %s -append avgtc_bin avgim_bin stdim_bin bin_parms do_bin_done do_binfirst_done',sname));
  end;
end;

if do_binfirst,
  disp('  do bin first...');
  data_bin=volbin(data,bin_parms);
  avgtc_bin=squeeze(mean(mean(data_bin,1),2));
  avgim_bin=mean(data_bin,3); stdim_bin=std(data_bin,[],3);
  data=data_bin; clear data_bin
  do_bin_done=1;
  if do_keepalldata,
    data_bin=data;
    eval(sprintf('save %s -append data_bin',sname));
    clear data_bin
  end;
  disp(sprintf('save %s -append data avgim_bin stdim_bin avgtc_bin bin_parms do_bin_done',sname))
  eval(sprintf('save %s -append data avgim_bin stdim_bin avgtc_bin bin_parms do_bin_done',sname))
end;


if do_sequential,
  disp('  do sequential...');
  if length(sequential_parms)==1, sequential_parms(2)=0; end;
  nseq=sequential_parms(1);
  data_seq=single(zeros(size(data,1),size(data,2),ceil(size(data,3)/nseq),nseq));
  do_seqcheck=sequential_parms(2);
  if do_seqcheck,
    disp('  checking seq data...');
    seq_ii=chkOISseq1(data,nseq,data(:,:,1:nseq));
    for mm=1:nseq,
      tmpii=find(seq_ii==mm);
      data_seq(:,:,1:length(tmpii),mm)=data(:,:,tmpii);
    end;
  else,
    seq_ii=[];
    for mm=1:nseq, data_seq(:,:,:,mm)=data(:,:,1:nseq:end); end;
  end;
  if do_keepalldata,
    eval(sprintf('save %s -append data_seq',sname));
  end;
  avgim_seq=squeeze(mean(data_seq,3));
  stdim_seq=squeeze(std(data_seq,[],3));
  avgtc_seq=squeeze(mean(mean(data_seq,1),2));
  data=data_seq;
  clear data_seq;
  figure(2), clf,
  plot(avgtc_seq), axis('tight'), grid('on'),
  xlabel('im#'), ylabel('data mean intensity'),
  eval(sprintf('print -dpng samplefig_%s_data_avgtc_seq',saveid));

  do_sequential_done=1;
  disp(sprintf('save %s -append data avgim_seq stdim_seq avgtc_seq sequential_parms nseq seq_ii do_sequential_done',sname))
  eval(sprintf('save %s -append data avgim_seq stdim_seq avgtc_seq sequential_parms nseq seq_ii do_sequential_done',sname))
end;


if do_seqinterp,
  disp('  do_seqinterp...');
  tt=[1:nims]; tt=tt(:);
  if isempty(seq_ii),
    for mm=1:nseq, ttseq(:,mm)=tt(mm:nseq:end); end;
  else,
    for mm=1:nseq, ttseq(:,mm)=tt(find(seq_ii==mm)); end;
  end;
  data_iseq=single(size(data,1),size(data,2),nseq*size(data,3),size(data,4));
  for oo=1:nseq, for mm=1:size(data,1), for nn=1:size(data,2),
    tmptc=squeeze(data(mm,nn,:,oo));
    tmptc2=interp1(ttseq(:,oo),tmptc,tt);
    data_iseq(mm,nn,:,oo)=tmptc2;
  end; end; end;
  if do_keepalldata,
    eval(sprintf('save %s -append data_iseq',sname));
  end;
  avgtc_iseq=squeeze(mean(mean(data_iseq,1),2));
  data=data_iseq;
  clear data_iseq;

  do_seqinterp_done=1;
  disp(sprintf('save %s -append data avgtc_iseq tt ttseq do_seqinterp_done',sname))
  eval(sprintf('save %s -append data avgtc_iseq tt ttseq do_seqinterp_done',sname))
end;


if do_motc,
  disp('  do_motc...');
  if isempty(motc_parms), motc_parms=[4 20 0 1 0]; end;
  if do_motcmask,
    motc_mask=motcmask_parms;
  else,
    motc_mask=ones(size(data(:,:,1)));
  end;
  if do_sequential,
    for nn=1:nseq,
      disp(sprintf('  motc seq %d',nn));
      xx_motc_seq(:,:,nn)=imMotDetect(data(:,:,:,nn),1,motc_parms,motc_mask);
    end;
    xx_motc=reshape(xx_motc_seq,[size(xx_motc_seq,1) size(xx_motc_seq,2)*nseq]);
  else,
    xx_motc=imMotDetect(data,1,motc_parms,motc_mask);
  end;
  figure(2), clf,
  plot(xx_motc), axis('tight'), grid('on'),
  xlabel('im#'), ylabel('pixel displacement'), legend('x','y'),
  eval(sprintf('print -dpng samplefig_%s_xxmotc',saveid));
  do_realign=1;
  do_motc_done=1;
  %disp(sprintf('save %s -append motc_parms motc_mask xx_motc do_motc_done do_realign',sname));
  eval(sprintf('save %s -append motc_parms motc_mask xx_motc do_motc_done do_realign',sname));
else,
  do_realign=0;
end;

if do_realign,
  disp('  do_realign...'); 
  if ~exist('realign_parms','var'), realign_parms=[]; end;
  if isempty(realign_parms), realign_parms=1; end;
  ss_xc=sum(xx_motc(:,1:2).^2,2).^0.5;
  disp(sprintf('  motc result %.2f percent (%d) over 0.2 pix xy shift',sum(ss_xc>0.14)/length(ss_xc),sum(ss_xc>0.14)));
  tmpok=sum(ss_xc>0.14)>1;
  if realign_parms==1,
    tmpin=input('  continue? (0:skip, 1:yes): ');
    if isempty(tmpin), tmpin=1; end;
    if tmpin==0, tmpok=0; end;
  end;
  if tmpok,
    if do_sequential,
      for nn=1:nseq,
        disp(sprintf('  realign seq %d',nn));
        data(:,:,:,nn)=imMotApply(xx_motc(:,:,nn),data(:,:,:,nn),motc_parms,4);
      end;
      avgtc_motc=squeeze(mean(mean(data,1),2));
      avgim_motc=mean(data,3); stdim_motc=std(data,[],3);
     else,
      data=imMotApply(xx_motc,data,motc_parms,4);
      avgtc_motc=squeeze(mean(mean(data,1),2));
      avgim_motc=mean(data,3); stdim_motc=std(data,[],3);
    end;
    do_realign_done=1;
    if do_keepalldata,
      data_motc=data;
      eval(sprintf('save %s -append data_motc',sname));
      clear data_motc
    end;
    disp(sprintf('save %s -append data avgim_motc stdim_motc avgtc_motc do_realign_done',sname));
    eval(sprintf('save %s -append data avgim_motc stdim_motc avgtc_motc do_realign_done',sname));
  else,
    disp('  skipping realign, no significant motion detected...'),
    do_realign=0;
    do_realign_done=-1;
    eval(sprintf('save %s -append do_realign do_realign_done',sname));    
  end;
end;

if do_maskreg,
  disp('  do_maskreg...');
  if isempty(maskreg_parms),
    if do_sequential, tmpim=data(:,:,1,1); else, tmpim=data(:,:,1); end;
    mask_reg=bwlabel(selectMask(tmpim));
  else,
    mask_reg=maskreg_parms;
    clf, show(mask_reg), drawnow,
  end;
  if do_sequential,
    for nn=1:nseq, mask_reg_tc(nn)=getStkMaskTC(data(:,:,:,nn),mask_reg); end;
  else,
    mask_reg_tc=getStkMaskTC(data,mask_reg);
  end;
  eval(sprintf('print -dpng samplefig_%s_maskreg',saveid));
  clf, plot(mask_reg_tc(1).atc), axis('tight'), grid('on'), drawnow,
  xlabel('im#'), ylabel('maskreg roi intensity'),
  eval(sprintf('print -dpng samplefig_%s_maskregtc',saveid));
  do_maskreg_done=1;
  %disp(sprintf('save %s -append mask_reg mask_reg_tc do_maskreg_done',sname))
  eval(sprintf('save %s -append mask_reg mask_reg_tc do_maskreg_done',sname))
end;

if do_intc|do_maskreg,
  disp('  do_regress...');
  reg_mat=mask_reg_tc.atc;
  if ~exist('intc_parms','var'), intc_parms=[]; end;
  if isempty(intc_parms), intc_parms=1; end;
  if do_sequential,
    for nn=1:nseq,
    if do_motc,
      disp(sprintf('  do_regress_with_motion seq %d...',nn));
      [dataic(:,:,:,nn),xx_intc(nn)]=imMotReg(data(:,:,:,nn),xx_motc_seq(:,:,nn),intc_parms,reg_mat);
    else,
      [dataic(:,:,:,nn),xx_intc(nn)]=imMotReg(data(:,:,:,nn),[],intc_parms,reg_mat);
    end;
    end;
  else,
    if do_motc,
      disp('  do_regress_with_motion...');
      [dataic,xx_intc]=imMotReg(data,xx_motc,intc_parms,reg_mat);
    else,
      [dataic,xx_intc]=imMotReg(data,[],intc_parms,reg_mat);
    end;
  end;
  avgtc_intc=squeeze(mean(mean(dataic,1),2));
  avgim_intc=squeeze(mean(dataic,3)); stdim_intc=squeeze(std(dataic,[],3));
  figure(2), clf,
  plot(avgtc_intc), axis('tight'), grid('on'),
  xlabel('im#'), ylabel('dataic mean intensity'),
  eval(sprintf('print -dpng samplefig_%s_dataic_avgtc',saveid));
  
  %if do_keep_all, eval(sprintf('save %s -append dataic',sname)); end;
  data=dataic; clear dataic
  do_intc_done=1;
  if do_keepalldata,
    data_intc=data;
    eval(sprintf('save %s -append data_intc',sname));
    clear data_intc
  end;
  disp(sprintf('save %s -append data xx_intc intc_parms avgim_intc stdim_intc avgtc_intc do_intc_done',sname));
  eval(sprintf('save %s -append data xx_intc intc_parms avgim_intc stdim_intc avgtc_intc do_intc_done',sname));
end;

if do_bin,
  disp('  do bin...');
  if exist('dataic','var'),
    data_bin=volbin(dataic,bin_parms);
    clear dataic
  else,
    data_bin=volbin(data,bin_parms);
  end;
  avgtc_bin=squeeze(mean(mean(data_bin,1),2));
  avgim_bin=mean(data_bin,3); stdim_bin=std(data_bin,[],3);
  %eval(sprintf('save %s -append data_bin',saveid))
  data=data_bin; clear data_bin
  do_bin_done=1;
  if do_keepalldata,
    data_bin=data;
    eval(sprintf('save %s -append data_bin',sname));
    clear data_bin
  end;
  disp(sprintf('save %s -append data avgim_bin stdim_bin avgtc_bin bin_parms do_bin_done',sname));
  eval(sprintf('save %s -append data avgim_bin stdim_bin avgtc_bin bin_parms do_bin_done',sname));
end;

if do_ffilt,
  if isempty(ffilt_parms),
    ffilt_parms=[0.03 0.2 0.01 0.05 0.1];
  end;
  data_ffilt=data;
  for mm=1:size(data_ffilt,1), for nn=1:size(data_ffilt,2),
    tmptc=squeeze(data_ffilt(mm,nn,:));
    tmptcf=fermi1d(tmptc(:)-mean(tmptc),ffilt_parms(1:2),ffilt_parms(3:4),[-1 1],ffilt_parms(5));
    data_ffilt(mm,nn,:)=tmptcf;
  end; end;
  avgtc_ffilt=squeeze(mean(mean(data_ffilt,1),2));
  avgim_ffilt=mean(data_ffilt,3);
  stdim_ffilt=std(data_ffilt,[],3);
  if do_keepall,
    eval(sprintf('save %s -append data_ffilt',sname));
  end;
  data=data_ffilt;
  clear data_ffilt
  do_ffilt_done=1;
  disp(sprintf('save %s -append data avgim_ffilt stdim_ffilt avgtc_ffilt ffilt_parms do_ffilt_done',sname));
  eval(sprintf('save %s -append data avgim_ffilt stdim_ffilt avgtc_ffilt ffilt_parms do_ffilt_done',sname));
end;

if do_arfilt,
  % similar as above but use
  %arfilt_parms=[5];
  %tmptcf=myarfilt(tmptc(:)-mean(tmptc),arfilt_parms);
end;

if do_average,
  disp('  do average...');
  if isempty(average_parms),
    disp('  no average parameters found, skipping...');
  else,
    ddim=size(data);
    noff=average_parms(1);
    nimtr=average_parms(2);
    ntr=average_parms(3);
    if do_timing,
      adata=zeros(ddim(1),ddim(2),nimtr);
      for nn=1:ntr, adata=data(:,:,[1:nimtr]+timing_parms(nn)-1); end;
      adata=adata/ntr;
      avgtc_avg=squeeze(mean(mean(adata,1),2));
      do_average_done=1; do_timing_done=1;
      disp(sprintf('save %s -append adata avgtc_avg average_parms do_average_done',sname));
      eval(sprintf('save %s -append adata avgtc_avg average_parms do_average_done',sname));
      eval(sprintf('save %s -append timing_parms do_timing_done',sname));
    else,
      adata=mean(reshape(data(:,:,[1:nimtr*ntr]+noff-1),ddim(1),ddim(2),nimtr,ntr),4);
      avgtc_avg=squeeze(mean(mean(adata,1),2));
      avgim_avg=mean(adata,3); stdim_avg=std(adata,[],3);
      do_average_done=1;
      disp(sprintf('save %s -append adata avgim_avg stdim_avg avgtc_avg average_parms do_average_done',sname));
      eval(sprintf('save %s -append adata avgim_avg stdim_avg avgtc_avg average_parms do_average_done',sname));
    end;
  end;
end;

if do_timing,

end;

