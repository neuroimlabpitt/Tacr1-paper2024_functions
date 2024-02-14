function quickmap_scr3(fname,fps,ntrials,trialdur,stimdur,offset,desiredres,baseims,actims,dipdur,panelims)
% Usage ... quickmap_scr(fname,fps,ntrials,trialdur,stimdur,offset,desiredres,baseims,actims,dipdur,panelims)

%fname='quick_map_towi1.raw';

%fps=30;
%ntrials=10;
%trialdur=16.0;
%stimdur=4.0;
%offset=4.0;         % 5 s original, 1 s for baseline
%desiredres=0.5;
%baseims=[1:2];
%actims=[3:4];
%dipdur=2.0;
%panelims=[1:16];

if (nargin<11), panelims=[1:16]; end;
if (nargin<10), dipdur=2.0; end;


matname=sprintf('%s',fname(1:end-4));

averageOIS3(fname,fps,ntrials,offset,trialdur,desiredres,0,1)

panels=showOISaverage(matname,baseims,2,1,panelims);
%panels=showOISaverage(fname,baseims,2,1,[1:16]);
eval(sprintf('save %s -append panels ',matname));

eval(sprintf('load %s ',matname));
actim=mean(avgim(:,:,actims),3);
actim=actim-mean(mean(actim));
tt=[1:size(avgim,3)]*desiredres;
ref620_dip=mytrapezoid(tt,1.0,dipdur,0.1);
ref620_pos=mytrapezoid(tt,1.0+dipdur,stimdur,0.1);
corr620_dip=OIS_corr2(avgim,ref620_dip);
corr620_pos=OIS_corr2(avgim,ref620_pos);
eval(sprintf('save %s -append tt actim ref620_dip ref620_pos corr620_dip corr620_pos',matname));

%subplot(211)
show(panels)
%subplot(223)
%show(corr620_dip'<-0.5)
%title('r < -0.5')
%subplot(224)
%show(corr620_pos'>+0.5)
%title('r > +0.5')
