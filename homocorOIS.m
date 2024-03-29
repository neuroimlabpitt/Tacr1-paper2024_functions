function [Yc,Ycf]=homocor(vol,divmult) 
% -----------------------------------------------------------
%	to correct for image nonuniformity
%	first fills in holes, then generates a low frequency 
%	background image and makes correction factor
%	input image is stored in img, output is Iout
%
%	homocor.m  rev 0    4/8/00	          Gary Glover
%       ----------------------------------------------------- 
%
%   Modified to deal with SPM99 analize format image files.
%   Produces a 'homocor.img' volume in the working directory.
%
%   Works with volumes acquired in any orientation, The inplane
%   is taken to be the plane where two of the volume dimensions
%   match. If all dimensions match, it will default to axial.
% -----------------------------------------------------------

%   @(#)vol_homocor.m    1.10  Kalina Christoff    2000-05-29


% make a guess as to what orientation are the slices
% eg. vol.dim=[256 256 124 4] probably axial, etc
% --------------------------------------------------

voldim = size(vol);

do_pad2=0;
if rem(voldim(1),2)|rem(voldim(2),2), do_pad2=1; end;
if do_pad2, 
  disp('Adjusting volume xy size to be divisible by 2');
  vol_orig=vol; voldim_orig=voldim; 
  vol=vol(1:end-rem(size(vol,1),2),1:end-rem(size(vol,2),2),:);
  voldim=size(vol);
end;
if length(voldim)<3, voldim(3)=1; end;


if ~exist('divmult'), divmult=8; end;

dimch=0;
if       voldim(1)==voldim(2) % probably axial
            inpl_crd=[1 2]; thrpl_crd=3;
            orientation='axial';
 elseif  voldim(2)==voldim(3) % probably sagittal
            inpl_crd=[2 3]; thrpl_crd=1;
            orientation='sagittal';
 elseif  voldim(1)==voldim(3) % probably coronal
            inpl_crd=[1 3]; thrpl_crd=2;
            orientation='coronal'; 
else
            inpl_crd=[1 2]; thrpl_crd=3;
            orientation='unknown';
            dimch=1; dd=voldim(1)-voldim(2);
end

disp(sprintf('Assuming the planes were acquired in  %s  orientation',orientation));

foo = voldim(inpl_crd);
npix = max(foo(1:2));
np2 = npix/2;

%thres = input('gimme threshold % [5] =');
%if(isempty(thres))
  thres = 5;
%end;
thres = thres*.01;	% Used to be 0.01

Y = vol;

% initialize the corrected output volume Yc
Yc=zeros(size(vol));
Ycf=zeros(size(vol));


% begin looping through slices
% ----------------------------
for slice = 1:voldim(thrpl_crd);
     
    %if slice<10; fprintf('\b%d',slice); 
    % elseif slice<100,  fprintf('\b\b%d',slice); 
    % elseif slice<1000, fprintf('\b\b\b%d',slice);
    %end

    % surprisingly, Y needs to be squeezed to remove the singleton 
    % dimensions for coronal or sagittal... interesting command.
    % ---------------------------------------------------------------
    if thrpl_crd==1; img=squeeze(Y(slice,:,:)); end;  
    if thrpl_crd==2; img=squeeze(Y(:,slice,:)); end;
    if thrpl_crd==3; img=squeeze(Y(:,:,slice)); end;

    imgResh = reshape(img,[prod(size(img)),1]);

    Imax = max(max(img));
    Imin = min(min(img));

    Imed = median(imgResh);
    Imean = mean(imgResh);
    Istd = std(imgResh);

    Ithr = Imax*thres;		
    %Ithr = (Imed-Imin)*thres+Imin;
    Ithr2 = Imean + 2.5*Istd;

    %  fill in holes with average of image over threshold

    mask = ones(size(img)); 
    %img(find(img>=Ithr2)) = sum(sum(img.*(img<Ithr2)))/sum(sum(mask));

    %mask = (img>Ithr); 
    Imask = img.*mask;
    Iave = sum(sum(Imask))/sum(sum(mask));
    Ifill = Imask + (1-mask).*Iave;

    %  make low freq image

    z = fftshift(fft2(Ifill));

    %ndef = 3;
    ndef = np2/divmult;		% may want to try a higher division multiple like 16
    n = ndef;

    y2 = (1:np2).^2;  % use 15 as default win for guassian
    a2 = 1/n;
    for x=1:np2
      r2 = y2 +x*x;
      win1(x,:) = exp(-a2*r2);
    end

    win(np2+1:npix,np2+1:npix) = win1;
    win(np2+1:npix,np2:-1:1) = win1;
    win(1:np2,:) = win(npix:-1:np2+1,:);

    if dimch,
      if dd > 0,
        win_new=win(:,abs(dd)/2+1:end-abs(dd)/2);
      elseif dd < 0,
        win_new=win(abs(dd)/2+1:end-abs(dd)/2,:);
      else,
        win_new=win;
      end
      win_old=win;
      win=win_new; 
    end

    zl = win.*z;
    %keyboard

    Ilow = abs(ifft2(fftshift(zl)));

    % corrected image

    Ilave = sum(sum(Ilow.*mask))/sum(sum(mask));
    Icorf = (Ilave./Ilow).*mask;  % correction factor
    Iout = img.*Icorf;

    % update the volume with the corrected values
    % -------------------------------------------
    if thrpl_crd==1; Yc(slice,:,:) = Iout; Ycf(slice,:,:) = Icorf;  end
    if thrpl_crd==2; Yc(:,slice,:) = Iout; Ycf(:,slice,:) = Icorf;  end
    if thrpl_crd==3; Yc(:,:,slice) = Iout; Ycf(:,:,slice) = Icorf;  end
  
    clear img;
  
% end looping through slices
% ---------------------------
end

if sum(sum(isnan(Yc)))==prod(size(Yc)),
  Yc=vol;
elseif sum(sum(isnan(Yc)))>0,
  Yc(find(isnan(Yc)))=0;
end;

disp(sprintf('Done...'));

% write corrected image (homocor.img)
% ==================================

%Yc_vol = vol;
%Yc_vol.fname   ='homocor';
%Yc_vol.descrip ='homocor';

%spm_write_vol(Yc_vol,Yc);

if do_pad2,
  tmpYc=ones(size(vol_orig))*min(Yc(:));
  tmpYcf=ones(size(vol_orig))*min(Ycf(:));
  tmpYc(1:end-rem(size(vol_orig,1),2),1:end-rem(size(vol_orig,2),2),:)=Yc;
  tmpYcf(1:end-rem(size(vol_orig,1),2),1:end-rem(size(vol_orig,2),2),:)=Ycf;
  Yc=tmpYc;
  Ycf=tmpYcf;
  clear tmpYc tmpYcf
end;

