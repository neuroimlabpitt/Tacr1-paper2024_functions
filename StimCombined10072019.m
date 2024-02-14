%To combine vessel diameter along pericytes across animals
stimAllTrials=[];
allnames={	
'Tser4954b_res_cfr.mat'
'Tser4954c_res_cfr.mat'	
'Tser5199_res_cfr.mat'
'Tser5072_res_cfr.mat'
'Tser5215_res_cfr.mat'
};
groupname='stimAllTrials';


all_rr1a_microns=[];
all_rr1aSEM_microns=[];
all_rr1a_percent=[];
all_rr1aSEM_percent=[];
all_rr2a_microns=[];
all_rr2aSEM_microns=[];
all_rr2a_percent=[];
all_rr2aSEM_percent=[];
all_yproj2max_percent=[];
all_yproj2max_SEMpercent=[];


for ii = 1:length(allnames)
    
    load(allnames{ii})
    
    all_rr1a_microns=[all_rr1a_microns rr1a_microns_vessel_Final];
    all_rr1aSEM_microns=[all_rr1aSEM_microns rr1a_microns_vesselSEM_Final];
    
    all_rr1a_percent=[all_rr1a_percent rr1a_percent_vessel_Final]; 
    all_rr1aSEM_percent=[all_rr1aSEM_percent rr1a_percent_vesselSEM_Final];
    
    all_rr2a_microns = [all_rr2a_microns rr2a_microns_vessel_Final];
    all_rr2aSEM_microns=[all_rr2aSEM_microns rr2a_microns_vesselSEM_Final];
    
    all_rr2a_percent=[all_rr2a_percent rr2a_percent_vessel_Final]; 
    all_rr2aSEM_percent=[all_rr2aSEM_percent rr2a_percent_vesselSEM_Final];
    
    all_yproj2max_percent=[all_yproj2max_percent yproj2max_percent_intFinal];
    all_yproj2max_SEMpercent=[all_yproj2max_SEMpercent yproj2max_SEMpercent_intFinal];
    
end

save(groupname,'allnames','all_rr1a_microns','all_rr1aSEM_microns','all_rr1a_percent',...
    'all_rr1aSEM_percent','all_rr2a_microns','all_rr2aSEM_microns','all_rr2a_percent',...
    'all_rr2aSEM_percent','all_yproj2max_percent','all_yproj2max_SEMpercent','tt')

%%
mean_rr1a_microns=mean(all_rr1a_microns,2);
mean_rr1aSEM_microns=mean(all_rr1aSEM_microns,2);

mean_rr1a_percent=mean(all_rr1a_percent,2);
mean_rr1aSEM_percent=mean(all_rr1aSEM_percent,2);

mean_rr2a_microns=mean(all_rr2a_microns,2);
mean_rr2aSEM_microns=mean( all_rr2aSEM_microns,2);

mean_rr2a_percent=mean(all_rr2a_percent,2);
mean_rr2aSEM_percent=mean(all_rr2aSEM_percent,2);

mean_yproj2max_percent=mean(all_yproj2max_percent,2);
mean_yproj2maxSEM_percent=mean(all_yproj2max_SEMpercent,2);

groupname='Stim_meanTrace'
save (groupname, 'mean_rr1a_microns','mean_rr1aSEM_microns', 'mean_rr1a_percent','mean_rr1a_microns',...
    'mean_rr2a_microns', 'mean_rr2aSEM_microns', 'mean_rr2a_percent', 'mean_rr2aSEM_percent', ...
    'mean_yproj2max_percent', 'mean_yproj2maxSEM_percent', 'tt')

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
figure, plotmsd4(tt, [mysmooth(mean_rr1a_percent(:,1)) mysmooth(mean_rr1a_percentC(:,1)) mysmooth(mean_rr1a_percentW(:,1))], ...
                       [mysmooth(mean_rr1aSEM_percent(:,1)) mysmooth(mean_rr1aSEM_percentC(:,1)) mysmooth(mean_rr1aSEM_percentW(:,1))])

figure, plotmsd4(tt, [mean_rr1a_percent(:,1) mean_rr1a_percentC(:,1) mean_rr1a_percentW(:,1)], ...
                       [mean_rr1aSEM_percent(:,1) mean_rr1aSEM_percentC(:,1) mean_rr1aSEM_percentW(:,1)])
                   
figure, plotmsd4(tt, [mysmooth(mean_yproj2max_percent(:,1)) mysmooth(mean_yproj2max_percentC(:,1)) mysmooth(mean_yproj2max_percentW(:,1))], ...
                       [mysmooth(mean_yproj2maxSEM_percent(:,1)) mysmooth(mean_yproj2maxSEM_percentC(:,1)) mysmooth(mean_yproj2maxSEM_percentW(:,1))])
 
figure, plotmsd4(tt, [mean_rr2a_percent(:,1) mean_rr2a_percentC(:,1) mean_rr2a_percentW(:,1)], ...
                       [mean_rr2aSEM_percent(:,1) mean_rr2aSEM_percentC(:,1) mean_rr2aSEM_percentW(:,1)])
                   
                                     

figure, plotmsd4(tt, [mean_rr1a_percent(:,1) mean_rr1a_percentC(:,1) mean_rr1a_percentW(:,1)], ...
                       [mean_rr1aSEM_percent(:,1) mean_rr1aSEM_percentC(:,1) mean_rr1aSEM_percentW(:,1)])
                   
                   
figure, plotmsd4(tt, [mysmooth(mean_rr1a_percent(:,1)) mysmooth(mean_yproj2max_percent(:,1))], ...
                       [mysmooth(mean_rr1aSEM_percent(:,1)) mysmooth(mean_yproj2maxSEM_percent(:,1))])

figure, plotmsd4(tt, [all_rr1a_percent(:,1) all_yproj2max_percent(:,1)*-1], ...
                       [all_rr1nSEM_percent(:,1) all_yproj2max_SEMpercent(:,1)*-1])

                   
%% bar plots

%idx=find(tt>=1&tt<2)
tstart=1;
tstop=2;

rr1a_micromeans=nanmean(all_rr1a_microns(tt>=tstart&tt<tstop,:));
rr1a_microsem=nanstd(rr1a_micromeans)/sqrt(size(rr1a_micromeans,2));
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



