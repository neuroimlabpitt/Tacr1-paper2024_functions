function [xx,yc]=mydftreg_vol(im,refim,parms)
% Usage ... [x,imc]=mydftre_volg(vol,volref,parms)
%
% parms=[scalef smwid]

upscalef=parms(1);
smw=parms(2);
if nargout==0, verbflag=1; else, verbflag=0; end;
if length(parms)==3, verbflag=parms(3); end;

for mm=1:size(im,4),
  im1=refim;
  im2=im(:,:,:,mm);
  if smw>0,
    im1=vol_smooth(im1,smw);
    im2=vol_smooth(im2,smw);
  end;
  [dftout,dftgreg]=dftregistration_vol(fftn(im1),fftn(im2),upscalef);
  xx(mm,:)=[dftout(3:5)];
  yc(:,:,:,mm)=abs(ifftn(dftgreg));
  if verbflag,
    figure(1), showProj(im1),
    figure(2), showProj(yc(:,:,:,mm)),
    figure(3), show(im1),
  end;
end;

