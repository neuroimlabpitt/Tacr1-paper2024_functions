function plotmsd4Exclude2(x,y,s,ExcludeVals,cc)
% Usage ... plotmsd4(x,y,s,c)
%
% Plots the vector y against vector x overlaying a shaded region
% by s using the color defined in c. The figure to plot should be
% cleared to avoid transparency problems.
%
% Ex. plotmsd4([0:0.05:20],sin(2*pi*0.15*[0:0.05:20]+pi/3),ones(1,length([0:0.05:20]))*0.2)

%either flipud or fliplr

%figh=figure; clf;
fig=gcf;
if length(y)==prod(size(y)),
if ~exist('cc','var'), cc=[1 1 1]*0.8; end;
fh=fill([x(:);fliplr(x(:))],[y(:)-s(:);flipud([y(:)+s(:)])],cc,'LineStyle','none');
mm=1;
fh(mm)=fill([x(1:ExcludeVals(1)-1); fliplr(x(1:ExcludeVals(1)-1))]',[[y(1:ExcludeVals(1)-1,mm)-s(1:ExcludeVals(1)-1,mm)] ;fliplr([y(1:ExcludeVals(1)-1,mm)+s(1:ExcludeVals(1)-1,mm)])],cc(mm,:),'LineStyle','none'); 
set(fh,'facealpha',0.5);
hold('on'),
plot(x(1:ExcludeVals(1)-1),y(1:ExcludeVals(1)-1,mm),'Color',cc(mm,:));
fh(mm)=fill([x(ExcludeVals(end)+1:end); fliplr(x(ExcludeVals(end)+1:end))]',[[y(ExcludeVals(end)+1:end,mm)-s(ExcludeVals(end)+1:end,mm)] ;flipud([y(ExcludeVals(end)+1:end,mm)+s(ExcludeVals(end)+1:end,mm)])],cc(mm,:),'LineStyle','none');  
  set(fh(mm),'facealpha',0.5);
  plot(x(:),y(:,mm),'Color',cc(mm,:),'LineWidth',1.0),
  plot(x(ExcludeVals(end)+1:end),y(ExcludeVals(end)+1:end,mm),'Color',cc(mm,:));
  plot(x(:),y(:),'Color',[0 0 1]),    
  hold('off'),
  axis('tight'), grid('off'),
else,
  if ~exist('cc','var'),
    cc=colormap(jet(size(y,2)));
    if size(y,2)<5,
      cc=[0 0 1; 1 0 0; 0 0.5 0; 0.5 0 1; 1 0.5 0; 0 0.5 0.5];
    end;
  end;
  hold('on'),
  for mm=1:size(y,2),
    fh(mm)=fill([x(1:ExcludeVals(1)-1); fliplr(x(1:ExcludeVals(1)-1))]',[[y(1:ExcludeVals(1)-1,mm)-s(1:ExcludeVals(1)-1,mm)] ;fliplr([y(1:ExcludeVals(1)-1,mm)+s(1:ExcludeVals(1)-1,mm)])],cc(mm,:),'LineStyle','none');
    %fh(mm)=fill([x(1:ExcludeVals(1)-1); flipud(x(1:ExcludeVals(1)-1))]',[[y(1:ExcludeVals(1)-1,mm)-s(1:ExcludeVals(1)-1,mm)] ;flipud([y(1:ExcludeVals(1)-1,mm)+s(1:ExcludeVals(1)-1,mm)])],cc(mm,:),'LineStyle','none');
    set(fh(mm),'facealpha',0.15);
    plot(x(:),y(:,mm),'Color',cc(mm,:),'LineWidth',1.0),
    plot(x(1:ExcludeVals(1)-1),y(1:ExcludeVals(1)-1,mm),'Color',cc(mm,:));
    
    %
   fh(mm)=fill([x(ExcludeVals(end)+1:end); fliplr(x(ExcludeVals(end)+1:end))]',[[y(ExcludeVals(end)+1:end,mm)-s(ExcludeVals(end)+1:end,mm)] ;fliplr([y(ExcludeVals(end)+1:end,mm)+s(ExcludeVals(end)+1:end,mm)])],cc(mm,:),'LineStyle','none');
    %fh(mm)=fill([x(ExcludeVals(end)+1:end); flipud(x(ExcludeVals(end)+1:end))]',[[y(ExcludeVals(end)+1:end,mm)-s(ExcludeVals(end)+1:end,mm)] ;flipud([y(ExcludeVals(end)+1:end,mm)+s(ExcludeVals(end)+1:end,mm)])],cc(mm,:),'LineStyle','none');
    
    set(fh(mm),'facealpha',0.15);
    %plot(x(:),y(:,mm),'Color',cc(mm,:),'LineWidth',1.0),
    plot(x(ExcludeVals(end)+1:end),y(ExcludeVals(end)+1:end,mm),'Color',cc(mm,:));
    
  end;
  hold('off'),
  axis('tight'), grid('off'),
end;
set(gca,'Box','off');

