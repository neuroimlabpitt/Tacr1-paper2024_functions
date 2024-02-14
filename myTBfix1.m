function [ynew2,tmpi]=myTBfix1(y,ref,thr,off1)
% Usage ... [y_new,ii]=myTBfix1(y,ref_tb,thr,aoff)
%
% Uses REF and THR to correct changes in Y

if nargin<4, off1=[]; end;

do_many=1;
if prod(size(y))==length(y), do_many=0; end;
if do_many,
  if size(ref,2)==1, ref=ref(:)*ones(length(ref),size(y,2)); end;
end;

if do_many,
  for mm=1:size(y,2),
    if length(thr)>1,
      tmpi=thr;
    else,
      tmpi=find(ref(1+50:end/2,mm)>thr)+50;
      tmpfix=zeros(size(y(:,mm)));
    end;
    if isempty(tmpi),
      ynew2(:,mm)=y(:,mm);
    else,
      ynew=y(:,mm);
      tmpi1=[tmpi(1)+50 tmpi(end)-50];
      tmpb1=[mean(y(tmpi1(1)+[-25:25],mm)) mean(y(tmpi1(2)+[-25:25],mm))];
      tmpi2=[tmpi(1)-50 tmpi(end)+50];
      tmpb2=[mean(y(tmpi2(1)+[-25:25],mm)) mean(y(tmpi2(2)+[-25:25],mm))];
      ynew(tmpi)=y(tmpi)-tmpb1(1);
      tmpyf=polyval(polyfit(tmpi2(:),ynew(tmpi2),1),tmpi1(:));
      tmpb3=[mean(ynew(tmpi2(1)+[-25:25])) mean(ynew(tmpi2(2)+[-25:25]))];
      ynew1=ynew;
      tmpfix(tmpi)=1;
      ynew1(tmpi)=ynew(tmpi)+mean(tmpb3(:)-tmpyf(:));
      if ~isempty(off1), ynew1=ynew1+off1*tmpfix; end;
      ynew2(:,mm)=ynew1;
      if nargout==0,
        clf,
        subplot(211), plot(ref,mm), fatlines(1.5); title(sprintf('#%d',mm));
        subplot(212), plot([y(:,mm) ynew2(:,mm)]), fatlines(1.5); legend('orig','new2');
        pause,
      end;
    end;
  end;
else,
  if length(thr)>1,
    tmpi=thr;
  else,
    tmpi=find(ref(1+50:end/2)>thr)+50;
    tmpfix=zeros(size(y));
  end;
  if isempty(tmpi),
    disp(sprintf('  no entries to fix based on thr= %.3f',thr));
    ynew2=y;
  else,
    ynew=y;
    tmpi1=[tmpi(1)+50 tmpi(end)-50];
    tmpb1=[mean(y(tmpi1(1)+[-25:25])) mean(y(tmpi1(2)+[-25:25]))];
    tmpi2=[tmpi(1)-50 tmpi(end)+50];
    tmpb2=[mean(y(tmpi2(1)+[-25:25])) mean(y(tmpi2(2)+[-25:25]))];
    ynew(tmpi)=y(tmpi)-tmpb1(1);
    tmpyf=polyval(polyfit(tmpi2(:),ynew(tmpi2),1),tmpi1(:));
    tmpb3=[mean(ynew(tmpi2(1)+[-25:25])) mean(ynew(tmpi2(2)+[-25:25]))];
    ynew2=ynew;
    ynew2(tmpi)=ynew(tmpi)+mean(tmpb3(:)-tmpyf(:));
    tmpfix(tmpi)=1;
    if ~isempty(off1), ynew2=ynew2+off1*tmpfix; end;
    if nargout==0,
      clf,
      subplot(211), plot(ref), fatlines(1.5);
      subplot(212), plot([y(:) ynew2(:)]), fatlines(1.5); legend('orig','new2');
      %pause,
    end;
  end;
end;

