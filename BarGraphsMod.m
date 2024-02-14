
rr1a_percentmeansC=[];
rr1a_percentmeans=[];
rr1a_percentmeansSM=[];
rr1a_percentsemC=[];
rr1a_percentsem=[];
rr1a_percentsemSM=[];

figure;
bar([nanmean(rr1a_percentmeansC) nanmean(rr1a_percentmeans) nanmean(rr1a_percentmeansSM)])
hold on
errorbar([nanmean(rr1a_percentmeansC) nanmean(rr1a_percentmeans) nanmean(rr1a_percentmeansSM)],[rr1a_percentsemC rr1a_percentsem rr1a_percentsemSM], 'k.')

scatter(ones(1,length(rr1a_percentmeansC)),rr1a_percentmeansC,'k.')
scatter(ones(1,length(rr1a_percentmeans)).*2,rr1a_percentmeans,'k.')
scatter(ones(1,length(rr1a_percentmeansSM)).*3,rr1a_percentmeansSM,'k.')

figure;
bar([nanmean(yproj2max_percentmeansC) nanmean(yproj2max_percentmeans) nanmean(yproj2max_percentmeansSM)])
hold on
errorbar([nanmean(yproj2max_percentmeansC) nanmean(yproj2max_percentmeans) nanmean(yproj2max_percentsemSM)],[yproj2max_percentsemC yproj2max_percentsem yproj2max_percentsemSM], 'k.')

scatter(ones(1,length(yproj2max_percentmeansC)),yproj2max_percentmeansC,'k.')
scatter(ones(1,length(yproj2max_percentmeans)).*2,yproj2max_percentmeans,'k.')
scatter(ones(1,length(yproj2max_percentmeansSM)).*3,yproj2max_percentmeansSM,'k.')