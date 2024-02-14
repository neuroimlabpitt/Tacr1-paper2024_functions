function y=twop_imfilt(x,mfp,smp,hcf)
% Usage ... y=twop_imfilt(x,mfp,smp,hcf)

if ~exist('mfp','var'), mfp=[]; end;
if ~exist('smp','var'), smp=[]; end;
if ~exist('hcf','var'), hcf=-1; end;

if isempty(mfp), mfp=0; end;
if isempty(smp), smp=0; end;

xdim=size(x);
if length(mfp)==1; mfp=[mfp mfp]; end;

if nargout==0,
  if length(xdim)==4, x=x(:,:,:,1);
  else, x=x(:,:,1);
  end;
  xdim=size(x);
end;

y=x;
if length(xdim)==4,
  if hcf==-1,
    avgim=mean(x,4);
    hcim=ones(size(avgim));
  else
    avgim=mean(x,4);
    for oo=1:size(avgim,3),
      if length(hcf)==size(avgim,3),
        [avgimf(:,:,oo),hcim(:,:,oo)]=homocorOIS(avgim(:,:,oo),hcf(oo));
      elseif length(hcf)==1,
        [avgimf(:,:,oo),hcim(:,:,oo)]=homocorOIS(avgim(:,:,oo),hcf);
      elseif size(hcf,3)>1,
        hcim(:,:,oo)=hcf(:,:,oo);
      else,
        hcim(:,:,oo)=hcf;
      end;
    end;
  end;
  
  for nn=1:xdim(4), for mm=1:xdim(3),
    if mfp>0, y(:,:,mm,nn)=medfilt2(y(:,:,mm,nn),mfp); end;
    if smp>0, y(:,:,mm,nn)=im_smooth(y(:,:,mm,nn),smp); end;
    y(:,:,mm,nn)=hcim(:,:,mm).*y(:,:,mm,nn);
  end; end;
elseif length(xdim)==5,
  if hcf==-1,
    avgim=mean(x,5);
    hcim=ones(size(avgim));
  else
    avgim=mean(x,5);
    for oo=1:size(avgim,3), for pp=1:size(avgim,4),
      if length(hcf)==size(avgim,3),
        [avgimf(:,:,oo,pp),hcim(:,:,oo,pp)]=homocorOIS(avgim(:,:,oo,pp),hcf(oo));
      elseif length(hcf)==1,
        [avgimf(:,:,oo,pp),hcim(:,:,oo,pp)]=homocorOIS(avgim(:,:,oo,pp),hcf);
      elseif size(hcf,3)>1,
        hcim(:,:,oo,pp)=hcf(:,:,oo);
      else,
        hcim(:,:,oo,pp)=hcf;
      end;
    end; end;
  end;
  
  for oo=1:xdim(5), for nn=1:xdim(4), for mm=1:xdim(3),
    if mfp>0, y(:,:,mm,nn,oo)=medfilt2(y(:,:,mm,nn,oo),mfp); end;
    if smp>0, y(:,:,mm,nn,oo)=im_smooth(y(:,:,mm,nn,oo),smp); end;
    y(:,:,mm,nn,oo)=hcim(:,:,mm,nn).*y(:,:,mm,nn,oo);
  end; end; end;
else,
  if hcf==-1,
    avgim=mean(x,3);
    hcim=ones(size(avgim));
  else,
    avgim=mean(x,3);
    if length(hcf)==1,
      [avgimf,hcim]=homocorOIS(avgim,hcf);
    else,
      hcim=hcf;
    end;
  end;
  
  for mm=1:xdim(3),
    if mfp>0, y(:,:,mm)=medfilt2(y(:,:,mm),mfp); end;
    if smp>0, y(:,:,mm)=im_smooth(y(:,:,mm),smp); end;
    y(:,:,mm)=hcim.*y(:,:,mm);
  end;
end;

if nargout==0,
  show(y),
  drawnow,
  clear y
end;
