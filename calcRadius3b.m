function [x,yp_out,xi_mid,yi_mid]=calcRadius3b(proj,mii)
% Usage ... x=calcRadius3b(proj,mii)

if (nargin<2), mii=[]; end;

if (isempty(mii)),
  plen=length(proj);
  pleni=ceil(0.05*plen);
  %mii=[1 pleni+1 plen-pleni plen];
  mii=[1 2 plen-1 plen];
  mii_std0=std(proj(mii));
  if (plen>8),
    for mm=3:4,
      tmp_mii=[[1:mm] [plen-mm+1:plen]];
      %[std(proj(tmp_mii)) 1.25*mii_std0],
      if (std(proj(tmp_mii))<1.25*mii_std0),
        mii=tmp_mii;
      end;
    end;
  end;
  %disp(sprintf('  proj. baseline elem.= %d of %d',length(mii),plen));
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
[max_p,max_pi]=max(ypi);
min_pp=min_p-ypm;

fwhmy=min_p+0.5*abs(min_pp);
ii=find(ypi<fwhmy);
fwhmi=xi(ii(end))-xi(ii(1));
ctr=(xi(ii(end))+xi(ii(1)))/2;

x=[fwhmi min_pi min_pp ypm mp(1) max_pi max_pi ctr];
%x=[fwhmi min_pi min_pp ypm mp(1) fwhmi/sqrt(0.75)];

xi_mid=[xi(ii(1)) xi(ii(end))];
yi_mid=[ypi(ii(1)) ypi(ii(end))];

if (nargout==0)
  plot(xp,proj,xp,yp,xi,ypi,[xi(ii(1)) xi(ii(end))],[ypi(ii(1)) ypi(ii(end))],'o',xi([min_pi max_pi]),ypi([min_pi max_pi]),'o')
  title(sprintf('r=%.2f r0=%.2f a=%.3f b=%.3f m=%.3f ctr=%.2f',x(1),x(2),x(3),x(4),x(5),ctr));
end;

