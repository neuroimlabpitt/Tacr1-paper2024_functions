function [x,yp_out]=calcRadius3(proj,mii)
% Usage ... x=calcRadius3(proj,mii)

if (nargin<2), mii=[]; end;

if (isempty(mii)),
  mii=[1:length(proj)];
end;

xp=[1:length(proj)];
mp=polyfit(xp(mii),proj(mii),1);
yp=polyval(mp,xp);
yp_out=proj./yp;

ypm=mean(yp);
yp=proj-yp+ypm;

xi=[1:0.01:length(proj)];
ypi=interp1(xp,yp,xi,'spline');

[min_p,min_pi]=min(ypi);
min_pp=min_p-ypm;

fwhmy=min_p+0.5*abs(min_pp);
ii=find(ypi<fwhmy);
fwhmi=xi(ii(end))-xi(ii(1));

x=[fwhmi min_pi min_pp ypm mp(1)];

if (nargout==0)
  plot(xp,proj,xp,yp,xi,ypi)
  title(sprintf('r=%f r0=%f a=%f b=%f m=%f',x(1),x(2),x(3),x(4),x(5)));
end;

