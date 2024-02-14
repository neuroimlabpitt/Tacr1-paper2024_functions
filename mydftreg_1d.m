function [xx,yc]=mydftreg_1d(im,refim,parms)
% Usage ... [x,imc]=mydftreg_1d(im,refim,parms)
%
% parms=[scalef smwid]

upscalef=parms(1);
smw=parms(2);
if nargout==0, verbflag=1; else, verbflag=0; end;
if length(parms)==3, verbflag=parms(3); end;

for mm=1:size(im,3),
  im1=refim;
  im2=im(:,mm);
  if smw>0,
    im1=smooth1d(im1,smw);
    im2=smooth1d(im2,smw);
  end;
  [dftout,dftgreg]=dftregistration_1d(fft(im1),fft(im2),upscalef);
  xx(mm)=[dftout(3)];
  yc(:,mm)=abs(ifft(dftgreg));
  if verbflag,
    subplot(221), plot(im1),
    subplot(222), plot(yc(:,mm)),
    subplot(223), plot(im1),
    subplot(224), if smw>0, plot(smooth1d(im(:,mm),smw)), else, plot(im(:,mm)), end;
    disp(sprintf('  shift= %.3f',dftout(3)));
    drawnow,
  end;
end;

