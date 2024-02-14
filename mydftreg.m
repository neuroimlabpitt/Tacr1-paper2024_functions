function [xx,yc]=mydftreg(im,refim,parms)
% Usage ... [x,imc]=mydftreg(im,refim,parms)
%
% parms=[scalef smwid]

upscalef=parms(1);
smw=parms(2);
if nargout==0, verbflag=1; else, verbflag=0; end;
if length(parms)==3, verbflag=parms(3); end;

for mm=1:size(im,3),
  im1=refim;
  im2=im(:,:,mm);
  if smw>0,
    im1=im_smooth(im1,smw);
    im2=im_smooth(im2,smw);
  end;
  [dftout,dftgreg]=dftregistration(fft2(im1),fft2(im2),upscalef);
  xx(mm,:)=[dftout(3:4)];
  yc(:,:,mm)=abs(ifft2(dftgreg));
  if verbflag,
    subplot(221), show(im1),
    subplot(222), show(yc(:,:,mm)),
    subplot(223), show(im1),
    subplot(224), if smw>0, show(im_smooth(im(:,:,mm),smw)), else, show(im(:,:,mm)), end;
    drawnow,
  end;
end;

