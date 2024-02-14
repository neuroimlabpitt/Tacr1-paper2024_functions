function vv=rot3d_nf(vol,rang,itype,rtype)
% Usage ... v=rot3d_nf(vol,rang,itype,rtype)
%
% rang is [x y z] in degrees (positive is CCW, rot2d_f is CW)
%   (based on imrotate; x=+elevates-left,y=+elevates-top)
% itype is interpolation type -- default is linear
% rtype is rotation option -- cropping is default

if ~exist('itype','var'), itype='bilinear'; end;
if ~exist('rtype','var'), rtype='crop'; end;

vv=vol;
if rang(3)~=0, for mm=1:size(vol,3),
  vv(:,:,mm)=imrotate(vol(:,:,mm),rang(3),itype,rtype);
end; end;
if rang(1)~=0, for mm=1:size(vol,1),
  vv(mm,:,:)=imrotate(squeeze(vv(mm,:,:)),rang(1),itype,rtype);
end; end;
if rang(2)~=0, for mm=1:size(vol,2),
  vv(:,mm,:)=imrotate(squeeze(vv(:,mm,:)),rang(2),itype,rtype);
end; end;

