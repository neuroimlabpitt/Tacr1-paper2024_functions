function y=mysmooth(x,p1,p2,p3)
% Usage ... y=mysmooth(x,p1,p2,p3)
%
% Wrapper for Matlab's smooth function

if prod(size(x))==length(x), x=x(:); end;

y=x;
for mm=1:size(x,2);
  if nargin==2,
    y(:,mm)=smooth(x(:,mm),p1);
  elseif nargin==3,
    y(:,mm)=smooth(x(:,mm),p1,p2);
  elseif nargin==4,
    y(:,mm)=smooth(x(:,mm),p1,p2,p3);
  else,
    y(:,mm)=smooth(x(:,mm));
  end;
end;

