function a=myangle2(dx,dy)
% Usage ... a=myangle(dx,dy)

if (nargin==1),
  a=atan((dx(2,2)-dx(1,2))/(dx(2,1)-dx(1,1)));
elseif (nargin==0),
  gcf;
  disp('click on two positions...')
  dx=round(ginput(2));
  a=atan((dx(2,2)-dx(1,2))/(dx(2,1)-dx(1,1)));
  disp(sprintf('angle= %.2f (%.2f)',a*180/pi,a*180/pi+90));
else,
  a=atan(dy/dx);
end;

a=a*(180/pi);

