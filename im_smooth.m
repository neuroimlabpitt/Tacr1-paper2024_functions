function [f,window]=imsmooth(im,window,norm)
% Usage ... f=imsmooth(im,window,norm)
%
% if you provide a window it must be centered about (0,0) of the
% image in the middle of the screen defined as [-32:31] for a 64
% image, and the window must be in IMAGE domain, so it will be
% fft2'ed. So if you have it in fourier domain use 
% fftshift(ifft2(window))

if (nargin<2), window=2; end;

if (window==0),
  f=im;
  return,
end;

do_hpf=0;
if (length(window)<=2)
  if window<0, do_hpf=1; window=abs(window); end;
end;

% default window is a Gaussian
if length(window)<=2,
  if length(window)==2, wl=window; else, wl=[window(1) window(1)]; end;
  window=zeros(size(im(:,:,1)));
  xx=[0:size(im,1)-1]-size(im,1)/2;
  yy=[0:size(im,2)-1]-size(im,2)/2;
  for m=1:size(im,1), for n=1:size(im,2),
    window(m,n)=exp(-xx(m)*xx(m)/(2*wl(1)*wl(1)))*exp(-yy(n)*yy(n)/(2*wl(2)*wl(2)));
  end; end;
  window=window*(1/sqrt(4*pi*wl(1)*wl(2)));
  window=window/sqrt(wl(1)*wl(2)*pi);
end;

if nargin<3,
  norm=0;
end;

if do_hpf,
  window=max(window(:))-window;
end;

window_fft=fft2(window);
window_norm=max(max(abs(window_fft)));
if (norm==2),
  window_norm=sum(sum(abs(window_fft)));
end;

if size(im,3)>1,
  disp(sprintf('  smoothing %d images',size(im,3)));
  for nn=1:size(im,3),
    im_fft=fft2(im(:,:,nn));
    %show(fftshift(abs(im_fft))'), pause,
    %show(fftshift(abs(window))'), pause,
    imf=abs(im_fft).*abs(window_fft).*exp(j*(angle(im_fft)+angle(window_fft)));
    if (norm), imf=imf/window_norm; end;
    fout=fftshift(ifft2(imf));
    %show(f'), pause,

    if isreal(im), fout=real(fout); end;
    f(:,:,nn)=fout;
  end;
else,
  im_fft=fft2(im);
  %show(fftshift(abs(im_fft))'), pause,
  %show(fftshift(abs(window))'), pause,
  imf=abs(im_fft).*abs(window_fft).*exp(j*(angle(im_fft)+angle(window_fft)));
  if (norm), imf=imf/window_norm; end;
  f=fftshift(ifft2(imf));
  %show(f'), pause,

  if isreal(im), f=real(f); end;
end;
