mean_rr1a_micronsWsm=mean(all_rr1a_micronsWsm,2);
mean_rr1aSEM_micronsWsm=mean(all_rr1aSEM_micronsWsm,2);

mean_rr1a_percentWsm=mean(all_rr1a_percentWsm,2);
mean_rr1aSEM_percentWsm=mean(all_rr1aSEM_percentWsm,2);

mean_rr2a_micronsWsm=mean(all_rr2a_micronsWsm,2);
mean_rr2aSEM_micronsWsm=mean(all_rr2aSEM_micronsWsm,2);

mean_rr2a_percentWsm=mean(all_rr2a_percentWsm,2);
mean_rr2aSEM_percentWsm=mean(all_rr2aSEM_percentWsm,2);

mean_yproj2max_percentWsm=mean(all_yproj2max_percentWsm,2);
mean_yproj2maxSEM_percentWsm=mean(all_yproj2max_SEMpercentWsm,2);




%%
figure, plotmsd4(tt, [mean_rr1a_percentWsm(:,1) mean_yproj2max_percentWsm(:,1)], ...
                       [mean_rr1aSEM_percentWsm(:,1) mean_yproj2maxSEM_percentWsm(:,1)])
                   
figure, plotmsd4(tt, [mean_yproj2max_percentWsm(:,1) mean_yproj2maxSEM_percentWsm(:,1)])
plot(tt, mean_yproj2max_percentWsm(:,1))