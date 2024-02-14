something= [dyn1l1p0a_nk1r_bioall.tt (([mean(dyn1l1p0a_nk1r_bioall.FLUX,2)-tmpfix*0.05,...
                        mean(dyn1l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.16,...
                        mean(dyn1l1p0c_nk1r_bioall.FLUX,2)-tmpfix*0.15,...
                        mean(dyn1wh1_nk1r_bioall.FLUX,2)]-1)*100)];
                    
 
somethingStd= [dyn1l1p0a_nk1r_bioall.tt (([std(dyn1l1p0aS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1l1p0aS_nk1r_bioall.FLUX,2)))...
                std(dyn1l1p0bS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1l1p0bS_nk1r_bioall.FLUX,2)))...
                std(dyn1l1p0cS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1l1p0cS_nk1r_bioall.FLUX,2)))...
                std(dyn1wh1_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1wh1S_nk1r_bioall.FLUX,2)))].*100))];
            
            
       
(dyn1l1p0b_nk1r_bioall.tt,([mean(dyn1l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.16,...
                        mean(dyn2l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.28,...
                        mean(dyn4l1p0b_nk1r_bioall.FLUX,2)+tmpfix*0.0,...
                        mean(dyn8l1p0b_nk1r_bioall.FLUX,2)+tmpfix*0.20]-1)*100)
            
%%
a=((mean(dyn1l1p0a_nk1r_bioall.FLUX,2)-tmpfix*0.05)-1)*100;
b=((mean(dyn1l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.16)-1)*100;
c=((mean(dyn1l1p0c_nk1r_bioall.FLUX,2)-tmpfix*0.15)-1)*100;
d=(mean(dyn1wh1_nk1r_bioall.FLUX,2)-1)*100;

aste=(std(dyn1l1p0aS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1l1p0aS_nk1r_bioall.FLUX,2))))*100;
bste=(std(dyn1l1p0bS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1l1p0bS_nk1r_bioall.FLUX,2))))*100;
cste=(std(dyn1l1p0cS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1l1p0cS_nk1r_bioall.FLUX,2))))*100;
dste=(std(dyn1wh1_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1wh1_nk1r_bioall.FLUX,2))))*100;

something= [dyn1l1p0a_nk1r_bioall.tt, a, b, c, d];
somethingStd= [dyn1l1p0a_nk1r_bioall.tt aste bste cste dste];

filtsize=41;
af= sgolayfilt(a,2,filtsize);
bf= sgolayfilt(b,2,filtsize);
cf= sgolayfilt(c,2,filtsize);
df= sgolayfilt(d,2,filtsize);

afste= sgolayfilt(aste,2,filtsize);
bfste= sgolayfilt(bste,2,filtsize);
cfste= sgolayfilt(cste,2,filtsize);
dfste= sgolayfilt(dste,2,filtsize);

somethingf= [dyn1l1p0a_nk1r_bioall.tt, af, bf, cf, df];
somethingfste= [dyn1l1p0a_nk1r_bioall.tt afste bfste cfste dfste];

afreq=((mean(dyn1l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.16)-1)*100;
bfreq=((mean(dyn2l1p0b_nk1r_bioall.FLUX,2)-tmpfix*0.28)-1)*100;
cfreq=((mean(dyn4l1p0b_nk1r_bioall.FLUX,2)+tmpfix*0.0)-1)*100;
dfreq=((mean(dyn8l1p0b_nk1r_bioall.FLUX,2)+tmpfix*0.20)-1)*100;

afreqsem=(std(dyn1l1p0bS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1l1p0bS_nk1r_bioall.FLUX,2))))*100;
bfreqsem=(std(dyn2l1p0bS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn2l1p0bS_nk1r_bioall.FLUX,2))))*100;
cfreqsem=(std(dyn4l1p0bS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn4l1p0bS_nk1r_bioall.FLUX,2))))*100;
dfreqsem=(std(dyn8l1p0bS_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn8l1p0bS_nk1r_bioall.FLUX,2))))*100;           

nk1r1secfreq= [dyn1l1p0bS_nk1r_bioall.tt, afreq, bfreq, cfreq, dfreq];
nk1r1secfreqsem= [dyn1l1p0bS_nk1r_bioall.tt, afreqsem, bfreqsem, cfreqsem, dfreqsem];

wh1sec=(mean(dyn1wh1_nk1r_bioall.FLUX,2)-1)*100; 
wh4sec=(mean(dyn1wh1S_nk1r_bioall.FLUX,2)-1)*100;
wh10sec=(mean(dyn1wh1L_nk1r_bioall.FLUX,2)-1)*100;

wh1secsem=(std(dyn1wh1_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1wh1_nk1r_bioall.FLUX,2))))*100;
wh4secsem=(std(dyn1wh1S_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1wh1S_nk1r_bioall.FLUX,2))))*100;
wh10secsem=(std(dyn1wh1L_nk1r_bioall.FLUX,[],2)./(sqrt(size(dyn1wh1L_nk1r_bioall.FLUX,2))))*100;

wh1mean= [dyn1wh1_nk1r_bioall.tt, wh1sec, wh1secsem];
wh4mean= [dyn1wh1S_nk1r_bioall.tt, wh4sec, wh4secsem];
wh10mean= [dyn1wh1L_nk1r_bioall.tt, wh10sec, wh10secsem];