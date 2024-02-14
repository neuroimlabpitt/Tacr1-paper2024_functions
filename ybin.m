function y2=ybin(x,bsize)
% Usage ynew=ybin(x,binsize)

if bsize==1;
  y2=x;
  if nargout==0, show(y2), clear y2, end;
  return;
end

ydim=length(x);
iend1=floor(length(x)/bsize)*(bsize);

y=x(1:bsize:iend1);
%[bsize iend1 iend2],
for mm=2:bsize,
  y=y+x(mm:bsize:iend1);
end;
y2=y/bsize;

if nargout==0,
  plot([x(:) y(:)])
  clear y2
end;

