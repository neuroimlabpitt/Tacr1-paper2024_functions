
close all

%% NK1R Figures
%

tmpfix=zeros(size(dyn1l1p0a_nk1r_bioall.tt)); tmpfix(502:901)=1;
tmpfixS=zeros(size(dyn1l1p0aS_nk1r_bioall.tt)); tmpfixS(502:601)=1;
tmpfixL=zeros(size(dyn1l1p0bL_nk1r_bioall.tt)); tmpfixL(502:1501)=1;


figure(1), clf,
subplot(231), 
plotmsd4(dyn1l1p0a_nk1r_bioall.tt,mean(dyn1l1p0a_nk1r_bioall.FLUX,2)-tmpfix*0.05,std(dyn1l1p0a_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('5Hz 1mW 30ms'),
tmpax=axis; axis([-4 36 tmpax(3:4)]);
subplot(232),
plotmsd4(dyn1l1p0b_nk1r_bioall.tt,mean(dyn1l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.16,std(dyn1l1p0b_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('5Hz 1mW 10ms'),
tmpax=axis; axis([-4 36 tmpax(3:4)]);
subplot(233),
plotmsd4(dyn1l1p0c_nk1r_bioall.tt,mean(dyn1l1p0c_nk1r_bioall.FLUX,2)-tmpfix*0.15,std(dyn1l1p0c_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('5Hz 1mW 2ms'),
tmpax=axis; axis([-4 36 tmpax(3:4)]);
subplot(234), 
plotmsd4(dyn2l1p0b_nk1r_bioall.tt,mean(dyn2l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.28,std(dyn2l1p0b_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('10Hz 1mW 10ms'),
tmpax=axis; axis([-4 36 tmpax(3:4)]);
subplot(235),
plotmsd4(dyn4l1p0b_nk1r_bioall.tt,mean(dyn4l1p0b_nk1r_bioall.FLUX,2)+tmpfix*0.0,std(dyn4l1p0b_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('20Hz 1mW 10ms'),
tmpax=axis; axis([-4 36 tmpax(3:4)]);
subplot(236),
plotmsd4(dyn8l1p0b_nk1r_bioall.tt,mean(dyn8l1p0b_nk1r_bioall.FLUX,2)+tmpfix*0.20,std(dyn8l1p0b_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('40Hz 1mW 10ms'),
tmpax=axis; axis([-4 36 tmpax(3:4)]);
setpapersize([10 8]);

figure(2), clf,
subplot(211),
plot(dyn1l1p0a_nk1r_bioall.tt,([mean(dyn1l1p0a_nk1r_bioall.FLUX,2)-tmpfix*0.05,...
                        mean(dyn1l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.16,...
                        mean(dyn1l1p0c_nk1r_bioall.FLUX,2)-tmpfix*0.15,...
                        mean(dyn1wh1_nk1r_bioall.FLUX,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 44 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
set(gca,'FontSize',12); dofontsize(15); legend('1mW 30ms 5Hz','1mW 10ms 5Hz','1mW 2ms 5Hz','Wh'),
tmpax=axis; axis([-4 36 tmpax(3:4)]); setlinecolor([0 0 1;1 0 0;0 .5 0;0 0 0]); fatlines(1.25);
subplot(212)
plot(dyn1l1p0b_nk1r_bioall.tt,([mean(dyn1l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.16,...
                        mean(dyn2l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.28,...
                        mean(dyn4l1p0b_nk1r_bioall.FLUX,2)+tmpfix*0.0,...
                        mean(dyn8l1p0b_nk1r_bioall.FLUX,2)+tmpfix*0.20]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 44 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
set(gca,'FontSize',12); dofontsize(15); legend('1mW 10ms 5Hz','1mW 10ms 10Hz','1mW 10ms 20Hz','1mW 10ms 40Hz'),
tmpax=axis; axis([-4 36 -10 15]); setlinecolor([1 0 0; 0.5 0 0.5;1 0.5 0; 0.5 0 0]); fatlines(1.25);
setpapersize([8 10]),



figure(3), clf,
subplot(231), 
plotmsd4(dyn1l1p0aS_nk1r_bioall.tt,mean(dyn1l1p0aS_nk1r_bioall.FLUX,2)-tmpfixS*0.04,std(dyn1l1p0aS_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('5Hz 1mW 30ms'),
tmpax=axis; axis([-4 28 tmpax(3:4)]);
subplot(232),
plotmsd4(dyn1l1p0bS_nk1r_bioall.tt,mean(dyn1l1p0bS_nk1r_bioall.FLUX,2)-tmpfixS*0.13,std(dyn1l1p0bS_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('5Hz 1mW 10ms'),
tmpax=axis; axis([-4 28 tmpax(3:4)]);
subplot(233),
plotmsd4(dyn1l1p0cS_nk1r_bioall.tt,mean(dyn1l1p0cS_nk1r_bioall.FLUX,2)-tmpfixS*0.18,std(dyn1l1p0cS_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('5Hz 1mW 2ms'),
tmpax=axis; axis([-4 28 tmpax(3:4)]);
subplot(234), 
plotmsd4(dyn2l1p0bS_nk1r_bioall.tt,mean(dyn2l1p0bS_nk1r_bioall.FLUX,2)-tmpfixS*0.20,std(dyn2l1p0bS_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('10Hz 1mW 10ms'),
tmpax=axis; axis([-4 28 tmpax(3:4)]);
subplot(235),
plotmsd4(dyn4l1p0bS_nk1r_bioall.tt,mean(dyn4l1p0bS_nk1r_bioall.FLUX,2)+tmpfixS*0.03,std(dyn4l1p0bS_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('20Hz 1mW 10ms'),
tmpax=axis; axis([-4 28 tmpax(3:4)]);
subplot(236),
plotmsd4(dyn8l1p0bS_nk1r_bioall.tt,mean(dyn8l1p0bS_nk1r_bioall.FLUX,2)+tmpfixS*0.21,std(dyn8l1p0bS_nk1r_bioall.FLUX,[],2))
xlabel('Time (s)'), ylabel('LDF (%; CBF)'), title('40Hz 1mW 10ms'),
tmpax=axis; axis([-4 28 tmpax(3:4)]);
setpapersize([10 8]);

figure(4), clf,
subplot(211),
plot(dyn1l1p0aS_nk1r_bioall.tt,([mean(dyn1l1p0aS_nk1r_bioall.FLUX,2)-tmpfixS*0.04,...
                        mean(dyn1l1p0bS_nk1r_bioall.FLUX,2)-tmpfixS*0.13,...
                        mean(dyn1l1p0cS_nk1r_bioall.FLUX,2)-tmpfixS*0.18,...
                        mean(dyn1wh1S_nk1r_bioall.FLUX,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 44 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
set(gca,'FontSize',12); dofontsize(15); legend('1mW 30ms 5Hz','1mW 10ms 5Hz','1mW 2ms 5Hz','Wh'),
tmpax=axis; axis([-4 28 tmpax(3:4)]); setlinecolor([0 0 1;1 0 0;0 .5 0;0 0 0]); fatlines(1.25);
subplot(212)
plot(dyn1l1p0bS_nk1r_bioall.tt,([mean(dyn1l1p0bS_nk1r_bioall.FLUX,2)-tmpfixS*0.13,...
                        mean(dyn2l1p0bS_nk1r_bioall.FLUX,2)-tmpfixS*0.20,...
                        mean(dyn4l1p0bS_nk1r_bioall.FLUX,2)+tmpfixS*0.03,...
                        mean(dyn8l1p0bS_nk1r_bioall.FLUX,2)+tmpfixS*0.21]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 44 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
set(gca,'FontSize',12); dofontsize(15); legend('5Hz 1mW 10ms','10Hz 1mW 10ms','20Hz 1mW 10ms','40Hz 1mW 10ms'),
tmpax=axis; axis([-4 28 -10 15]); setlinecolor([1 0 0; 0.5 0 0.5;1 0.5 0; 0.5 0 0]); fatlines(1.25);
setpapersize([8 10]);


figure(5)
subplot(211)
plot(dyn1l1p0bL_nk1r_bioall.tt,([mean(dyn1l1p0bL_nk1r_bioall.FLUX,2)-tmpfixL*0.16]-1)*100,...
     dyn1wh1L_nk1r_bioall.tt,([mean(dyn1wh1L_nk1r_bioall.FLUX,2)]-1)*100),
axis('tight'), grid('on'), tmpax=axis; axis([-4 48 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
set(gca,'FontSize',12); dofontsize(15); legend('5Hz 1mW 10ms','Wh'), setlinecolor([0 0 1; 0 0 0]); fatlines(1.25);


tmpii=find((dyn1l1p0a_nk1r_bioall.tt>=4.1)&(dyn1l1p0a_nk1r_bioall.tt<6));
dyn1l1p0a_nk1r_amp=mean(dyn1l1p0a_nk1r_bioall.FLUX(tmpii,:),1);
dyn1l1p0b_nk1r_amp=mean(dyn1l1p0b_nk1r_bioall.FLUX(tmpii,:),1);
dyn1l1p0c_nk1r_amp=mean(dyn1l1p0c_nk1r_bioall.FLUX(tmpii,:),1);
dyn2l1p0b_nk1r_amp=mean(dyn2l1p0b_nk1r_bioall.FLUX(tmpii,:),1);
dyn4l1p0b_nk1r_amp=mean(dyn4l1p0b_nk1r_bioall.FLUX(tmpii,:),1);
dyn8l1p0b_nk1r_amp=mean(dyn8l1p0b_nk1r_bioall.FLUX(tmpii,:),1);
dyn1wh1_nk1r_amp=mean(dyn1wh1_nk1r_bioall.FLUX(tmpii,:),1);
dyn1wh1L_nk1r_amp=mean(dyn1wh1S_nk1r_bioall.FLUX(tmpii,:),1);

tmpii=find((dyn1l1p0aS_nk1r_bioall.tt>=1.1)&(dyn1l1p0aS_nk1r_bioall.tt<3));
dyn1l1p0aS_nk1r_amp=mean(dyn1l1p0aS_nk1r_bioall.FLUX(tmpii,:),1);
dyn1l1p0bS_nk1r_amp=mean(dyn1l1p0bS_nk1r_bioall.FLUX(tmpii,:),1);
dyn1l1p0cS_nk1r_amp=mean(dyn1l1p0cS_nk1r_bioall.FLUX(tmpii,:),1);
dyn2l1p0bS_nk1r_amp=mean(dyn2l1p0bS_nk1r_bioall.FLUX(tmpii,:),1);
dyn4l1p0bS_nk1r_amp=mean(dyn4l1p0bS_nk1r_bioall.FLUX(tmpii,:),1);
dyn8l1p0bS_nk1r_amp=mean(dyn8l1p0bS_nk1r_bioall.FLUX(tmpii,:),1);
dyn1wh1S_nk1r_amp=mean(dyn1wh1S_nk1r_bioall.FLUX(tmpii,:),1);


%% VGAT Figures
%

tmpfix=zeros(size(dyn1l1p0b_vgat_bioall.tt)); tmpfix(502:901)=1;
tmpfixS=zeros(size(dyn1l1p0bS_vgat_bioall.tt)); tmpfixS(502:601)=1;
tmpfixL=zeros(size(dyn1l1p0bL_vgat_bioall.tt)); tmpfixL(502:1501)=1;

figure(11), clf,
plot(dyn1l1p0a_vgat_bioall.tt,([mean(dyn1l1p0a_vgat_bioall.FLUX,2)-tmpfix*0.00,...
                        mean(dyn1l1p0b_vgat_bioall.FLUX,2)-tmpfix*0.08,...
                        mean(dyn1l1p0c_vgat_bioall.FLUX,2)-tmpfix*0.19,...
                        mean(dyn1wh1_vgat_bioall.FLUX,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 39 -10 40]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'), title('Awake VGAT-ChR2 4-sec Stimulation'),
set(gca,'FontSize',12); dofontsize(15); legend('1mW 30ms 5Hz','1mW 10ms 5Hz','1mW 2ms 5Hz','Wh'),
setlinecolor([0 0 1;1 0 0;0 .5 0;0 0 0]); fatlines(1.25);

figure(12), clf,
plot(dyn1l1p0b_vgat_bioall.tt,([mean(dyn1l1p0b_vgat_bioall.FLUX,2)-tmpfix*0.08,...
                        mean(dyn2l1p0b_vgat_bioall.FLUX,2)-tmpfix*0.30,...
                        mean(dyn4l1p0b_vgat_bioall.FLUX,2)-tmpfix*0.21,...
                        mean(dyn8l1p0b_vgat_bioall.FLUX,2)+tmpfix*0.09]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 39 -10 40]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'), title('Awake VGAT-ChR2 4-sec Stimulation'),
set(gca,'FontSize',12); dofontsize(15); legend('5Hz 1mW 10ms','10Hz 1mW 10ms','20Hz 1mW 10ms','40Hz 1mW 10ms'),
setlinecolor([1 0 0; 0.5 0 0.5;1 0.5 0; 0.5 0 0]); fatlines(1.25);

figure(13), clf,
plot(dyn1l1p0aS_vgat_bioall.tt,([mean(dyn1l1p0aS_vgat_bioall.FLUX,2)-tmpfixS*0.00,...
                        mean(dyn1l1p0bS_vgat_bioall.FLUX,2)-tmpfixS*0.16,...
                        mean(dyn1l1p0cS_vgat_bioall.FLUX,2)-tmpfixS*0.12,...
                        mean(dyn1wh1S_vgat_bioall.FLUX,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 29 -10 40]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'), title('Awake VGAT-ChR2 1-sec Stimulation'),
set(gca,'FontSize',12); dofontsize(15); legend('1mW 30ms 5Hz','1mW 10ms 5Hz','1mW 2ms 5Hz','Wh'),
setlinecolor([0 0 1;1 0 0;0 .5 0;0 0 0]); fatlines(1.25);

figure(14), clf,
plot(dyn1l1p0bS_vgat_bioall.tt,([mean(dyn1l1p0bS_vgat_bioall.FLUX,2)-tmpfixS*0.16,...
                        mean(dyn2l1p0bS_vgat_bioall.FLUX,2)-tmpfixS*0.34,...
                        mean(dyn4l1p0bS_vgat_bioall.FLUX,2)-tmpfixS*0.50,...
                        mean(dyn8l1p0bS_vgat_bioall.FLUX,2)+tmpfixS*0.02]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 29 -10 40]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'), title('Awake VGAT-ChR2 1-sec Stimulation'),
set(gca,'FontSize',12); dofontsize(15); legend('5Hz 1mW 10ms','10Hz 1mW 10ms','20Hz 1mW 10ms','40Hz 1mW 10ms'),
setlinecolor([1 0 0; 0.5 0 0.5;1 0.5 0; 0.5 0 0]); fatlines(1.25);


figure(15), clf,
plot(dyn1l1p0bL_vgat_bioall.tt,([mean(dyn1l1p0bL_vgat_bioall.FLUX,2)-tmpfixL*0.16]-1)*100,...
     dyn1wh1L_vgat_bioall.tt,([mean(dyn1wh1L_vgat_bioall.FLUX,2)]-1)*100),
axis('tight'), grid('on'), tmpax=axis; axis([-4 48 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'), title('Awake VGAT-ChR2 10-sec Stimulation'),
set(gca,'FontSize',12); dofontsize(15); legend('5Hz 1mW 10ms','Wh'), setlinecolor([0 0 1; 0 0 0]); fatlines(1.25);

figure(16), clf,
plot(dyn1l1p0bS_vgat_bioall.tt,(mean(dyn1l1p0bS_vgat_bioall.FLUX,2)-1-tmpfixS*0.16)*100,...
     dyn1l1p0b_vgat_bioall.tt,(mean(dyn1l1p0b_vgat_bioall.FLUX,2)-1-tmpfix*0.08)*100,...
     dyn1l1p0bL_vgat_bioall.tt,(mean(dyn1l1p0bL_vgat_bioall.FLUX,2)-1-tmpfixL*0.16)*100),
axis('tight'), grid('on'), tmpax=axis; axis([-4 29 -15 30]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'), title('Awake VGAT-ChR2 Photo-Stim'),
set(gca,'FontSize',12); dofontsize(15); legend('PS 1-sec',' PS 4-sec','PS 10-sec'), 
fatlines(1.25);

figure(17), clf,
plot(dyn1wh1S_vgat_bioall.tt,(mean(dyn1wh1S_vgat_bioall.FLUX,2)-1-tmpfixS*0)*100,...
     dyn1wh1_vgat_bioall.tt,(mean(dyn1wh1_vgat_bioall.FLUX,2)-1-tmpfix*0.0)*100,...
     dyn1wh1L_vgat_bioall.tt,(mean(dyn1wh1L_vgat_bioall.FLUX,2)-1-tmpfixL*0)*100),
axis('tight'), grid('on'), tmpax=axis; axis([-4 29 -15 30]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'), title('Awake VGAT-ChR2 Whisker Stim'),
set(gca,'FontSize',12); dofontsize(15); legend('Wh 1-sec','Wh 4-sec',' Wh 10-sec'), 
fatlines(1.25);

