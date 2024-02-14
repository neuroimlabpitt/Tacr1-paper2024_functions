function y=stkFilt(x,type,parms)
% Usage ... y=stkFilt(x,type,parms)
%
% Filter the stack using type and paramaters parms
%
% Example for median and smoothing filter of all images 
%   y=stkFilt(stk,'image',[3 0.6]);
% Example of time filtering
%   y=stkFilt(stk,'fermi',{[0.02 0.2],[0.005 0.04],[-1 1],0.1});

xdim=size(x);
y=x;

if strcmp(type,'median'), type='image'; mfp=parms; parms=[parms 0]; end;
if strcmp(type,'smooth'), type='image'; parms=[0 parms]; end;
if strcmp(type,'flat')|strcmp(type,'homocor'), type='image'; hcf=parms; end;

if strcmp(type,'image')|strcmp(type,'spatial'),
  if isempty(parms), 
      mfp=3; smp=0.6;
  else,
      mfp=parms(1); smp=parms(2);
  end;

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
elseif strcmp(type,'fermi')|strcmp(type,'temporal'),
  if ~isempty(parms),
    yf=y;
    for mm=1:xdim(1), for nn=1:xdim(2),
      yf(mm,nn,:)=fermi1d(squeeze(y(mm,nn,:)),parms{1},parms{2},parms{3},parms{4});
    end; end;
    y=yf; clear yf
    %for mm=1:xdim(1),
    %  y(mm,:,:)=fermi1d(squeeze(y(mm,:,:)),parms{1},parms{2},parms{3},parms{4});
    %end;
    %yf=fermi1d(reshape(y,[xdim(1)*xdim(2) xdim(3)]),parms{1},parms{2},parms{3},parms{4});
    %y=reshape(yf,xdim);
    %clear yf
  end;
end;

 
