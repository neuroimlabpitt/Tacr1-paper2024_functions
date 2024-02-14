function plotmsd4(x,y,s,cc1,leg)
% Usage ... plotmsd4(x,y,s,c)
%
% Plots the vector y against vector x overlaying a shaded region
% by s using the color defined in c. The figure to plot should be
% cleared to avoid transparency problems.
%
% Ex. plotmsd4([0:0.05:20],sin(2*pi*0.15*[0:0.05:20]+pi/3),ones(1,length([0:0.05:20]))*0.2)


%figh=figure; clf;

if ~exist('cc1','var'), cc1=[]; end;
if ~exist('leg','var'), leg=[]; end;

do_legend=0;
if ~isempty(leg), do_legend=1; tmpstr=['legend(']; end;

if nargin==1,
  y=mean(x,2);
  s=std(x,[],2);
  x=[1:length(y)]';
elseif nargin==2,
  if length(x)==length(y),
    s=std(y,[],2);
    y=mean(y,2);
  else,
    s=std(x,[],2);
    cc1=y;
    y=mean(x,2);
    x=[1:length(x)];
  end;
end;

figh=gcf;
if length(y)==prod(size(y)),
  if isempty(cc1), cc1=[1 1 1]*0.8; end;
  fh=fill([x(:);flipud(x(:))],[y(:)-s(:);flipud([y(:)+s(:)])],cc1,'LineStyle','none');
  set(fh,'facealpha',0.5);
  hold('on'),
  plot(x(:),y(:),'Color',[0 0 1]),
  hold('off'),
  axis('tight'), grid('on'),
else,
  if isempty(cc1),
    cc1=colormap(jet(size(y,2)));
    if size(y,2)<5,
      cc1=[0 0 1; 1 0 0; 0 0.5 0; 0.5 0 1; 1 0.5 0; 0 0.5 0.5];
    end;
  end;
  hold('on'),
  for mm=1:size(y,2),
    %plot(x(:),y(:,mm),'Color',cc1(mm,:),'LineWidth',1.0),
    plot(x(:),y(:,mm),'Color',cc1(mm,:));
    if do_legend, tmpstr=sprintf('%s''%s'',',tmpstr,leg{mm}); end;
  end;
  if do_legend, tmpstr=tmpstr(1:end-1); tmpstr=[tmpstr,');']; eval(tmpstr); end;
  for mm=1:size(y,2),
    fh(mm)=fill([x(:);flipud(x(:))],[[y(:,mm)-s(:,mm)];flipud([y(:,mm)+s(:,mm)])],cc1(mm,:),'LineStyle','none');
    set(fh(mm),'facealpha',0.15);
    %plot(x(:),y(:,mm),'Color',cc1(mm,:));
  end;
  hold('off'),
  if do_legend, tmph=legend; tmph.String=leg; end;
  axis('tight'), grid('on'),
end;
set(gca,'Box','on');

