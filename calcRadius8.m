function y=calcRadius8(im,inv_flag,thr,imselect)
% Usage ... y=calcRadius(im,inv_flag,thr,imselect)
%
% This function measures the vessel diameter (in pixels) of im which
% is the image only including the vessel to measure
% thr(1) is the normalized projection threshold (default=0.5)
% additinal arguments include thr(2)=bounding box width when
% engaging imselect as well as thr(3)=pca_keep and thr(4)=smw


if ~exist('inv_flag','var'), inv_flag=[]; end;
if ~exist('thr','var'), thr=[]; end;
if ~exist('imselect','var'), imselect=0; end;

if isempty(inv_flag), inv_flag=0; end;
if isempty(thr), thr=[0.5]; end;

imdim=size(im);

if imselect,
  figure(1), clf,
  show(mean(im,3)), drawnow;
  [j1,i1]=ginput(1);
  if ~ischar(imselect), if imselect>0, tmpwi=imselect; end; end;
  if length(thr)==1,
    tmpwi=round(0.08*mean(imdim(1:2)));
  else,
    tmpwi=thr(2);
  end;
  tmpii=round(i1)+[-tmpwi:tmpwi];
  tmpjj=round(j1)+[-tmpwi:tmpwi];
  %[min(tmpii) max(tmpii) min(tmpjj) max(tmpjj)],
  ii=tmpii(find((tmpii>=1)&(tmpii<=imdim(1))));
  jj=tmpjj(find((tmpjj>=1)&(tmpjj<=imdim(2))));
  figure(1), clf,
  show(mean(im(ii,jj,:),3)), drawnow;
  if length(thr)>2,
    ii_orig=ii; jj_orig=jj;
    impca=pcaimdenoise(im(ii,jj,:),thr(3),1);
    if length(thr)>3,
      for mm=1:size(impca,3),
        impca(:,:,mm)=im_smooth(impca(:,:,mm),thr(4));
      end;
    end;
    im=impca; clear impca
    imdim=size(im);
    ii=[1:size(im,1)];
    jj=[1:size(im,2)];
  end;
else,
  ii=[1:imdim(1)];
  jj=[1:imdim(2)];
end;


for mm=1:size(im,3),
  clear tmp*
  tmpim=imwlevel(im(ii,jj,mm),[],1);
    if inv_flag, tmpim=1-tmpim; end;
    tmprad=radon(tmpim);
    %tmprad=imwlevel(tmprad,[mean(min(tmprad,[],1)) mean(max(tmprad,[],1))],1);
    tmpri=floor((mean(imdim(1:2))+1)/2);
    tmpri=floor((size(tmprad,1)+1)/2)+[-tmpri:tmpri];
    tmprad=tmprad(tmpri,:);
    for nn=1:size(tmprad,2),
      tmpproj=tmprad(:,nn);
      tmppi=[1 2 [-1 0]+length(tmpproj)];
      tmpproj=tcdetrend(tmpproj,1,tmppi);
      tmpproj=tmpproj/mean(tmpproj(tmppi))-1;
      tmpi1=find(tmpproj>thr,1,'first');
      tmpi2=find(tmpproj>thr,1,'last');
      %[size(tmpproj) tmpi1 tmpi2],
      %tmpi1i=interp1(tmpproj([-2:2]+tmpi1),[-2:2],thr);
      %tmpi2i=interp1(tmpproj([-2:2]+tmpi2),[-2:2],thr);
      tmpi1i=0; tmpi2i=0;
      tmpww(nn)=(tmpi2+tmpi2i)-(tmpi1+tmpi1i);
    end;
    ww(mm)=mean(tmpww);
    %if nargout==0,
    %  figure(1), clf, 
    %  subplot(211), plot(tmprad),
    %  subplot(212), plot(tmpww),
    %  drawnow, pause,
    %end;
end;

if imselect,
  y.im=mean(im,3);
  if exist('ii_orig','var'), ii=ii_orig; jj=jj_orig; end;
  y.ii=[min(ii) max(ii) min(jj) max(jj)];
  y.ij0=[round(i1) round(j1)];
  y.thr=thr;
  y.ww=ww;
else,
  y=ww;
end;

if nargout==0,
  plot(ww), 
end;

