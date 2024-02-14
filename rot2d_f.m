function y=imrot2d_f(x,ang)
% Usage ... y=imrot2d_f(x,ang)

ang=ang*pi/180;
a1=-tan(ang/2);
a2=sin(ang);
a3=-tan(ang/2);

im1=imshear2(x,a1,1,1);
im2=imshear2(im1,a2,1,2);
im3=imshear2(im2,a3,1,1);

y=im3;

% zero_flag here
