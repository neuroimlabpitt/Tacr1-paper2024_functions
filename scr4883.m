close all

% addpath ~/Documents/MATLAB/xml_io_tools/  (may need to add path to files)
my2Pscr1('TSeries-06132019-1507-4883/','do_load',{[1:1700],[1:2],[1]},'do_motc',[4 100 1 1 0],'do_motcref',[1 1],'do_keepraw');
%my2Pscr1('TSeries-05302019-1228-4772/','do_loadall','do_motc',[4 100 1 1 0],'do_motcref',[1 1],'do_keepraw');

% Matlab filename and reference filename for previous cell and vessel
% definitions
matname='Tser4883';
refname='Tser4883';

%% They are related to those numbers we put in the lab view computer... 150/150/1650...
% #1 is noff and I typically subtract 50-20. (150-50)
% #2 is nimtr
% #3 is the total number of images needed and is related to ntr
% ntr = (1650-the first number)/(second number)
ntr=10;         % 16, 10   ntr = (1650-the first number)/(second number)= 1650-150/150
nimtr=150;      % 80, 160   
noff=150-25;	% 100, 100
nbase=25;
fps=5;
tt=([1:nimtr]-nbase)/fps;

%% First load data
load([matname,'_res'])
if ~exist('data_raw','var'), data_raw=readPrairie2(fname); end;

% OR IF THERE ARE TOO MANY BARS, then just skip and interpolate previous motion
% estimates
tmpi1=find(sqrt(sum(xx_motc.^2,2))<5);
tmpi2=find(sqrt(sum(xx_motc.^2,2))>5);
xx_motc_new=xx_motc;
xx_motc_new(tmpi2,1)=interp1(tmpi1,xx_motc(tmpi1,1),tmpi2);
xx_motc_new(tmpi2,2)=interp1(tmpi1,xx_motc(tmpi1,2),tmpi2);
tmp=xx_motc; tmp(tmpi2,1)=nan; tmp(tmpi2,2)=nan;

data=imMotApply(xx_motc_new,data_raw);
avgim_motc=mean(data,4);
stdim_motc=std(data,[],4);
avgtc_motc=squeeze(mean(mean(data,1),2));

close, subplot(211), plot(xx_motc), subplot(212), plot(xx_motc_new),

%% Third, average the data from repeated trials
adata=mean(reshape(data(:,:,:,[1:nimtr*ntr]+noff),[size(data,1),size(data,2),size(data,3),nimtr,ntr]),5);
avgtc_motc_a=squeeze(mean(mean(adata,1),2));
avgim=mean(adata(:,:,:,1:16),4);
stdim=std(data(:,:,:,tmpi1),[],4);

%% check movie
%showMovie(adata,[],[0 1700],'tser4769_avg_mov.mp4')

%% for vessel diameter
rad1=manyRadROIs(imwlevel(stdim(:,:,1),[],1),1,[],[],0);
save('roi_rr1_4883_201901306', 'rad1')
%load ('roi4777.mat','rad1') %use roi4777 for Tser4777-4781

rmask1=zeros(size(avgim_motc(:,:,1)));
for mm=1:length(rad1), [tmpa,tmpb,tmpc]=getRectImGrid(avgim_motc(:,:,1),rad1(mm)); rmask1(find(tmpb))=mm; end;
im_overlay4(avgim_motc(:,:,1),rmask1) %to see overlays in channel 1; check to see if same.

%close, for mm=1:length(rad1), im_overlay4(avgim_motc(:,:,1),rmask1==mm), title(sprintf('rmask #%d',mm)); pause, end; %to see each individual roi

rr1=calcRadius6(im_smooth(squeeze(data(:,:,1,:)),0.6),rad1,1); %radius of 1700frames, can compare to below
rr1a=calcRadius6(im_smooth(squeeze(adata(:,:,1,:)),0.6),rad1,1); %radius of 150 frames (avg)
rr1a_microns=(rr1a*info.PV_shared.micronsPerPixel{1}); % microns from avg of 150

rr1avg=squeeze(mean(reshape(rr1([1:nimtr*ntr]+noff,:),[nimtr ntr size(rr1,2)]),2)); %mean of rr1 1700 frames; can compare to below
% error was occuring doesn't need rr1a_mean=squeeze(mean(reshape(rr1a([1:nimtr*ntr]+noff,:),[nimtr ntr size(rr1a,2)]),2));

rr1std=squeeze(std(reshape(rr1([1:nimtr*ntr]+noff,:),[nimtr ntr size(rr1,2)]),[],2)); % std of 1700 frames
rr1SEM=(rr1std/sqrt(ntr)) %SEM 
rr1SEM_microns=(rr1SEM*info.PV_shared.micronsPerPixel{1}) %SEM in microns

rr1n=rr1./(ones(size(rr1,1),1)*mean(rr1(1:nbase,:),1)); %to normalized 1700 frames
rr1an=rr1a./(ones(size(rr1a,1),1)*mean(rr1a(1:nbase,:),1)); %normalized 150 frames
rr1a_percent=(rr1an-1)*100; %percent using avg 150 frames

rr1nstd=squeeze(std(reshape(rr1n([1:nimtr*ntr]+noff,:),[nimtr ntr size(rr1n,2)]),[],2)); %std of normalized of 1700
rr1nSEM=(rr1nstd/sqrt(ntr));
rr1nSEM_percent=rr1nSEM*100;
%% for all ROIS
close all
figure, plotmany(tt,rr1a_microns)
figure, plotmany(tt,rr1a_percent)
%% for avg ROIs on same vessel (avg sem in excel)
vii={[1]};
rr1a_microns_vessel=[];
rr1a_percent_vessel=[];
rr1a_microns_vesselSEM=[];
rr1a_percent_vesselSEM=[];

for mm=1:length(vii), rr1a_microns_vessel(:,mm)=mean(rr1a_microns(:,vii{mm}),2); end; %avg for vessels 
for mm=1:length(vii), rr1a_percent_vessel(:,mm)=mean(rr1a_percent(:,vii{mm}),2); end; %avg for vessels 

for mm=1:length(vii), rr1a_microns_vesselSEM(:,mm)=mean(rr1SEM_microns(:,vii{mm}),2); end; %avg for vessels 
for mm=1:length(vii), rr1a_percent_vesselSEM(:,mm)=mean(rr1nSEM_percent(:,vii{mm}),2); end; %avg for vessels 

%% final defined variables and plots
rr1a_microns_vessel_Final=rr1a_microns_vessel(:,1);
rr1a_percent_vessel_Final=rr1a_percent_vessel(:,1);

rr1a_microns_vesselSEM_Final=rr1a_microns_vesselSEM(:,1);
rr1a_percent_vesselSEM_Final=rr1a_percent_vesselSEM(:,1);

%%
% see vessel SLIT location for slit 1 in vessel segment 2 
%close, im_overlay4(avgim_motc(:,:,1),rmask1==vii{2}(1))

% plot avg ROIs
close,
subplot(211), plot(tt,rr1a_microns_vessel), axis tight, grid on, fatlines(1.5);
subplot(212), plot(tt,rr1a_percent_vessel), axis tight, grid on, fatlines(1.5);

close all,
figure, plotmany(tt,rr1a_microns_vessel),
figure, plotmany(tt,rr1a_percent_vessel),
%figure, plotmany(tt,mysmooth(rr1a_microns_vessel)),
%figure, plotmany(tt,mysmooth(rr1a_percent_vessel)),

%close all, plotmsd4(tt,rr1a_microns_vessel(:,1), rr1a_microns_vesselSEM(:,1))
%close all, plotmsd4(tt,rr1a_microns_vessel(:,2), rr1a_microns_vesselSEM(:,2))
%close all, plotmsd4(tt,rr1a_microns_vessel(:,3), rr1a_microns_vesselSEM(:,3))
%close all, plotmsd4(tt,rr1a_microns_vessel(:,4), rr1a_microns_vesselSEM(:,4))

close all, plotmsd4(tt,rr1a_percent_vessel(:,1), rr1a_percent_vesselSEM(:,1))

%% pericyte width
rad2=manyRadROIs(avgim_motc(:,:,2),1,[],[],0);
save('roi_rr2_4883_20191306', 'rad2')
%load ('roi4777b.mat', 'rad2')

rmask2=zeros(size(avgim_motc(:,:,2)));
for mm=1:length(rad2), [tmpa,tmpb,tmpc]=getRectImGrid(avgim_motc(:,:,2),rad2(mm)); rmask2(find(tmpb))=mm; end; %for ROIs slit overlays in channel 2
im_overlay4(avgim_motc(:,:,2),rmask2) 

rr2=calcRadius6(squeeze(data(:,:,2,:)),rad2,1); %1700
rr2a=calcRadius6(squeeze(adata(:,:,2,:)),rad2,1); %150

rr2avg=squeeze(mean(reshape(rr2([1:nimtr*ntr]+noff,:),[nimtr ntr size(rr2,2)]),2)); %compare to rr2a?
rr2a_microns=(rr2a*info.PV_shared.micronsPerPixel{1}) 

rr2std=squeeze(std(reshape(rr2([1:nimtr*ntr]+noff,:),[nimtr ntr size(rr2,2)]),[],2)); % std of 1700 frames
rr2SEM=(rr2std/sqrt(ntr)) %SEM 
rr2SEM_microns=(rr2SEM*info.PV_shared.micronsPerPixel{1}) %SEM in microns

rr2n=rr2./(ones(size(rr2,1),1)*mean(rr2(1:nbase,:),1)); %1700 normalized to get percent change
rr2an=rr2a./(ones(size(rr2a,1),1)*mean(rr2a(1:nbase,:),1)); %150normalized
rr2a_percent=(rr2an-1)*100; %percent of 150 frames
%close, plotmany((tt),rr2a_percent) %normalized to zero and percent fl change PERCENT GRAPH

rr2nstd=squeeze(std(reshape(rr2n([1:nimtr*ntr]+noff,:),[nimtr ntr size(rr2n,2)]),[],2)); %std of normalized of 1700
rr2nSEM=(rr2nstd/sqrt(ntr))
rr2nSEM_percent=rr2nSEM*100

plotmany(tt,rr2a_percent)

%for avg ROIs on same vessel (avg sem in excel)
viii={[2]};
rr2a_microns_vessel=[];
rr2a_percent_vessel=[];
rr2a_microns_vesselSEM=[];
rr2a_percent_vesselSEM=[];

for mm=1:length(viii), rr2a_microns_vessel(:,mm)=mean(rr2a_microns(:,viii{mm}),2); end; %avg for vessels 
for mm=1:length(viii), rr2a_percent_vessel(:,mm)=mean(rr2a_percent(:,viii{mm}),2); end; %avg for vessels 

for mm=1:length(viii), rr2a_microns_vesselSEM(:,mm)=mean(rr2SEM_microns(:,viii{mm}),2); end; %avg for vessels 
for mm=1:length(viii), rr2a_percent_vesselSEM(:,mm)=mean(rr2nSEM_percent(:,viii{mm}),2); end; %avg for vessels 

%close all, plotmsd4(tt,rr2a_microns_vessel(:,1), rr2a_microns_vesselSEM(:,1))
%close all, plotmsd4(tt,rr2a_microns_vessel(:,2), rr2a_microns_vesselSEM(:,2))

close all, plotmany(tt,rr2a_percent_vessel)

%final defined variables and plots
rr2a_microns_vessel_Final=rr2a_microns_vessel;
rr2a_percent_vessel_Final=rr2a_percent_vessel(:,1);

rr2a_microns_vesselSEM_Final=rr2a_microns_vesselSEM(:,1);
rr2a_percent_vesselSEM_Final=rr2a_percent_vesselSEM(:,1);

%% %perictye GCaMP
yproj2=[];
for mm=1:size(data,4), 
  tmpim=data(:,:,2,mm); 
  for nn=1:length(rad2), 
    [tmpa,tmpb,tmpc]=getRectImGrid(tmpim,rad2(nn)); 
    yproj2{nn}(:,mm)=mean(tmpa,2); 
  end; 
end;
yproj2max=[];
for nn=1:length(rad2), yproj2max(:,nn)=max(yproj2{nn},[],1); end;
yproj2max_a=squeeze(mean(reshape(yproj2max([1:nimtr*ntr]+noff,:),[nimtr ntr size(yproj2max,2)]),2)); 
yproj2max_an=yproj2max_a./(ones(size(yproj2max_a,1),1)*mean(yproj2max_a(1:nbase,:),1));
yproj2max_percent=((yproj2max_an-1)*100);

yproj2max_n=yproj2max./(ones(size(yproj2max,1),1)*mean(yproj2max(1:nbase,:),1));
yproj2max_std=squeeze(std(reshape(yproj2max_n([1:nimtr*ntr]+noff,:),[nimtr ntr size(yproj2max_n,2)]),[],2));

yproj2max_SEM=(yproj2max_std/sqrt(ntr))
yproj2max_SEMpercent=yproj2max_SEM*100

plotmany(tt, yproj2max_percent)

%for avg ROIs on same vessel (avg sem in excel)
viii={[2]};
yproj2max_percent_int=[];
yproj2max_SEMpercent_int=[];

for mm=1:length(viii), yproj2max_percent_int(:,mm)=mean(yproj2max_percent(:,viii{mm}),2); end; %avg for vessels 
for mm=1:length(viii), yproj2max_SEMpercent_int(:,mm)=mean(yproj2max_SEMpercent(:,viii{mm}),2); end; %avg for vessels 

close all, plotmsd4(tt,yproj2max_percent_int(:,1), yproj2max_SEMpercent_int(:,1))
close all, plotmany(tt, yproj2max_percent_int)

yproj2max_percent_intFinal=yproj2max_percent_int(:,1)
yproj2max_SEMpercent_intFinal=yproj2max_SEMpercent_int(:,1)

%% save everything
newsname=[sname '_cfr'];
save(newsname);

%%
%figure, plotmany(tt, mysmooth(rr2a*info.PV_shared.micronsPerPixel{1}))
%figure, plotmany(tt, (yproj2max_an-1)*100),

%figure, plotmany(tt, mysmooth(yproj2max_percent)),

%close, plotmsd4(tt,yproj2max_percent(:,3), yproj2max_SEMpercent(:,3)) %plot of percent change with SEM for ROI 3 

%figure,
%subplot(211), plot(tt, mean(rr2a*info.PV_shared.micronsPerPixel{1},2)), axis tight, grid on, fatlines(1.5),
%xlabel('Time (s)'), ylabel('Pericyte Width (um)'), set(gca,'FontSize',14); dofontsize(17);
%subplot(212), plot(tt, mean(yproj2max_an-1,2)*100), axis tight, grid on, fatlines(1.5),
%xlabel('Time (s)'), ylabel('Pericyte GCaMP (%)'), set(gca,'FontSize',14); dofontsize(17);

%figure,
%subplot(311), plot(tt, mean(yproj2max_an-1,2)*100), axis tight, grid on, fatlines(1.5),
%xlabel('Time (s)'), ylabel('Pericyte GCaMP (%)'), set(gca,'FontSize',14); dofontsize(17);
%subplot(312), plot(tt,rr1a_percent_vessel(:,1)), axis tight, grid on, fatlines(1.5); %% selected vessel segment 1
%xlabel('Time (s)'), ylabel('Vessel Diameter (%)'), set(gca,'FontSize',14); dofontsize(17);
%subplot(313), plot(tt,normch(-mean(yproj2max_an-1,2),0),tt,normch(rr1a_percent_vessel(:,1),0)), axis tight, grid on, fatlines(1.5);
%xlabel('Time (s)'), ylabel('Norm Ch'), legend('Pericyte','Vessel'), set(gca,'FontSize',14); dofontsize(17);

% print -dpng fig4
% print -dfig fig4

