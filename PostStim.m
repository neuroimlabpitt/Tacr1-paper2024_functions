%% PostStim 
%idx=find(tt>=1&tt<2)
tstart=1;
tstop=3;

%load 'StimSM'
rr1a_percentmeansSM=nanmean(all_rr1a_percentSM(tt>=tstart&tt<tstop,:));
rr1a_percentsemSM=nanstd(rr1a_percentmeansSM)/sqrt(size(rr1a_percentmeansSM,2));

%load 'stimAllTrials';
rr1a_percentmeans=nanmean(all_rr1a_percent(tt>=tstart&tt<tstop,:));
rr1a_percentsem=nanstd(rr1a_percentmeans)/sqrt(size(rr1a_percentmeans,2));

%%yproj (GCaMP)
tstart_ii=0.5;
tstop_ii=1.5;

yproj2max_percentmeans=nanmean(all_yproj2max_percent(tt>=tstart_ii&tt<tstop_ii,:));
yproj2max_percentsem=nanstd(yproj2max_percentmeans)/sqrt(size(yproj2max_percentmeans,2));

yproj2max_percentmeansSM=nanmean(all_yproj2max_percentSM(tt>=tstart_ii&tt<tstop_ii,:));
yproj2max_percentsemSM=nanstd(yproj2max_percentmeansSM)/sqrt(size(yproj2max_percentmeansSM,2));

%See Baseline for figures