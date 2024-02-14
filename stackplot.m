function stackplot(x,y,parms)
% Usage ... stackplot(x,y,options)

if nargin==1,
  y=x; 
  x=[1:length(y)];
end;

if ~exist('parms','var'), parms=[1]; end;

mean_plot = parms(1);
if length(parms)==1,
    ym=mean(y,2);
    ymin=min(ym);
    ymax=max(ym);
    spacing = 1.5*(ymax-ymin);
end

gcf=figure;
clf,

yshift=0;
for iii = 1:size(y,2)
    plot(x,y(:,iii)+yshift)
    yshift=yshift+spacing;
    if iii==1, hold('on'), end;
end
if mean_plot,
  plot(x,mean(y,2)-spacing,'k','Linewidth',3)
end

hold('off'),
