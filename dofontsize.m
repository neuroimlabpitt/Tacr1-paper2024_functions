function a = dofontsize(sz)
dlha = get(gca,'Title');
set(dlha(:),'FontSize',sz);
dlha = get(gca,'XLabel');
set(dlha(:),'FontSize',sz);
dlha = get(gca,'YLabel');
set(dlha(:),'FontSize',sz);
dlha = get(gca,'ZLabel');
%set(dlha(:),'FontSize',sz);
%dlha = get(gca,'ZTickLabels');
set(dlha(:),'FontSize',sz);
a = sz;
