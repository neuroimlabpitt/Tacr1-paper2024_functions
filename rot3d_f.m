function y=rot3d_f(x,ang)
% Usage ... y=rot3d_f(x,ang)
%
% ang=[x y z] in degrees
% (when using myangle functions, use the negative of the result as
% rotation angles)

ang=ang*pi/180;
y=zeros(size(x));

if abs(ang(1))>10*eps, for mm=1:size(x,1),
  a1=-tan(ang(1)/2);
  a2=sin(ang(1));
  a3=-tan(ang(1)/2);

  im0=squeeze(x(mm,:,:));
  im1=imshear2(im0,a1,1,1);
  im2=imshear2(im1,a2,1,2);
  im3=imshear2(im2,a3,1,1);
  y(mm,:,:)=im3;
end; end;

if abs(ang(2))>10*eps, for mm=1:size(x,2),
  a1=-tan(ang(2)/2);
  a2=sin(ang(2));
  a3=-tan(ang(2)/2);

  im0=squeeze(y(:,mm,:));
  im1=imshear2(im0,a1,1,1);
  im2=imshear2(im1,a2,1,2);
  im3=imshear2(im2,a3,1,1);
  y(:,mm,:)=im3;
end; end;

if abs(ang(3))>10*eps, for mm=1:size(x,3),
  a1=-tan(ang(3)/2);
  a2=sin(ang(3));
  a3=-tan(ang(3)/2);

  im0=y(:,:,mm);
  im1=imshear2(im0,a1,1,1);
  im2=imshear2(im1,a2,1,2);
  im3=imshear2(im2,a3,1,1);
  y(:,:,mm)=im3;
end; end;


% zero_flag here

