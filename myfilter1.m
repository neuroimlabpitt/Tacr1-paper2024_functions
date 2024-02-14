function [yy,act_ftm_filter]=myfilter1(x,ftm_filter,ts)
% Usage ... [y,filt]=myfilter(x,ftmag_filter,ts)
%
% Filters the magnitude of the FT of x using the magnitude filter
% in Fourier domain [0,2*pi] as provided by ftmag_filter

if (size(x,1)==1), x=x.'; end;

if exist('ts'),
  df=(1/length(x))*(1/ts);
  ftm_filter=round(ftm_filter/df);
  disp(sprintf('  actual cutoff = %f (%d)',ftm_filter*df,ftm_filter))
end;

xx=x;
for mm=1:size(xx,2),
x=xx(:,mm);
xm=mean(x);

if (length(ftm_filter)>2),
  %xf=fft(x);
  %xfm=abs(xf);
  %xfa=angle(xf);
  %yfm=xfm.*ftm_filter;
  %yfa=xfa;
  %y=yfm.*exp(i*yfa);
  act_ftm_filter=ftm_filer;
  y=ifft(fft(x).*ftm_filter);
elseif (length(ftm_filter)==2),
  ftm_filter=round(ftm_filter);
  act_ftm_filter=zeros(size(x));
  act_ftm_filter(abs(ftm_filter(1))+1:abs(ftm_filter(2))+1)=1;
  act_ftm_filter(end-abs(ftm_filter(2))+1:end-abs(ftm_filter(1))+1)=1;
  y=ifft(fft(x).*act_ftm_filter);
  if (ftm_filter<0),
    act_ftm_filter=1-act_ftm_filter;
    y=ifft(fft(x).*act_ftm_filter)+xm;
  end;    
else,
  ftm_filter=round(ftm_filter);
  act_ftm_filter=zeros(size(x));
  act_ftm_filter(1:abs(ftm_filter(1))+1)=1;
  act_ftm_filter(end-abs(ftm_filter(1))+1:end)=1;
  y=ifft(fft(x).*act_ftm_filter);
  if (ftm_filter<0),
    act_ftm_filter=1-act_ftm_filter;
    y=ifft(fft(x).*act_ftm_filter)+xm;
  end;    
end;
yy(:,mm)=y;

end;

if nargout==0,
  subplot(311)
  plot(x)
  subplot(312)
  plot(y)
  subplot(313)
  plot(act_ftm_filter)
end;

  