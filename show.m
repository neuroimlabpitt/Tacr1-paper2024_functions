function [out,cmap] = show(a,windfact,ncolors)
% usage .. show(a,f);
% displays matrix "a" as a greyscale image in the matlab window
% and "f" is the optional window factors [min,max]

verbose_flag=0;
title_flag=1;

if nargin<3, ncolors=128; end;

if nargin<2, windfact=[]; end;
if isempty(windfact),
  amin = min(a(:));
  amax = max(a(:));
  minmax = [amin,amax];
  a = (a  - amin);
else
  amin = windfact(1);
  amax = windfact(2);
  minmax = windfact;
  a = (a  - amin);
  a = a .* (a > 0);
end

if size(a,3)==1,
  cmap=[0:1/(ncolors-1):1]'; cmap=[cmap cmap cmap];

  colormap(cmap);
  imout=(a)./(amax-amin).*ncolors;
  imout2=round(imout);
  image(imout);
  axis('image');
  axis('on');
  grid on;

else,
  if size(a,3)>3,
    a=a(:,:,1:3);
  elseif size(a,3)==2,
    a(:,:,3)=0;
  end;
  imout=a/(amax-amin);
  image(imout), axis('image'),
end;

if nargout==0,
  if verbose_flag,
    disp(['min/max= ',num2str(minmax(1)),' / ',num2str(minmax(2))]);
  end;
  if (title_flag), title(sprintf('min/max = %f/%f',minmax(1),minmax(2))); end;
else,
  out=imout;
end;
