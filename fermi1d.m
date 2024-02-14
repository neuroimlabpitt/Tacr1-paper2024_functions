function [yy,ff]=fermi1d(y,co,wid,amp,dt)
% Usage ... y=fermi1d(y,co,wid,amp,dt)
%
% Ex. fermi1d(y,10,10,1);

if ~exist('amp'), amp=[]; end;
if isempty(amp), amp=1; end;

if exist('dt','var'),
  df=(1/length(y))*(1/dt);
  co=round(co/df);
  wid=round(wid/df);
  wid(find(wid==0))=1;
  disp(sprintf('  actual cutoff = %f (%f)',co*df,wid*df));
end;

ii=[1:length(y)]'-1;
tmpi=fftshift(ii);
tmp0=find(tmpi==0);
ii=ii-ii(tmp0);

ff=zeros(length(y),1);
for mm=1:length(co),
  ff0=1./(1+exp((abs(ii)-co(mm))/wid(mm)));
  if amp(mm)<0,
    ff0=1-abs(amp(mm)).*ff0;
  else,
    ff0=amp(mm).*ff0;
  end;
  if mm==1, ff=ff0; else, ff=ff.*ff0; end;
end;
ff=fftshift(ff);

yy=zeros(size(y));
for mm=1:size(y,2),
  yf=fft(y(:,mm));
  yff=yf.*ff;
  yy(:,mm)=ifft(yff);
  clear yf yff
end;
if isreal(y), yy=real(yy); end;

if nargout==0,
  subplot(311),
  plot([1:length(y)],[abs(fft(y(:,1)-mean(y(:,1))))])
  subplot(312),
  plot(ii(:),[fftshift(ff(:))])
  subplot(313),
  plot([1:length(y)],[y(:,1) yy(:,1)])
end;

