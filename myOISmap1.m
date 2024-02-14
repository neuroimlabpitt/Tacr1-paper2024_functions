function y=myOISmap1(data,parms,sparms,tparms)
% Usage ... y=myOISmap1(data,parms,sparms,tparms_or_mask_apply)
%
% parms = [ntrials,nimtr,noff]
% stim_parms = [nimstim nskp]
% tc_parms = [thr mincthr maxcthr smw maskflag]

do_figure=1;
do_applymask=0;

if nargin<4, tparms=[]; end;
if nargin<3, sparms=[]; end;

if isstruct(parms),
  if ~isempty(sparms),
    if ischar(sparms), if strcmp(sparms,'apply'),
      disp('  applying mask in map structure...');
      do_applymask=2;
    end; end;
  end;
  maps_orig=parms;
  sparms=parms.stim_parms;
  tparms=parms.tc_parms;
  pparms=parms.parms;
  parms=pparms;
end;

if length(tparms)>10,
  do_applymask=1; 
  maskA=tparms;
  tparms=[];
end;

if do_applymask==2,
  disp('  xferring mask');
  maskA=xferMask1(maps_orig.mask,maps_orig.bim,data(:,:,1));
end;

ntr=parms(1);
nimtr=parms(2);
noff=parms(3);
nstim=sparms(1);
nskp=sparms(2);

adata=mean(reshape(data(:,:,[1:nimtr*ntr]+noff-1),...
    size(data,1),size(data,2),nimtr,ntr),4);

bim=mean(adata(:,:,1:nstim-1),3);
aim=mean(adata(:,:,nskp+[1:nstim]),3);

map=(aim./bim-1);

if do_applymask==0,
    athr=tparms(1:3);
    smw=tparms(4);
    mflag=tparms(5);
    
    if smw>0, tmpim=im_smooth(map,smw); end;
    if athr(1)<0, tmpim=-1*tmpim; end;
    
    mask=im_thr2(tmpim,abs(athr(1)),athr(2:3));
    mask=mask>0;

    mask=bwlabel(mask);
    if max(mask(:))>1, mflag=3; end;
    
    if mflag==1,
        clf, show(map), drawnow,
        disp('  select mask...');
        maskB=roipoly;
        mask=mask.*maskB;
    elseif mflag==2,
        mask=selectMask(map);
    elseif mflag==3,
        disp('  multiple regions found, select one...');
        clf, show(im_super(map,mask>0,0.5)), drawnow;
        [tmpx,tmpy]=ginput(1); tmpx=round(tmpx); tmpy=round(tmpy);
        tmpsel=mask(tmpy,tmpx);
        mask=(mask==tmpsel);
        disp(sprintf('  selected region %d, press enter...',tmpsel));
        clf, show(mask), drawnow, pause,
    end;

    for mm=1:size(adata,3), atc(mm)=sum(sum(adata(:,:,mm).*mask)); end;
    atc=atc/sum(sum(mask));
    atcn=atc/mean(atc(1:noff))-1;

    cref=atcn;
    %cref=zeros(size(adata,3),1); 
    %cref([1:nstim]+nskp)=1;    
    cmap=OIS_corr2(adata,cref);
    tmpim=cmap;
    if smw>0, tmpim=im_smooth(tmpim,smw); end;
    cmask=im_thr2(tmpim,0.71*max(tmpim(:)),athr(2));
    
    for mm=1:size(adata,3), catc(mm)=sum(sum(adata(:,:,mm).*cmask)); end;
    catc=catc/sum(sum(cmask));
    catcn=catc/mean(catc(1:noff))-1;
else,
    mask=maskA;
    for mm=1:size(adata,3), atc(mm)=sum(sum(adata(:,:,mm).*mask)); end;
    atc=atc/sum(sum(mask));
    atcn=atc/mean(atc(1:noff))-1;

    cref=atcn;
    %cref=zeros(size(adata,3),1); 
    %cref([1:nstim]+nskp)=1;    
    cmap=OIS_corr2(adata,cref);
end;

y.parms=parms;
y.stim_parms=sparms;
y.tc_parms=tparms;
y.bim=bim;
y.aim=aim;
y.map=map;
y.adata=adata;
if (~isempty(tparms))|do_applymask,
    y.mask=mask;
    y.atc=atc;
    y.atcn=atcn;
    y.cref=cref;
    y.cmap=cmap;
    %y.cmask=cmask;
    %y.catc=catc;
    %y.catcn=catcn;
end;

if nargout==0, do_figure=1; end;

if do_figure,
  if ~isempty(tparms),
      clf,
      subplot(221), show(map), xlabel('Map'),
      subplot(222), show(mask), xlabel('Mask'),
      subplot(212), plot(atcn), ylabel('Avg. Amplitude'), 
      print -dpng tmp_map1
  else,
      clf, show(map)
  end;
  drawnow,
  if nargout==0,
      clear y
  end;
end;
