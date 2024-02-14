function y2=ybin(x,bsize)
% Usage ynew=ybin(x,binsize)

if bsize==1;
  y2=x;
  if nargout==0, show(y2), clear y2, end;
  return;
end

if prod(size(x))==length(x), x=x(:); end;

ydim=size(x,1);
iend1=floor(ydim/bsize)*(bsize);

if size(x,2)>1,
  y=x(1:bsize:iend1,:);
  %[bsize iend1 iend2],
  for mm=2:bsize,
    y=y+x(mm:bsize:iend1,:);
  end;
  y2=y/bsize;
else,
  y=x(1:bsize:iend1);
  %[bsize iend1 iend2],
  for mm=2:bsize,
    y=y+x(mm:bsize:iend1);
  end;
  y2=y/bsize;
end;

if nargout==0,
  plot([x(:) y(:)])
  clear y2
end;

