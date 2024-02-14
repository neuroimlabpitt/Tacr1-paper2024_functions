function dartest
% pull out rr1 and SEM and make plot from all files
%20190812

names={
'TSer4772_res.mat'	
'Tser4773_res.mat'	
}

vessel{1} = 1;
vessel{2} = 2 4 5;
vessel{3} = 1 2 3 4;


all_rr1a=[];
all_rr1nSEM=[];

for ii = 1:length(names)
    
    load(names{ii})
    
    all_rr1a = [all_rr1a rr1a_percent];
    all_rr1nSEM=[all_rr1nSEM rr1nSEM_percent(:,2)];
end

close, plotmsd4(tt, all_rr1a, all_rr1nSEM)

end

close, plotmany((tt), rr1a*info.PV_shared.micronsPerPixel{1}) % plot of avg 150 frames converted to microns MICRON GRAPH
plotmsd4(tt,rr1avg(:,2)*info.PV_shared.micronsPerPixel{1},rr1std(:,2)*info.PV_shared.micronsPerPixel{1}/sqrt(ntr)) % microns and SEM for ROI 2
plotmsd4(tt,rr1avg*info.PV_shared.micronsPerPixel{1},rr1std*info.PV_shared.micronsPerPixel{1}/sqrt(ntr)) % for all ROI on one graph with SEM