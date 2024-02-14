function f=plotBiopac(data,parms,ii,po2calval,t2sal)
% Usage ... plotBiopac(data,parms,ii,po2cal,t2sal)
%
% parms=[ts t0 fco(optional) tsam print_flag(optional)]
% ii= trial#s
% po2cal=po2current_corresponding_to([0 20.8 100])
%

%if nargin<5,
  t2sal_flag=0;
%else,
%  if isempty(t2sal),
%    t2sal_flag=0;
%  else,
%    t2sal_flag=1;
%  end;
%end;
if nargin<4,
  po2cal_flag=0;
else,
  if isempty(po2calval),
    po2cal_flag=0;
  else,
    po2cal_flag=1;
  end;
end;
if (length(parms)<5),
  printflag=0;
end;
if (length(parms)<4),
  tsam_flag=0;
else,
  tsam=parms(4);
  if (tsam==0), tsam_flag=0; else, tsam_flag=1; end;
end;

if (nargin<3),
  ii=[1:size(data.FLUX,2)];
end;
if isempty(ii),
  ii=[1:size(data.FLUX,2)];
end;
if length(ii)==1,
  ii(2)=ii(1);
end;

ts=parms(1);
t0=parms(2);

tt=[1:length(data.FLUX)]*ts+t0;
if tsam_flag,
  f.tt=[tt(1):tsam:tt(end)];
else,
  f.tt=tt;
end;

f.ii=ii;

f.LDF=mean(data.FLUX(:,ii)')';
f.LDFstd=std(data.FLUX(:,ii)')';

f.pO2A=mean(data.pO2A(:,ii)')';
f.pO2Astd=std(data.pO2A(:,ii)')';
if (po2cal_flag),
  tmp2=[0 20.8 100];
  po2cal_o2=tmp2(1:size(po2calval,2));
  for mm=1:length(ii),
    if (t2sal_flag),
      tmp(:,mm)=po2cal2(data.pO2A(:,ii(mm)),po2cal_o2,po2calval(1,:),t2sal(1));
    else,
      tmp(:,mm)=po2cal2(data.pO2A(:,ii(mm)),po2cal_o2,po2calval(1,:));
    end;
  end;
  f.pO2Acal=mean(tmp')';
  f.pO2Acalstd=std(tmp')';
end;

f.pO2B=mean(data.pO2B(:,ii)')';
f.pO2Bstd=std(data.pO2B(:,ii)')';
if (po2cal_flag),
  for mm=1:length(ii),
    if (t2sal_flag),
      tmp(:,mm)=po2cal2(data.pO2B(:,ii(mm)),po2cal_o2,po2calval(2,:),t2sal(2));
    else,
      tmp(:,mm)=po2cal2(data.pO2B(:,ii(mm)),po2cal_o2,po2calval(2,:));
    end;
  end;
  f.pO2Bcal=mean(tmp')';
  f.pO2Bcalstd=std(tmp')';
end;

f.pO2C=mean(data.AUX3(:,ii)')';
f.pO2Cstd=std(data.AUX3(:,ii)')';
if (po2cal_flag),
  for mm=1:length(ii),
    if (t2sal_flag),
      tmp(:,mm)=po2cal2(data.AUX3(:,ii(mm)),po2cal_o2,po2calval(3,:),t2sal(3));
    else,
      tmp(:,mm)=po2cal2(data.AUX3(:,ii(mm)),po2cal_o2,po2calval(3,:));
    end;
  end;
  f.pO2Ccal=mean(tmp')';
  f.pO2Ccalstd=std(tmp')';
end;


f.BPavg=mean(mean(data.BP(:,ii)'));
f.BPstd=mean(std(data.BP(:,ii)'));
f.ISOavg=mean(mean(data.ISO(:,ii)'));
f.ISOstd=mean(std(data.ISO(:,ii)'));
f.HRavg=mean(mean(data.HR(:,ii)'));
f.HRstd=mean(std(data.HR(:,ii)'));
tmpExCO2=data.Ex_CO2(:,ii);
f.iiCO2=find(tmpExCO2>(mean(mean(tmpExCO2))+mean(std(tmpExCO2))));
iiCO2=f.iiCO2;
f.CO2avg=mean(tmpExCO2(iiCO2));
f.CO2std=std(tmpExCO2(iiCO2));


iibase=find(tt<0);
if (tsam_flag),
  f.iibase=find(f.tt<0);
else,
  f.iibase=iibase;
end;
f.LDFbase=mean(f.LDF(f.iibase));
f.pO2Abase=mean(f.pO2A(f.iibase));
f.pO2Bbase=mean(f.pO2B(f.iibase));
f.pO2Cbase=mean(f.pO2C(f.iibase));
if (po2cal_flag),
  f.pO2Acalbase=mean(f.pO2Acal(f.iibase));
  f.pO2Bcalbase=mean(f.pO2Bcal(f.iibase));
  f.pO2Ccalbase=mean(f.pO2Ccal(f.iibase));
end;


if (length(parms)>2),
  f.fco=parms(3);
  f.LDFfilt=real(myfilter1(f.LDF,length(f.LDF)*f.fco*ts));
  f.pO2Afilt=real(myfilter1(f.pO2A,length(f.LDF)*f.fco*ts));
  f.pO2Bfilt=real(myfilter1(f.pO2B,length(f.LDF)*f.fco*ts));
  f.pO2Cfilt=real(myfilter1(f.pO2C,length(f.LDF)*f.fco*ts));
  f.LDFfiltbase=mean(f.LDFfilt(iibase));
  f.pO2Afiltbase=mean(f.pO2Afilt(iibase));
  f.pO2Bfiltbase=mean(f.pO2Bfilt(iibase));
  f.pO2Cfiltbase=mean(f.pO2Cfilt(iibase));
  if (po2cal_flag),
    f.pO2Acalfilt=real(myfilter1(f.pO2Acal,length(f.LDF)*f.fco*ts));
    f.pO2Bcalfilt=real(myfilter1(f.pO2Bcal,length(f.LDF)*f.fco*ts));
    f.pO2Ccalfilt=real(myfilter1(f.pO2Ccal,length(f.LDF)*f.fco*ts));
    f.pO2Acalfiltbase=mean(f.pO2Acalfilt(iibase));
    f.pO2Bcalfiltbase=mean(f.pO2Bcalfilt(iibase));
    f.pO2Ccalfiltbase=mean(f.pO2Ccalfilt(iibase));
  end;
end;


if (tsam_flag),
  f.LDF=interp1(tt,f.LDF,f.tt);
  f.pO2A=interp1(tt,f.pO2A,f.tt);
  f.pO2B=interp1(tt,f.pO2B,f.tt);
  f.pO2C=interp1(tt,f.pO2C,f.tt);
  f.LDFstd=interp1(tt,f.LDFstd,f.tt);
  f.pO2Astd=interp1(tt,f.pO2Astd,f.tt);
  f.pO2Bstd=interp1(tt,f.pO2Bstd,f.tt);
  f.pO2Cstd=interp1(tt,f.pO2Cstd,f.tt);
  f.LDFfilt=interp1(tt,f.LDFfilt,f.tt);
  f.pO2Afilt=interp1(tt,f.pO2Afilt,f.tt);
  f.pO2Bfilt=interp1(tt,f.pO2Bfilt,f.tt);
  f.pO2Cfilt=interp1(tt,f.pO2Cfilt,f.tt);
  f.LDFbase=mean(f.LDF(f.iibase));
  f.pO2Abase=mean(f.pO2A(f.iibase));
  f.pO2Bbase=mean(f.pO2B(f.iibase));
  f.pO2Cbase=mean(f.pO2C(f.iibase));
  f.LDFfiltbase=mean(f.LDFfilt(f.iibase));
  f.pO2Afiltbase=mean(f.pO2Afilt(f.iibase));
  f.pO2Bfiltbase=mean(f.pO2Bfilt(f.iibase));
  f.pO2Cfiltbase=mean(f.pO2Cfilt(f.iibase));
  if (po2cal_flag),
    f.pO2Acalfilt=interp1(tt,f.pO2Acalfilt,f.tt);
    f.pO2Bcalfilt=interp1(tt,f.pO2Bcalfilt,f.tt);
    f.pO2Ccalfilt=interp1(tt,f.pO2Ccalfilt,f.tt);
    f.pO2Acalfiltbase=mean(f.pO2Acalfilt(f.iibase));
    f.pO2Bcalfiltbase=mean(f.pO2Bcalfilt(f.iibase));
    f.pO2Ccalfiltbase=mean(f.pO2Ccalfilt(f.iibase));
    f.pO2Acalfilt=f.pO2Acalfilt/f.pO2Acalfiltbase;
    f.pO2Bcalfilt=f.pO2Bcalfilt/f.pO2Bcalfiltbase;
    f.pO2Ccalfilt=f.pO2Ccalfilt/f.pO2Ccalfiltbase;
  end;
  f.LDF=f.LDF/f.LDFbase;
  f.pO2A=f.pO2A/f.pO2Abase;
  f.pO2B=f.pO2B/f.pO2Bbase;
  f.pO2C=f.pO2C/f.pO2Cbase;
  f.LDFfilt=f.LDFfilt/f.LDFfiltbase;
  f.pO2Afilt=f.pO2Afilt/f.pO2Afiltbase;
  f.pO2Bfilt=f.pO2Bfilt/f.pO2Bfiltbase;
  f.pO2Cfilt=f.pO2Cfilt/f.pO2Cfiltbase;
end;


if (nargout==0),

if length(parms)<3,
subplot(411)
plot(f.tt,f.LDF/f.LDFbase)
axis('tight'), grid('on'),
ylabel('LDF/LDF_0')
title(sprintf('%s (Flux= %.2f, pO2A= %.3f, pO2B= %.3f, pO2C= %.3f, BP= %.1f, ISO= %.1f, ExCO2= %.1f)',inputname(1),f.LDFbase,f.pO2Abase,f.pO2Bbase,f.pO2Cbase,f.BPavg,f.ISOavg,f.CO2avg));
subplot(412)
plot(f.tt,f.pO2A/f.pO2Abase)
axis('tight'), grid('on'),
ylabel('pO2A/pO2A_0')
subplot(413)
plot(f.tt,f.pO2B/f.pO2Bbase)
axis('tight'), grid('on'),
ylabel('pO2B/pO2B_0')
subplot(414)
plot(f.tt,f.pO2C/f.pO2Cbase)
axis('tight'), grid('on'),
ylabel('pO2C/pO2C_0')
xlabel('Time (s)')
if (printflag),
  eval(sprintf('print -dtiff %s_1.tif',inputname(1)));
end;


%figure(2)
%subplot(411)
%plotmsd2(f.tt,f.LDF,f.LDFstd)
%ylabel('LDF')
%axis('tight'), grid('on'),
%title(sprintf('%s (Flux= %.2f, pO2A= %.3f, pO2B= %.3f, pO2C= %.3f, BP= %.1f, ISO= %.1f, ExCO2= %.1f)',inputname(1),f.LDFbase,f.pO2Abase,f.pO2Bbase,f.pO2Cbase,f.BPavg,f.ISOavg,f.CO2avg));
%subplot(412)
%plotmsd2(f.tt,f.pO2A,f.pO2Astd)
%ylabel('pO2A')
%axis('tight'), grid('on'),
%subplot(413)
%plotmsd2(f.tt,f.pO2B,f.pO2Bstd)
%ylabel('pO2B')
%axis('tight'), grid('on'),
%subplot(414)
%plotmsd2(f.tt,f.pO2C,f.pO2Cstd)
%ylabel('pO2C')
%axis('tight'), grid('on'),
%xlabel('Time')
%if (printflag),
%  eval(sprintf('print -dtiff %s_2.tif',inputname(1)));
%end;

else,
%figure(3)
subplot(411)
plot(tt,f.LDFfilt/f.LDFfiltbase)
axis('tight'), grid('on'),
ylabel('LDF/LDF_0')
title(sprintf('%s (Flux= %.2f, pO2A= %.3f, pO2B= %.3f, BP= %.1f, ISO= %.1f, ExCO2= %.1f)',inputname(1),f.LDFfiltbase,f.pO2Afiltbase,f.pO2Bfiltbase,f.BPavg,f.ISOavg,f.CO2avg));
subplot(412)
plot(tt,f.pO2Afilt/f.pO2Afiltbase)
axis('tight'), grid('on'),
ylabel('pO2A/pO2A_0')
subplot(413)
plot(tt,f.pO2Bfilt/f.pO2Bfiltbase)
axis('tight'), grid('on'),
ylabel('pO2B/pO2B_0')
subplot(414)
plot(tt,f.pO2Cfilt/f.pO2Cfiltbase)
axis('tight'), grid('on'),
ylabel('pO2C/pO2C_0')
xlabel('Time (s)')
if (printflag),
  eval(sprintf('print -dtiff %s_3.tif',inputname(1)));
end;

end;
end;

