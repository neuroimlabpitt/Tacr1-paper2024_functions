function y=normch(x,xmin,xmax)
% Usage ... y=normch(x,min,max)
%
% Takes x and returns it with range from 0 to 1 or from min to max

if (prod(size(x))==length(x)),
  x=x(:);
end;
ncol=size(x,2);

if (~exist('xmin')),
  xmin=[];
end;
if (~exist('xmax')),
  xmax=[];
end;

if (isempty(xmin)),
  xmin=min(x);
end;
if (isempty(xmax)),
  xmax=max(x);
end;

if (ncol>1)&(length(xmin)==1),
  xmin=ones(1,ncol)*xmin;
end;
if (ncol>1)&(length(xmax)==1),
  xmax=ones(1,ncol)*xmax;
end;

for mm=1:ncol,
  xrange(mm)=xmax(mm)-xmin(mm);
  y(:,mm)=(x(:,mm)-xmin(mm))/xrange(mm);
end;

