function a=tile3d(b,minmax,bar_flag,transp_flag,dim_flag,axis_flag)
% Usage ... a=tile3d(b,minmax,bar_flag,transp_flag,dim_flag,axis_flag)

if ~exist('dim_flag','var'), dim_flag=[]; end;
if ~exist('minmax','var'), minmax=[]; end;
if ~exist('bar_flag','var'), bar_flag=[]; end;
if ~exist('transp_flag','var'), transp_flag=[]; end;
if ~exist('axis_flag','var'), axis_flag=[]; end;

if isempty(bar_flag), bar_flag=0; end;
if isempty(transp_flag), transp_flag=0; end;
if isempty(axis_flag), axis_flag=0; end;

if axis_flag(1)~=0, b=b(axis_flag(1):axis_flag(2),axis_flag(3):axis_flag(4),:); end;

if (ndims(b)<3), a=b; return; end;

c=size(b);
if isempty(dim_flag),
  x1=ceil(sqrt(c(3)));
  x2=x1;
else,
  x1=dim_flag(1);
  x2=dim_flag(2);
end;

a1=zeros(c(1),c(2),x1*x2);
a1(:,:,1:c(3))=b;

tmp=sprintf('a=[');
for mm=1:x1,
  cc=0;
  for nn=1:x2,
    cc=cc+sum(sum(a1(:,:,(mm-1)*x1+nn)));
  end;
  %cc,
  if (cc==0), dothisrow=0; else, dothisrow=1; end;
  if (dothisrow),
    for nn=1:x2,
      if transp_flag==1,
        tmp=sprintf('%s a1(:,:,%d)''',tmp,(mm-1)*x1+nn);
      elseif transp_flag==2,
        tmp=sprintf('%s flipud(a1(:,:,%d))',tmp,(mm-1)*x1+nn);
      elseif transp_flag==4,
        tmp=sprintf('%s flipud(fliplr(a1(:,:,%d)))',tmp,(mm-1)*x1+nn);
      elseif transp_flag==-1,
        tmp=sprintf('%s fliplr(a1(:,:,%d))',tmp,(mm-1)*x1+nn);
      else,    
        tmp=sprintf('%s a1(:,:,%d)',tmp,(mm-1)*x1+nn);
      end;
    end;
  end;
  tmp=sprintf('%s;',tmp);
end;
tmp=sprintf('%s];',tmp);
%disp(tmp);
eval(tmp);
clear a1

%a1=reshape(b(:,:,1:ceil(c(3)/2)),[c(1) c(2)*ceil(c(3)/2)]);
%a2=reshape(b(:,:,ceil(c(3)/2)+1:end),[c(1) c(2)*ceil(c(3)/2)]);
%a=reshape(b,[c(1) c(2)*c(3)]);

if isempty(minmax), minmax=[min(a(:)) max(a(:))]; end;

if nargout==0,
  if (nargin<2),
    %show(a)
    imagesc(a)
  else,
    %show(a,minmax)
    %a=minmax(1)*(a<minmax(1))+minmax(2)*(a>minmax(2))+a.*((a>minmax(1))&(a<minmax(2)));
    imagesc(a,minmax)
  end;
  axis('image');
  axis('off'); 
  title(' ');
  if bar_flag, colorbar, end;
  clear a
end;

