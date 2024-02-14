%%controls across animals
ControlAll=[];
allnames={	
'Tser4883_res_cfr4.mat'	
'Tser5198_res_cfr3.mat'
'Tser5205_res_cfr3.mat'
};
groupname='ControlAll';

all_rr1a_micronsC=[];
all_rr1aSEM_micronsC=[];
all_rr1a_percentC=[];
all_rr1aSEM_percentC=[];
all_rr2a_micronsC=[];
all_rr2aSEM_micronsC=[];
all_rr2a_percentC=[];
all_rr2aSEM_percentC=[];
all_yproj2max_percentC=[];
all_yproj2max_SEMpercentC=[];


for ii = 1:length(allnames)
    
    load(allnames{ii})

    all_rr1a_micronsC=[all_rr1a_micronsC rr1a_microns_vessel_Final];
    all_rr1aSEM_micronsC=[all_rr1aSEM_micronsC rr1a_microns_vesselSEM_Final];
    
    all_rr1a_percentC=[all_rr1a_percentC rr1a_percent_vessel_Final]; 
    all_rr1aSEM_percentC=[all_rr1aSEM_percentC rr1a_percent_vesselSEM_Final];
    
    all_rr2a_micronsC= [all_rr2a_micronsC rr2a_microns_vessel_Final];
    all_rr2aSEM_micronsC=[all_rr2aSEM_micronsC rr2a_microns_vesselSEM_Final];
    
    all_rr2a_percentC=[all_rr2a_percentC rr2a_percent_vessel_Final]; 
    all_rr2aSEM_percentC=[all_rr2aSEM_percentC rr2a_percent_vesselSEM_Final];
    
    all_yproj2max_percentC=[all_yproj2max_percentC yproj2max_percent_intFinal];
    all_yproj2max_SEMpercentC=[all_yproj2max_SEMpercentC yproj2max_SEMpercent_intFinal]; 
   
end

save(groupname,'allnames','all_rr1a_micronsC','all_rr1aSEM_micronsC','all_rr1a_percentC',...
    'all_rr1aSEM_percentC','all_rr2a_micronsC','all_rr2aSEM_micronsC','all_rr2a_percentC',...
    'all_rr2aSEM_percentC','all_yproj2max_percentC','all_yproj2max_SEMpercentC','tt')
%%
mean_rr1a_micronsC=mean(all_rr1a_micronsC,2);
mean_rr1aSEM_micronsC=mean(all_rr1aSEM_micronsC,2);

mean_rr1a_percentC=mean(all_rr1a_percentC,2);
mean_rr1aSEM_percentC=mean(all_rr1aSEM_percentC,2);

mean_rr2a_micronsC=mean(all_rr2a_micronsC,2);
mean_rr2aSEM_micronsC=mean(all_rr2aSEM_micronsC,2)

mean_rr2a_percentC=mean(all_rr2a_percentC,2);
mean_rr2aSEM_percentC=mean(all_rr2aSEM_percentC,2)

mean_yproj2max_percentC=mean(all_yproj2max_percentC,2)
mean_yproj2maxSEM_percentC=mean(all_yproj2max_SEMpercentC,2);

%%
%load 'ControlAll'
%idx=find(tt>=1&tt<2)
tstart=1;
tstop=2;

rr1a_micromeansC=nanmean(all_rr1a_micronsC(tt>=tstart&tt<tstop,:));
rr1a_microsemC=nanstd(rr1a_micromeansC)/sqrt(size(rr1a_micromeansC,2));

rr1a_percentmeansC=nanmean(all_rr1a_percentC(tt>=tstart&tt<tstop,:));
%rr1a_percentsemC2=nanmean(all_rr1aSEM_percentC(tt>=tstart&tt<tstop,:));
rr1a_percentsemC=nanstd(rr1a_percentmeansC)/sqrt(size(rr1a_percentmeansC,2));

rr2a_micromeansC=nanmean(all_rr2a_micronsC(tt>=tstart&tt<tstop,:));
rr2a_microsemC=nanstd(rr2a_micromeansC)/sqrt(size(rr2a_micromeansC,2));

rr2a_percentmeansC=nanmean(all_rr2a_percentC(tt>=tstart&tt<tstop,:));
rr2a_percentsemC=nanstd(rr2a_percentmeansC)/sqrt(size(rr2a_percentmeansC,2));

yproj2max_percentmeansC=nanmean(all_yproj2max_percentC(tt>=tstart&tt<tstop,:));
yproj2max_percentSEMC=nanmean(all_yproj2max_SEMpercentC(tt>=tstart&tt<tstop,:));
yproj2max_percentsemC=nanstd(yproj2max_percentmeansC)/sqrt(size(yproj2max_percentmeansC,2));

groupname='BarMeansControl'
save(groupname,'rr1a_micromeansC','rr1a_microsemC','rr1a_percentmeansC','rr1a_percentsemC',...
'rr2a_micromeansC','rr2a_microsemC','rr2a_percentmeansC','yproj2max_percentmeansC','yproj2max_percentsemC')
%%
figure;
bar([nanmean(rr1a_percentmeansC)])
hold on
errorbar([nanmean(rr1a_percentmeansC, rr1a_percentsemC)], 'k.')

%%


figure, plotmsd4(tt, mean_rr1a_percentC, mean_rr1aSEM_percentC)
xlabel('time')
ylabel('percent')
set(gca,'tickdir','out')

figure, plotmsd4(tt, mean_yproj2max_percentC, mean_yproj2maxSEM_percentC)
xlabel('time')
ylabel('percent')
set(gca,'tickdir','out')