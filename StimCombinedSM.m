%To combine smooth muscle response 
%concatenation of response over time across animals (ex 150x 5) 
StimSM=[];
allnames={	
'Tser4777_res_cfr2.mat'
'Tser4798_res_cfr2.mat'	
'Tser5078_res_cfr.mat'
};
groupname='StimSM';

all_rr1a_micronsSM=[];
all_rr1aSEM_micronsSM=[];
all_rr1a_percentSM=[];
all_rr1aSEM_percentSM=[];
all_rr2a_micronsSM=[];
all_rr2aSEM_micronsSM=[];
all_rr2a_percentSM=[];
all_rr2aSEM_percentSM=[];
all_yproj2max_percentSM=[];
all_yproj2max_SEMpercentSM=[];


for ii = 1:length(allnames)
    
    load(allnames{ii})
    

    all_rr1a_micronsSM=[all_rr1a_micronsSM rr1a_microns_vessel_Final];
    all_rr1aSEM_micronsSM=[all_rr1aSEM_micronsSM rr1a_microns_vesselSEM_Final];
    
    all_rr1a_percentSM=[all_rr1a_percentSM rr1a_percent_vessel_Final]; 
    all_rr1aSEM_percentSM=[all_rr1aSEM_percentSM rr1a_percent_vesselSEM_Final];
    
    all_rr2a_micronsSM=[all_rr2a_micronsSM rr2a_microns_vessel_Final];
    all_rr2aSEM_micronsSM=[all_rr2aSEM_micronsSM rr2a_microns_vesselSEM_Final];
    
    all_rr2a_percentSM=[all_rr2a_percentSM rr2a_percent_vessel_Final]; 
    all_rr2aSEM_percentSM=[all_rr2aSEM_percentSM rr2a_percent_vesselSEM_Final];
    
    all_yproj2max_percentSM=[all_yproj2max_percentSM yproj2max_percent_intFinal];
    all_yproj2max_SEMpercentSM=[all_yproj2max_SEMpercentSM yproj2max_SEMpercent_intFinal];
    
   
end
save(groupname,'allnames','all_rr1a_micronsSM','all_rr1aSEM_micronsSM','all_rr1a_percentSM',...
    'all_rr1aSEM_percentSM','all_rr2a_micronsSM','all_rr2aSEM_micronsSM','all_rr2a_percentSM',...
    'all_rr2aSEM_percentSM','all_yproj2max_percentSM','all_yproj2max_SEMpercentSM','tt')
%% 
load 'StimSM' %mean list of all animals
% the mean across animals (150 x 1) FOR TRACES
mean_rr1a_micronsSM=mean(all_rr1a_micronsSM,2);
mean_rr1aSEM_micronsSM=mean(all_rr1aSEM_micronsSM,2);

mean_rr1a_percentSM=mean(all_rr1a_percentSM,2);
mean_rr1aSEM_percentSM=mean(all_rr1aSEM_percentSM,2);

mean_rr2a_micronsSM=mean(all_rr2a_micronsSM,2);
mean_rr2aSEM_micronsSM=mean( all_rr2aSEM_micronsSM,2)

mean_rr2a_percentSM=mean(all_rr2a_percentSM,2);
mean_rr2aSEM_percentSM=mean(all_rr2aSEM_percentSM,2)

mean_yproj2max_percentSM=mean(all_yproj2max_percentSM,2)
mean_yproj2maxSEM_percentSM=mean(all_yproj2max_SEMpercentSM,2);

%%


%%
%load 'StimSM'
%PEAK AMPLITUDE
%idx=find(tt>=1&tt<2)
%mean across a time period for all animals (1 x 5)
%groupname='BarmeansSM'
tstart=1;
tstop=1.5;

rr1a_micromeansSM=nanmean(all_rr1a_micronsSM(tt>=tstart&tt<tstop,:));
rr1a_microsemSM=nanstd(rr1a_micromeansSM)/sqrt(size(rr1a_micromeansSM,2));

rr1a_percentmeansSM=nanmean(all_rr1a_percentSM(tt>=tstart&tt<tstop,:));
rr1a_percentsemSM=nanstd(rr1a_percentmeansSM)/sqrt(size(rr1a_percentmeansSM,2));

rr2a_micromeansSM=nanmean(all_rr2a_micronsSM(tt>=tstart&tt<tstop,:));
rr2a_microsemSM=nanstd(rr2a_micromeansSM)/sqrt(size(rr2a_micromeansSM,2));

rr2a_percentmeansSM=nanmean(all_rr2a_percentSM(tt>=tstart&tt<tstop,:));
rr2a_percentsemSM=nanstd(rr2a_percentmeansSM)/sqrt(size(rr2a_percentmeansSM,2));

yproj2max_percentmeansSM=nanmean(all_yproj2max_percentSM(tt>=tstart&tt<tstop,:));
yproj2max_percentsemSM=nanstd(yproj2max_percentmeansSM)/sqrt(size(yproj2max_percentmeansSM,2));

%groupname='BarMeansSM'
%save(groupname,'rr1a_micromeansSM','rr1a_microsemSM','rr1a_percentmeansSM','rr1a_percentsemSM',...
%'rr2a_micromeansSM','rr2a_microsemSM','rr2a_percentmeansSM','yproj2max_percentmeansSM','yproj2max_percentsemSM')
%%
figure;
bar([nanmean(rr1a_micromeansC) nanmean(rr1a_micromeans) nanmean(rr1a_micromeansSM)])
hold on
errorbar([nanmean(rr1a_micromeansC) nanmean(rr1a_micromeans) nanmean(rr1a_micromeansSM)],[rr1a_microsemC rr1a_microsem rr1a_microsemSM], 'k.')

figure;
bar([nanmean(rr1a_percentmeansC) nanmean(rr1a_percentmeans) nanmean(rr1a_percentmeansSM)])
hold on
errorbar([nanmean(rr1a_percentmeansC) nanmean(rr1a_percentmeans) nanmean(rr1a_percentmeansSM)],[rr1a_percentsemC rr1a_percentsem rr1a_percentsemSM], 'k.')

figure;
bar([nanmean(rr1a_percentmeansSM)])
hold on
errorbar([nanmean(rr1a_percentmeansSM, rr1a_percentsemSM], 'k.')


%%
figure, plotmsd4(tt, mean_rr1a_microns, mean_rr1aSEM_microns)
xlabel('time')
ylabel('microns')
set(gca,'tickdir','out')

figure, plotmsd4(tt, mean_rr1a_percent, mean_rr1aSEM_percent)
xlabel('time')
ylabel('percent')
set(gca,'tickdir','out')

figure, plotmsd4(tt, mean_rr2a_microns, mean_rr2aSEM_microns)
xlabel('time')
ylabel('microns')
set(gca,'tickdir','out')

figure, plotmsd4(tt, mean_rr2a_percent, mean_rr2aSEM_percent)
xlabel('time')
ylabel('percent')
set(gca,'tickdir','out')

figure, plotmsd4(tt, mean_yproj2max_percent, mean_yproj2maxSEM_percent)
xlabel('time')
ylabel('percent')
set(gca,'tickdir','out')

%%
figure, plotmsd4(tt, [mysmooth(mean_rr1a_percent(:,1)) mysmooth(mean_rr1a_percentSM(:,1)) mysmooth(mean_rr1a_percentC(:,1))], ...
                       [mysmooth(mean_rr1aSEM_percent(:,1)) mysmooth(mean_rr1aSEM_percentSM(:,1)) mysmooth(mean_rr1aSEM_percentC(:,1))])
                   
                   
figure, plotmsd4(tt, [mysmooth(mean_yproj2max_percent(:,1)) mysmooth(mean_yproj2max_percentSM(:,1)) mysmooth(mean_yproj2max_percentC(:,1))], ...
                       [mysmooth(mean_yproj2maxSEM_percent(:,1)) mysmooth(mean_yproj2maxSEM_percentSM(:,1)) mysmooth(mean_yproj2maxSEM_percentC(:,1))])
 
figure, plotmsd4(tt, [mean_rr2a_percent(:,1) mean_rr2a_percentC(:,1) mean_rr2a_percentW(:,1)], ...
                       [mean_rr2aSEM_percent(:,1) mean_rr2aSEM_percentC(:,1) mean_rr2aSEM_percentW(:,1)])
                   
                                     

figure, plotmsd4(tt, [mean_rr1a_percent(:,1) mean_rr1a_percentC(:,1) mean_rr1a_percentW(:,1)], ...
                       [mean_rr1aSEM_percent(:,1) mean_rr1aSEM_percentC(:,1) mean_rr1aSEM_percentW(:,1)])
                   
                   
figure, plotmsd4(tt, [mysmooth(mean_rr1a_percent(:,1)) mysmooth(mean_yproj2max_percent(:,1))], ...
                       [mysmooth(mean_rr1aSEM_percent(:,1)) mysmooth(mean_yproj2maxSEM_percent(:,1))])
                   
figure, plotmsd4(tt, [mysmooth(mean_rr1a_percentSM(:,1)) mysmooth(mean_yproj2max_percentSM(:,1))], ...
                       [mysmooth(mean_rr1aSEM_percentSM(:,1)) mysmooth(mean_yproj2maxSEM_percentSM(:,1))])               

figure, plotmsd4(tt, [all_rr1a_percent(:,1) all_yproj2max_percent(:,1)*-1], ...
                       [all_rr1nSEM_percent(:,1) all_yproj2max_SEMpercent(:,1)*-1])
