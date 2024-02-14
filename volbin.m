function y3=volbin(x,bsize)
% Usage y=volbin(x,binsize)

if bsize==1;
  y2=x;
  if nargout==0, show(y2), clear y2, end;
  return;
end

if length(bsize)==1,
  bsize=[bsize bsize bsize]; 
elseif length(bsize)==2,
  bsize=[bsize 1];
end;

imdim=size(x);
iend1=floor(imdim(1)/bsize(1))*(bsize(1));
iend2=floor(imdim(2)/bsize(2))*(bsize(2));
iend3=floor(imdim(3)/bsize(3))*(bsize(3));

y=x(1:bsize(1):iend1,:,:);
%[bsize iend1 iend2],
if bsize(1)>1, for mm=2:bsize(1),
  y=y+x(mm:bsize(1):iend1,:,:);
end; end;
y=y/bsize(1);
y2=y(:,1:bsize(2):iend2,:);
if bsize(2)>1, for mm=2:bsize(2),
  y2=y2+y(:,mm:bsize(2):iend2,:);
end; end;
y2=y2/bsize(2);
y3=y2(:,:,1:bsize(3):iend3);
if bsize(3)>1, for mm=2:bsize(3),
  y3=y3+y2(:,:,mm:bsize(3):iend3);
end; end;
y3=y3/bsize(3);

