%% PEAK AMP (bar graphs)
load stimAllTrials
%idx=find(tt>=1&tt<2)
tstart=1;
tstop=2;

% rr1a_micromeans=nanmean(all_rr1a_microns(tt>=tstart&tt<tstop,:));
% rr1a_microsem=nanstd(rr1a_micromeans)/sqrt(size(rr1a_micromeans,2));

rr1a_percentmeans=nanmean(all_rr1a_percent(tt>=tstart&tt<tstop,:));
rr1a_percentsem=nanstd(rr1a_percentmeans)/sqrt(size(rr1a_percentmeans,2));
% 
% rr2a_micromeans=nanmean(all_rr2a_microns(tt>=tstart&tt<tstop,:));
% rr2a_microsem=nanstd(rr2a_micromeans)/sqrt(size(rr2a_micromeans,2));

% rr2a_percentmeans=nanmean(all_rr2a_percent(tt>=tstart&tt<tstop,:));
% rr2a_percentsem=nanstd(rr2a_percentmeans)/sqrt(size(rr2a_percentmeans,2));
% 
% yproj2max_percentmeans=nanmean(all_yproj2max_percent(tt>=tstart&tt<tstop,:));
% yproj2max_percentsem=nanstd(yproj2max_percentmeans)/sqrt(size(yproj2max_percentmeans,2));


%rr1a_micromeans=nanmean(all_rr1a_microns(tt>=tstart&tt<tstop,:));
%rr1a_microsem=nanstd(rr1a_micromeans)/sqrt(size(rr1a_micromeans,2));

%%
figure;
bar(nanmean(rr1a_micromeans))
hold on
errorbar(nanmean(rr1a_micromeans),rr1a_microsem,'k.')


rr1a_percentmeans=nanmean(all_rr1a_percent(tt>=tstart&tt<tstop,:));
rr1a_percentsem=nanstd(rr1a_percentmeans)/sqrt(size(rr1a_percentmeans,2));
figure;
bar(nanmean(rr1a_percentmeans))
hold on
errorbar(nanmean(rr1a_percentmeans),rr1a_percentsem,'k.')

yproj2max_percentmeans=nanmean(all_yproj2max_percent(tt>=tstart&tt<tstop,:));
yproj2max_percentsem=nanstd(yproj2max_percentmeans)/sqrt(size(yproj2max_percentmeans,2));
figure;
bar(nanmean(yproj2max_percentmeans))
hold on
errorbar(nanmean(yproj2max_percentmeans),yproj2max_percentsem,'k.')