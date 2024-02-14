function calcRadius4rtst(im,maskim,rang)

arange=[-20:2:20];
for mm=1:length(arange),
  tst(mm)=calcRadius4(im,maskim,rang+arange(mm));
  tstr1(mm)=tst(mm).D(1);
  tstr2(mm)=tst(mm).D(2);
end;

subplot(211)
plot(rang+arange,tstr1)
subplot(212)
plot(rang+arange,tstr2)

