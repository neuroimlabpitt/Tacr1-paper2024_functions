function dopapersize(newsize)

% newsize needs to exist (e.g. newsize=[9 8]; )
set(gcf,'Units','inches');
papersize=get(gcf,'Position');
newpapersize=[papersize(1:2) papersize(3:4).*(newsize./[8 6])];
set(gcf,'Position',newpapersize);
set(gcf,'PaperSize',newsize);
set(gcf,'PaperPositionMode','auto');

