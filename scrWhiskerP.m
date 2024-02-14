%WhiskerP.mat
%% whisker pericyte means for trace
mean_rr1a_micronsWsm=mean(all_rr1a_micronsW,2);
mean_rr1aSEM_micronsWs=mean(all_rr1nSEM_micronsW,2);

mean_rr1a_percentW=mean(all_rr1a_percentW,2);
mean_rr1aSEM_percentW=mean(all_rr1nSEM_percentW,2);

mean_rr2a_micronsW=mean(all_rr2a_micronsW,2);
mean_rr2aSEM_micronsW=mean(all_rr2nSEM_micronsW,2)

mean_rr2a_percentW=mean(all_rr2a_percentW,2);
mean_rr2aSEM_percentW=mean(all_rr2nSEM_percentW,2)

mean_yproj2max_percentW=mean(all_yproj2max_percentW,2)
mean_yproj2maxSEM_percentW=mean(all_yproj2max_SEMpercentW,2);

%%
figure, plotmsd4(tt, [mean_rr1a_percentW(:,1) mean_yproj2max_percentW(:,1)], ...
                       [mean_rr1aSEM_percentW(:,1) mean_yproj2maxSEM_percentW(:,1)])
                   
                   
figure, plotmsd4(tt, [mean_rr1a_percentW(:,1) mean_rr1a_percentWsm(:,1) mean_yproj2max_percentW(:,1) mean_yproj2max_percentWsm(:,1)], ...
                       [mean_rr1aSEM_percentW(:,1) mean_rr1aSEM_percentWsm(:,1) mean_yproj2maxSEM_percentW(:,1) mean_yproj2maxSEM_percentWsm(:,1)])
                   
figure, plotmsd4(tt, [mysmooth(mean_rr1a_percentW(:,1)) mysmooth(mean_rr1a_percentWsm(:,1)) mysmooth(mean_yproj2max_percentW(:,1)) mysmooth(mean_yproj2max_percentWsm(:,1))], ...
                       [mysmooth(mean_rr1aSEM_percentW(:,1)) mysmooth(mean_rr1aSEM_percentWsm(:,1)) mysmooth(mean_yproj2maxSEM_percentW(:,1)) mysmooth(mean_yproj2maxSEM_percentWsm(:,1))])