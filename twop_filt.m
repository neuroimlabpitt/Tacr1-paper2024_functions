function y=twop_imfilt(x,mfp,smp)
% Usage ... y=twop_imfilt(x,mfp,smp)

if ~exist('mfp','var'), mfp=[]; end;
if ~exist('smp','var'), smp=[]; end;

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
  for nn=1:xdim(4), for mm=1:xdim(3),
    if mfp>0, y(:,:,mm,nn)=medfilt2(y(:,:,mm,nn),mfp); end;
    if smp>0, y(:,:,mm,nn)=im_smooth(y(:,:,mm,nn),smp); end;
  end; end;
else,
  for mm=1:xdim(3),
    if mfp>0, y(:,:,mm)=medfilt2(y(:,:,mm),mfp); end;
    if smp>0, y(:,:,mm)=im_smooth(y(:,:,mm),smp); end;
  end;
end;

if nargout==0,
  show(y),
  drawnow,
  clear y
end;