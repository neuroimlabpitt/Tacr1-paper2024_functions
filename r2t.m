function t=r2t(r,df)
% Usage ... t=r2t(r,df)

tmpi=find(r>=1);
if ~isempty(tmpi),
  disp('  warning: r>=1');
  r(tmpi)=1-eps*1e3; 
end;
if df<3,
  disp('  warning: df < 3, settting df=3');
  df=3;
end;

t=r*sqrt(df-2)./sqrt(1-abs(r.*r));

