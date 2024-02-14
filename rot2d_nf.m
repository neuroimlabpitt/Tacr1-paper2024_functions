function y=rot2d_nf(im,rang,itype,rtype)
% Usage ... y=rot2d_nf(im,rang,itype,rtype)
%
% rang is [theta] in degrees (positive is CCW, rot2d_f is CW)
%   (based on imrotate; x=+elevates-left,y=+elevates-top)
% itype is interpolation type -- default is linear
% rtype is rotation option -- cropping is default

if ~exist('itype','var'), itype='bilinear'; end;
if ~exist('rtype','var'), rtype='crop'; end;

y=imrotate(im,rang,itype,rtype);

