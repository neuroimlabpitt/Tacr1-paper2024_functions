function y=estLaserPower(lambda,pockel)
% Usage ... y=estLaserPower(lambda,pockel)

% wavelength pockel= 50 100 150 200 250 300 350, power is before obj
% assume pockel 0 is 0mW
data=[
700	55	180	305	392	370	205	40
740	70	280	565	720	710	510	245
780	90	360	730	950	1000	780	450
820	80	320	710	920	1060	950	600
860	60	240	508	750	855	810	635
900	50	210	425	660	775	770	650
940	40	185	270	420	530	550	480
980	31	85	185	270	345	370	340
1020	24	64	125	180	190	270	265];

refdata=data; refdata(:,1)=0; 
reflambda=data(:,1);
refpockel=[0 50 100 150 200 250 300 350]';

data2=[
700	1303
720	1855
740	2380
760	2735
780	2918
800	2924
820	2906
840	2656
860	2452
880	2274
900	2000
920	1780
940	1600
960	1318
980	1100
1000	1000
1020	740
1040	524];

refpockeli=[0:350];
for mm=1:size(data,1),
  refdatai(mm,:)=interp1(refpockel,refdata(mm,:),refpockeli);
end;

idata=interp1(reflambda,refdata,lambda); 
yi=interp1(refpockel,idata,refpockeli);
yy=interp1(refpockel,idata,pockel);
ipower0=interp1(data2(:,1),data2(:,2),lambda);
y=yy/ipower0;

if nargout==0,
  subplot(211),
  plot(data2(:,1),data2(:,2),'k'),
  xlabel('Wavelength (nm)'),
  ylabel('Laser Power at Unit (mW)'),
  axis('tight'), grid('on'), 
  subplot(212)
  plot(refpockeli,refdatai,refpockeli,yi,'--')
  xlabel('Pockel Cell Voltage (V)'),
  ylabel('Laser Power before Objective (mW)'),
  axis('tight'), grid('on'),
  legend('700nm','740nm','780nm','820nm','860nm','900nm','940nm','980nm','1020nm'),
end;

