function y=getStkMaskTC(stk,mask,norm,dparms,fparms)
% Usage ... y=getStkMaskTC(stk,mask,norm_or_#ims,dparms,fparms)
%
% Get time series from STK based on Mask
% Use range in norm for normalization
% dparms=[dord drange]
% fparms=[fco fw];

if nargin<5, fparms=[]; end;
if nargin<4, dparms=[]; end;
if nargin<3, norm=[]; end;

do_readfile=0;
if ischar(stk),
  do_readfile=1; 
  if strcmp(stk(end),'/'),
    do_readfile=3;
  %elseif strcmp(stk(end-3:end),'.tif'),
  %  do_readfile=3;
  elseif strcmp(stk(end-3:end),'.raw'),
    do_readfile=2;
  end;
end;

do_norm=1; do_det=1; do_filt=1;
if isempty(norm), do_norm=0; end;
if isempty(dparms), do_det=0; end;
if isempty(fparms), do_filt=0; end;

if iscell(mask),
  for mm=1:length(mask),
    tmpmask(:,:,mm)=int16(mask{mm});
  end;
  clear mask
  mask=tmpmask;
  clear tmpmask
  %size(mask),
end;


if (size(mask,3)>1),
  if max(max(sum(mask,3)))>1,
    do_manymasks=1;
  else,
    do_manymasks=0;
  end;
  if ~do_manymasks,
    tmpmask=uint16(mask(:,:,1));
    for mm=2:size(mask,3),
       tmpmask(find(mask(:,:,mm)))=mm;
    end;
    clear mask
    mask=tmpmask;
    clf, imagesc(mask), axis image, colorbar, drawnow,
  end;
else,
  do_manymasks=0;
end;

if do_manymasks,
  maskn=size(mask,3);
  nmaskn=sum(mask(:)>10*eps);
  for mm=1:maskn,
    tmpmaski{mm}=find(mask(:,:,mm)>10*eps);
    nmaski(mm)=1; %nmaski(mm)=length(tmpmaski{mm});
  end;
else,
  tmpcnt=0; nmaski=[];
  for mm=1:max(double(mask(:))),
    tmpi=find(mask==mm);
    if ~isempty(tmpi),
      tmpcnt=tmpcnt+1;
      nmaski(tmpcnt)=mm;
    end;
  end;
  maskn=tmpcnt;
  for nn=1:maskn,
    tmpmaski{nn}=find(mask==nmaski(nn));
  end;
end;

%maskn=max(double(mask(:)));
if do_readfile==1,
  fname=stk; clear stk
  tmpinfo=imfinfo(fname);
  stkdim(1:2)=[tmpinfo.Width tmpinfo.Height];
  stkdim(3)=length(tmpinfo.UnknownTags(3).Value);
  disp(sprintf('  stk dim= %d %d %d',stkdim(1),stkdim(2),stkdim(3)));
elseif do_readfile==2,
  fname=stk; clear stk
  [tmpim,tmp2,tmpinfo]=readOIS(fname);
  stkdim=[size(tmpim,1) size(tmpim,2) tmpinfo.nfr];
  disp(sprintf('  stk dim= %d %d %d',stkdim(1),stkdim(2),stkdim(3)));
else,
  stkdim=size(stk);
end;
if (size(mask,1)~=stkdim(1))&(size(mask,2)~=stkdim(2)),
  warning(' image and stk dimensions do not match...');
end;

atc=zeros(stkdim(3),maskn);
stc=atc;

if length(stkdim)==4,
  for mm=1:stkdim(4), for oo=1:stkdim(3),
    tmpim=stk(:,:,oo,mm);
    if mm==1, 
      tmpsz1=size(tmpim); 
      tmpsz2=size(mask); 
      disp(sprintf('  im(%d,%d) mask(%d,%d)',tmpsz1(1),tmpsz1(2),tmpsz2(1),tmpsz2(2))); 
    end;
    for nn=1:maskn,
      atc(mm,nn,oo)=mean(tmpim(tmpmaski{nn}));
      stc(mm,nn,oo)=std(tmpim(tmpmaski{nn}));
    end;
  end; end;
else,
  for mm=1:stkdim(3),
    if do_readfile,
      tmpim=readOIS3(fname,mm);
    else,
      tmpim=stk(:,:,mm);
    end;
    if mm==1, 
      tmpsz1=size(tmpim); 
      tmpsz2=size(mask); 
      disp(sprintf('  im(%d,%d) mask(%d,%d)',tmpsz1(1),tmpsz1(2),tmpsz2(1),tmpsz2(2))); 
    end;
    for nn=1:maskn,
      atc(mm,nn)=mean(tmpim(tmpmaski{nn}));
      stc(mm,nn)=std(tmpim(tmpmaski{nn}));
    end;
  end;
end;

if do_det,
  if length(stkdim)==4,
    for mm=1:maskn, for oo=1:stkdim(3),
      atc(:,mm,oo)=tcdetrend(atc(:,mm,oo),dparms(1),dparms(2:end),0);
    end; end;
  else,
    for mm=1:maskn,
      atc(:,mm)=tcdetrend(atc(:,mm),dparms(1),dparms(2:end),0);
    end;
  end;
end;

if do_filt,
  if length(stkdim)==4,
    for mm=1:maskn, for oo=1:stkdim(3),
      atc(:,mm,oo)=fermi1d(atc(:,mm,oo),fparms(1),fparms(2),fparms(3),fparms(4));
    end; end;
  else,
    for mm=1:maskn,
      atc(:,mm)=fermi1d(atc(:,mm),fparms(1),fparms(2),fparms(3),fparms(4));
    end;
  end;
end;

if do_norm,
  if length(norm)==2, tmpni=[norm(1):norm(2)]; else, tmpni=norm; end;
  if length(stkdim)==4,
    for mm=1:maskn, for oo=1:stkdim(3),
      atc_n(mm,oo)=mean(atc(tmpni,mm,oo),1); 
      atc(:,mm,oo)=atc(:,mm,oo)/atc_n(mm,oo);
    end; end;
  else,
    for mm=1:maskn,
      atc_n(mm)=mean(atc(tmpni,mm),1); 
      atc(:,mm)=atc(:,mm)/atc_n(mm);
    end;
  end;
end;

y.mask=mask;
y.nmaski=nmaski;
y.atc=atc;
y.stc=stc;
if do_det, y.dparms=dparms; end;
if do_filt, y.fparms=fparms; end;
if do_norm, y.nparms=norm; y.tc0=atc_n; end;

clear tmp*


