function [x,yp_out,xi_mid,yi_mid]=calcRadius3b_up(proj,mii)
% Usage ... x=calcRadius3b_up(proj)

if (nargin<2), mii=[]; end;

xp=[1:length(proj)];
yp=proj;
xi=[1:0.01:length(proj)];
ypi=interp1(xp,yp,xi,'spline');

% get overall max
[max_p,max_pi]=max(ypi);

% look into the left side of the max
min1=min(ypi(1:max_pi));
ypi1=ypi-min1;
max1=max(ypi1);
ypi1n=ypi1/max1;

% look into the right side from the max
min2=min(ypi(max_pi:end));
ypi2=ypi-min2;
max2=max(ypi2);
ypi2n=ypi2/max2;

tmpi1=find(ypi1n>=0.5);
if isempty(tmpi1)|(sum(isnan(ypi1n))>0), fwhm1=0; else, fwhm1=xi(tmpi1(end))-xi(tmpi1(1)); end;
tmpi2=find(ypi2n>=0.5);
if isempty(tmpi2)|(sum(isnan(ypi2n))>0), fwhm2=0; else, fwhm2=xi(tmpi2(end))-xi(tmpi2(1)); end;

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

mp=polyfit(xp(mii),proj(mii),1);
yp=polyval(mp,xp);
yp=proj-yp+mean(yp);
max3=max(yp);
min3=mean(yp(mii));
ypn=yp-min3; 
max3b=max(ypn);
ypn=ypn/max3b;
ypi=interp1(xp,ypn,xi,'spline');

ii=find(ypi>=0.5);
if isempty(ii), fwhm3=0; else, fwhm3=xi(ii(end))-xi(ii(1)); end;

% [overall_max overall_maxi max1_left max2_right max3_all min1_left
% min1_right fwhm_left fwhm_right fwhm_all]
x=[max_p xi(max_pi) max1 max2 max3 min1 min2 min3 fwhm1 fwhm2 fwhm3];


if (nargout==0)
  subplot(311)
  plot(xi,ypi1)
  subplot(312)
  plot(xi,ypi2)
  subplot(313)
  plot(xi,ypi)
end;

