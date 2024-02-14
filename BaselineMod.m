%Baseline
%load 'StimSM', stimAllTrials';
tstart_i=-2;
tstop_i=0;

    % (StimCombined.m, stimAllTrials.mat)  
rr1a_percentmeansBase=nanmean(all_rr1a_percent(tt>=tstart_i&tt<tstop_i,:));
rr1a_percentsemBase=nanstd(rr1a_percentmeansBase)/sqrt(size(rr1a_percentmeansBase,2));

yproj2max_percentmeansBase=nanmean(all_yproj2max_percent(tt>=tstart_i&tt<tstop_i,:));
yproj2max_percentsemBase=nanstd(yproj2max_percentmeansBase)/sqrt(size(yproj2max_percentmeansBase,2));

    %(StimCombinedSM.m, StimSM.mat)
rr1a_percentmeansSMBase=nanmean(all_rr1a_percentSM(tt>=tstart_i&tt<tstop_i,:));
rr1a_percentsemSMBase=nanstd(rr1a_percentmeansSMBase)/sqrt(size(rr1a_percentmeansSMBase,2));

yproj2max_percentmeansSMBase=nanmean(all_yproj2max_percentSM(tt>=tstart_i&tt<tstop_i,:));
yproj2max_percentsemSMBase=nanstd(yproj2max_percentmeansSMBase)/sqrt(size(yproj2max_percentmeansSMBase,2));

%       %Control(ControlCombined.m ControlAll.mat)
% rr1a_percentmeansCBase=nanmean(all_rr1a_percentC(tt>=tstart_i&tt<tstop_i,:));
% rr1a_percentsemCBase=nanstd(rr1a_percentmeansCBase)/sqrt(size(rr1a_percentmeansCBase,2));
% 
% yproj2max_percentmeansCBase=nanmean(all_yproj2max_percentC(tt>=tstart_i&tt<tstop_i,:));
% yproj2max_percentsemCBase=nanstd(yproj2max_percentmeansCBase)/sqrt(size(yproj2max_percentmeansCBase,2));

%% for Vessels
figure;
bar([nanmean(rr1a_percentmeansBase) nanmean(rr1a_percentmeans)])
hold on
scatter(ones(1,length(rr1a_percentmeansBase)),rr1a_percentmeansBase,'k.')
scatter(ones(1,length(rr1a_percentmeans)).*2,rr1a_percentmeans,'k.')

figure;
bar([nanmean(rr1a_percentmeansSMBase) nanmean(rr1a_percentmeansSM)])
hold on
scatter(ones(1,length(rr1a_percentmeansSMBase)),rr1a_percentmeansSMBase,'k.')
scatter(ones(1,length(rr1a_percentmeansSM)).*2,rr1a_percentmeansSM,'k.')

%% for GCAMP
figure;
bar([nanmean(yproj2max_percentmeansBase) nanmean(yproj2max_percentmeans)])
hold on
scatter(ones(1,length(yproj2max_percentmeansBase)),yproj2max_percentmeansBase,'k.')
scatter(ones(1,length(yproj2max_percentmeans)).*2,yproj2max_percentmeans,'k.')

figure;
bar([nanmean(yproj2max_percentmeansSMBase) nanmean(yproj2max_percentmeansSM)])
hold on
scatter(ones(1,length(yproj2max_percentmeansSMBase)),yproj2max_percentmeansSMBase,'k.')
scatter(ones(1,length(yproj2max_percentmeans)).*2,yproj2max_percentmeans,'k.')


figure;
bar([nanmean(yproj2max_percentmeansBase) nanmean(yproj2max_percentmeans)])
hold on
scatter(ones(1,length(yproj2max_percentmeansBase)),yproj2max_percentmeansBase,'k.')
scatter(ones(1,length(yproj2max_percentmeans)).*2,yproj2max_percentmeans,'k.')

figure;
bar([nanmean(yproj2max_percentmeansSMBase) nanmean(yproj2max_percentmeansSM)])
scatter(ones(1,length(yproj2max_percentmeansSMBase)),yproj2max_percentmeansSMBase,'k.')
scatter(ones(1,length(yproj2max_percentmeans)).*2,yproj2max_percentmeans,'k.')
