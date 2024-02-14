function y=calcRadius4(anatim,maskim,rotangle,mii)
% Usage ... y=calcRadius4(anatim,maskim,angle,mii)


[i1,i2]=find(maskim);
cropim=anatim(min(i1):max(i1),min(i2):max(i2));
cropmsk=maskim(min(i1):max(i1),min(i2):max(i2));

if (rotangle~=0),
  rotim=imrotate(cropim.*cropmsk,rotangle,'bilinear');
else,
  rotim=cropim;
end;
tmpmin=min(min(cropim));
tmpmax=max(max(cropim));
minthr=1.00*tmpmin;
maxthr=1.00*tmpmax;
rotim2=rotim.*((rotim>=minthr)&(rotim<=maxthr));
tmpproj=sum(rotim2)./sum(rotim2>=minthr);
proj=tmpproj(find((tmpproj>=minthr)&(tmpproj<=maxthr)));

if nargout==0,
  rot_sweep=10;
  rotangle_sweep=[rotangle-rot_sweep:rotangle+rot_sweep];
  for mm=1:length(rotangle_sweep),
    if (rotangle_sweep(mm)~=0),
      rotim=imrotate(cropim.*cropmsk,rotangle_sweep(mm),'bilinear');
    else,
      rotim=cropim;
    end;
    tmpmin=min(min(cropim));
    tmpmax=max(max(cropim));
    minthr=1.00*tmpmin;
    maxthr=1.00*tmpmax;
    rotim2=rotim.*((rotim>=minthr)&(rotim<=maxthr));
    tmpproj=sum(rotim2)./sum(rotim2>=minthr);
    tmpproj_sweep{mm}=tmpproj;
    proj_sweep{mm}=tmpproj(find((tmpproj>=minthr)&(tmpproj<=maxthr)));
    minproj_sweep(mm)=min(proj_sweep{mm}(2:end-1));
    meanproj_sweep(mm)=mean(proj_sweep{mm}(2:end-1));
  end;
end;


if (nargout==0),
subplot(221),
show(im_super(anatim,maskim,1)')
subplot(222)
%show(im_super(cropim,cropmsk,0.2)')
show(rotim',[tmpmin tmpmax])
subplot(224)
plot(proj)
%[minthr maxthr],
%proj,
%keyboard;
drawnow;
if (rot_sweep),
  mycf=gcf;
  figure(mycf+1)
  subplot(211)
  plot(rotangle_sweep,minproj_sweep)
  subplot(212)
  plot(rotangle_sweep,meanproj_sweep)
  drawnow,
  figure(mycf)
end;
end;

r1a=calcRadius2(proj);
if exist('mii'),
 r1b=calcRadius3b(proj,mii);
 y.mii_m3b=mii;
else,
 r1b=calcRadius3b(proj);
end;

y.D=2*[r1a(1) r1b(1)];
y.Rx_m2=r1a;
y.Rx_m3b=r1b;
y.im=anatim;
y.mask=maskim;
y.angle=rotangle;
y.cropim=cropim;
y.rotim=rotim;
y.proj=proj;
y.minthr=minthr;


disp(sprintf('  1: D= %.2f %.2f',2*r1a(1),2*r1b(1)));

if (nargout==0),
subplot(223)
calcRadius2(proj);
subplot(224)
calcRadius3b(proj);
end;

