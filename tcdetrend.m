function yd=tcdetrend(y,order,range,norm,do_warningoff)
% Usage ... yd=tcdetrend(y,order,range,norm,warningoff_flag)
%
% y must be in columns!


if size(y,1)==1,
  disp('warning: y should be in columns');
end;

if nargin<5, do_warningoff=0; end;
if nargin<4, norm=0; end;
if nargin<3, range=[1 size(y,1)]; end;
if nargin<2, order=1; end;

x=[1:size(y,1)]';
for m=1:size(y,2),
  xtofit=x(range(1):range(2));
  ytofit=y(range(1):range(2),m);
  if length(range)>2,
    for n=2:length(range)/2,
      xtofit=[xtofit;x(range(2*n-1):range(2*n))];
      ytofit=[ytofit;y(range(2*n-1):range(2*n),m)];
    end;
  end;
  if do_warningoff, warning('off'), end;
  pcoef=polyfit(xtofit,ytofit,order);
  yb=polyval(pcoef,x);
  if do_warningoff, warning('on'), end;
  if (norm),
    yd(:,m)=(y(:,m)-yb)./yb;
  else,
    yd(:,m)=y(:,m)-yb+mean(yb);
  end;
  if nargout==0,
    disp(sprintf('  displaying #%d',m));
    subplot(211)
    plot(x,y(:,m),x,yb)
    subplot(212)
    plot(x,yd(:,m))
    pause,
  end;
end;

