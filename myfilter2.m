function [y,ff]=myfilter(x,ncu,dd)
% Usage ... y=myfilter2(x,ncu_or_fco,ts)
%  or   ... y=myfilter2(x,filt_fd)

xft=fft2(x);

if prod(double(size(ncu)==size(x)))==1,

  disp('  Simple filtering...');
  ncu=fftshift(ncu);
  yft_m=abs(xft).*abs(ncu);
  yft_a=angle(xft)-angle(ncu);
  y=ifft2(yft_m.*exp(i*yft_a));

else,

if (exist('dd')),
  df1=(1/size(x,1))*(1/dd(1));
  df2=(1/suze(x,2))*(1/dd(2));
  ncu=round(ncu/df1);
  disp(sprintf('  actual cutoff = %f',ncu*df1))
end;

ff=zeros(size(x));
for mm=1:length(ncu),
  tmpff=zeros(size(x));
  if ncu(mm)<0,
    do_highpass=1;
    ncu=abs(ncu);
  else,
    do_highpass=0;
  end;
  tmpff(1:ncu(mm),1:ncu(mm))=1; tmpff(end-ncu(mm)+1:end,end-ncu(mm)+1:end)=1;
  tmpff(1:ncu(mm),end-ncu(mm)+1:end)=1; tmpff(end-ncu(mm)+1:end,1:ncu(mm))=1;
  if do_highpass, tmpff=1-tmpff; end;
  ff=ff+tmpff;
end;
ff=ff-length(ncu)+1; ff=ff>0;
yf=abs(xft).*ff.*exp(j*angle(xft));
y=ifft2(yf);

end;

%if isreal(x), y=real(y); end;

if nargout==0,
  subplot(221)
  show(abs(y))
  subplot(222)
  show(ff)
  subplot(223)
  show(angle(y))
  clear y
end;

