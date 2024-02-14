function f=rect(t,w,lag)
% Function f=rect(t,w,lag) = Rect(t-lag/w)
% 
% w is the rectangle function width in time
% lag is the location of the center of the rectangle
% if lag is a vector, multiple rectangles with lags will be generated

ff=zeros([length(lag) length(t)]);
fe=1e2;

%if (t(1)-lag>=0),
%  for m=1:length(t), 
%    if t(m)<=w/2, f(m)=1; end;
%  end;
%else,
for mm=1:length(lag),
  for m=1:length(t),
    if ((t(m)-lag(mm))>=(-1*w/2+fe*eps))&((t(m)-lag(mm))<=(w/2-fe*eps)), ff(mm,m)=1; end;
  end;
end;
%end;

if (length(lag)>1),
  f=sum(ff).';
else,
  f=ff;
end;
  
if nargout==0,
  plot(t,f)
end;

