function y=myfilter(x,ncu,ts)
% Usage ... y=myfilter(x,ncu_or_fco,ts)

hp_flag=0;
if ncu<0,
  hp_flag=1;
  ncu=abs(ncu);
end;

if (exist('ts')),
  df=(1/length(x))*(1/ts);
  ncu=round(ncu/df);
  disp(sprintf('  actual cutoff = %f (%d)',ncu*df,ncu*2))
end;

x=x(:);
xft=fft(x);

%if (ncu>length(x)/2),
%  error('effective cutoff is greater than the size of the data');
%end;

ff=[ones(ncu,1);zeros(length(x)-2*ncu,1);ones(ncu,1)];
if hp_flag, ff=1-ff; end;
yf=abs(xft).*ff.*exp(j*angle(xft));
y=ifft(yf);

if isreal(x), y=real(y); end;

