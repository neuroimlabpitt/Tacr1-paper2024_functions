function [xr2,yr]=calcRadius2b(proj,parms2fit,xg0,penalty)
% Usage ... xr=calcRadius2b(proj,parms2fit,xg0,penalty)
%

% This function is intended for use with cylprojy2, both of which
% have additional parameters to account for fluorescence data and/or
% high-cross sectioning objectives (i.e. 16x or higher).
% To use for fluorescence include parameters 7 and 8
% To use for high-sectioning objectives include parameter 6


% fit y
y=proj;


if nargin<4, penalty=[]; end;
if nargin<3, xg0=[]; end;
if nargin<2, parms2fit=[]; end;

if isempty(xg0),
  rad0=length(y)/2;
  xg0=[length(y)*0.3 rad0 -0.5*(max(y)-min(y)) 0.95*max(y) 0 0 0 0];
  xub=[4*length(y) length(y) -1e-10 max(y) +0.1*max(y) 1000 0.75*length(y) 0];
  xlb=[1e-10 1 -max(y) 1.001*min(y) -0.1*max(y) 0 1e-10 -1];
  %disp(sprintf('  %.2f %.2f %.2f %.2f %.4f %.4f %.2f %.4f',xg0(1),xg0(2),xg0(3),xg0(4),xg0(5),xg0(6),xg0(7),xg0(8)));
  %disp(sprintf('  %.2f %.2f %.2f %.2f %.4f %.4f %.2f %.4f',xlb(1),xlb(2),xlb(3),xlb(4),xlb(5),xlb(6),xlb(7),xlb(8)));
  %disp(sprintf('  %.2f %.2f %.2f %.2f %.4f %.4f %.2f %.4f',xub(1),xub(2),xub(3),xub(4),xub(5),xub(6),xub(7),xub(8)));
else,
  if (penalty==0),
    xub=[4*length(y) length(y) -1e-10 max(y) +0.1*max(y) 1000 2*length(y) 1];
    xlb=[1e-10 1 -max(y) 1.001*min(y) -0.1*max(y) 0 1e-10 0];
  else,
    if (length(penalty)<=1),
      penalty=[3.0 4.0 50.0 1.25 2.0 10.0 4.0 5.0];
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
  parms2fit=[1 2 3 4 5 6 7 8];
end;


opt2=optimset('lsqnonlin');
opt2.TolFun=1e-10;
opt2.TolX=1e-10;
opt2.MaxIter=1000;
opt2.MaxFunEvals=5000;

x=[1:length(y)];
xr=lsqnonlin(@cylprojy2,xg0(parms2fit),xlb(parms2fit),xub(parms2fit),opt2,xg0,parms2fit,x,y,0);
yr=cylprojy(xr,xg0,parms2fit,x);
xr2=xg0; xr2(parms2fit)=xr;


if (nargout==0),
  plot(x,y,x,yr)
  xr2,
end;

