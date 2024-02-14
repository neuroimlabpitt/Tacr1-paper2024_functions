function xm=mymode(y,nbins,nlook)
% Usage x=mymode(y,nbins,nlook)

if nargin==1, nbins=100; nlook=2; end;
if nargin==2, nlook=2; end;

if prod(size(y))==length(y), y=y(:); end;

for mm=1:size(y,2),
  [nn,xx]=hist(y(:,mm),nbins);
  [tmpmax,tmpmaxi]=max(nn);
  xm(mm)=xx(tmpmaxi);
  if (tmpmaxi>nlook)|(tmpmaxi<(length(nn)-nlook)),
    tmpp=polyfit(xx(tmpmaxi+[-nlook:nlook]),nn(tmpmaxi+[-nlook:nlook]),2);
    tmpy=1;
  end;
end;

if nargout==0,
  subplot(211),
  plot(y)
  subplot(212),
  plot(xx,nn,xm,nn(tmpmaxi),'o'),
end

