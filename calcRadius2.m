function [xr2,yr]=calcRadius2(proj,parms2fit,xg0,penalty)
% Usage ... xr=calcRadius2(proj,parms2fit,xg0,penalty)
%


% fit y
y=proj;


if nargin<4, penalty=[]; end;
if nargin<3, xg0=[]; end;
if nargin<2, parms2fit=[]; end;

if isempty(xg0),
  rad0=length(y)/2;
  xg0=[length(y)*0.3 rad0 -0.5*(max(y)-min(y)) 0.95*max(y) 0];
  xub=[4*length(y) length(y) -1e-10 max(y) +0.1*max(y)];
  xlb=[1e-10 1 -max(y) 1.001*min(y) -0.1*max(y)];
else,
  if (penalty==0),
    xub=[4*length(y) length(y) -1e-10 max(y) +0.1*max(y)];
    xlb=[1e-10 1 -max(y) 1.001*min(y) -0.1*max(y)];
  else,
    if (length(penalty)<=1),
      penalty=[3.0 4.0 50.0 1.25 2.0];
    end;
    if (xg0(3)<0), penalty(3)=1/penalty(3); end;
    if (xg0(5)<0), penalty(5)=1/penalty(5); end;
    xub=xg0.*penalty;
    xlb=xg0.*(1./penalty);
    xub(2)=xg0(2)+penalty(2);
    xlb(2)=xg0(2)-penalty(2);
  end;
end;
%[xg0;xlb;xub],

if isempty(parms2fit),
  parms2fit=[1 2 3 4 5];
end;


opt2=optimset('lsqnonlin');
opt2.TolFun=1e-10;
opt2.TolX=1e-10;
opt2.MaxIter=1000;
opt2.MaxFunEvals=5000;

x=[1:length(y)];
xr=lsqnonlin(@cylprojy,xg0(parms2fit),xlb(parms2fit),xub(parms2fit),opt2,xg0,parms2fit,x,y,0);
yr=cylprojy(xr,xg0,parms2fit,x);
xr2=xg0; xr2(parms2fit)=xr;


if (nargout==0),
  plot(x,y,x,yr)
  xr2,
end;

