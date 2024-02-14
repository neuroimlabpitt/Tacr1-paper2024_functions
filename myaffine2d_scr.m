function [xx1,im1new]=myaffine2d_scr(im1,im2,parms,mask,x0)
% Usage ... y=myaffine2d_scr(im1,im2,parms,mask,x0)
%
% place im1 in the space of im2:
% im1new=myaffine2d_f(im1,xx1(1),xx1(2),xx1(3),xx1(4),xx1(5),size(im2));
% parms=[ranges_for_x0,y0,rot0,xs,ys] -- no parameter options for now
%

if nargin<3, parms=[]; end;
if nargin<4, mask=[]; end;

do_manual=0;
do_ptselect=0;
if strcmp(mask,'point-select'),
  do_ptselect=1;
  mask=[];
  im1dim=size(im1);
  im2dim=size(im2);
  clf,
  subplot(121),
  show(im1), xlabel('im1'), drawnow,
  subplot(122),
  show(im2), xlabel('im2'), drawnow,
  tmpfound=0;
  cnt1=0; tmpim1=zeros(im1dim);
  disp('  select points in im1 (select outside when done)...'),
  while(~tmpfound),
    subplot(121),
    tmp1=round(ginput(1)); 
    if (tmp1(1)>0)&(tmp1(1)<im1dim(2))&(tmp1(2)>0)&(tmp1(2)<im1dim(1)),
      cnt1=cnt1+1;
      tmploc1(cnt1,:)=tmp1;
      tmpim1(tmp1(2),tmp1(1))=1-tmpim1(tmp1(2),tmp1(1));
      show(im_super(im1,tmpim1,0.5)), xlabel('im1'), drawnow,
    else,
      tmpfound=1;
    end; 
  end;
  tmpfound=0;
  cnt2=0; tmpim2=zeros(im2dim);
  disp('  select points in im2 (select outside when done)...'),
  while(~tmpfound),
    subplot(122),
    tmp1=round(ginput(1));   
    if (tmp1(1)>0)&(tmp1(1)<im2dim(2))&(tmp1(2)>0)&(tmp1(2)<im2dim(1)),
      cnt2=cnt2+1;
      tmploc2(cnt2,:)=tmp1; 
      tmpim2(tmp1(2),tmp1(1))=1-tmpim2(tmp1(2),tmp1(1));
      show(im_super(im2,tmpim2,0.5)), xlabel('im2'), drawnow,
    else,
      tmpfound=1;
    end;
  end;
  tmpim1sm=im_smooth(tmpim1,im1dim/20); tmpim1sm=tmpim1sm/max(tmpim1sm(:));
  tmpim2sm=im_smooth(tmpim2,im2dim/20); tmpim2sm=tmpim2sm/max(tmpim2sm(:));
  save tmpim tmpim1sm tmpim2sm tmpim1 tmpim2
  subplot(121), show(tmpim1sm), subplot(122), show(tmpim2sm), drawnow,
  disp('  press enter to continue...'),
  im1orig=im1; im1=tmpim1sm;
  im2orig=im2; im2=tmpim2sm;
  clf,
elseif strcmp(mask,'select')|strcmp(mask,'mask-select'),
  mask=selectMask(im2);
elseif strcmp(mask,'manual'),
  mask=[];
  do_manual=1;
end;

xopt=optimset('lsqnonlin');
xopt.TolxFun=1e-10;
xopt.TolX=1e-8;

if ~exist('x0','var'), x0=[0 0 0 1 1]; end;

if do_manual,
  xx1=x0;
  tmpok=0;
  while(~tmpok),
    % manually set xx1
    im1tmp=myaffine2d_f(im1,xx1(1),xx1(2),xx1(3),xx1(4),xx1(5),size(im2));
    clf, show(im1tmp-im2), drawnow,
    tmpin=input('  select [x#, y#, r#, s#, l#, enter]: ','s');
    if isempty(tmpin),
      tmpok=1;
    else,
      if strcmp(tmpin(1),'x'),
        xx1(1)=str2num(tmpin(2:end));
      elseif strcmp(tmpin(1),'y'),
        xx1(2)=str2num(tmpin(2:end));
      elseif strcmp(tmpin(1),'r'),
        xx1(3)=str2num(tmpin(2:end));
      elseif strcmp(tmpin(1),'s'),
        xx1(4)=str2num(tmpin(2:end));
      elseif strcmp(tmpin(1),'l'),
        xx1(5)=str2num(tmpin(2:end));
      elseif strcmp(tmpin(1),'X'),
        tmpok=1;
      elseif strcmp(tmpin(1),'R'),
        xx1=x0;
      end;
    end;
  end;
  im1new=myaffine2d_f(im1,xx1(1),xx1(2),xx1(3),xx1(4),xx1(5),size(im2));
else,  
  if length(parms)>=5,
    xlb=[-1.0*parms(1) -1.0*parms(2) -parms(3) 0.6*parms(4) 0.6*parms(4)];
    xub=[+1.0*parms(1) +1.0*parms(2) +parms(3) 1.8*parms(5) 1.8*parms(5)];
  else,
    xlb=[-0.21*size(im1,1) -0.21*size(im1,2) -25 0.55 0.55];
    xub=[+0.21*size(im1,1) +0.21*size(im1,2) +25 1.8 1.8];
    disp(sprintf('  lb limit= %.2f %.2f %.1f %.2f %.2f',xlb(1),xlb(2),xlb(3),xlb(4),xlb(5)));
    disp(sprintf('  ub limit= %.2f %.2f %.1f %.2f %.2f',xub(1),xub(2),xub(3),xub(4),xub(5)));
  end;

  xx0=myaffine2d_f_wrap(x0,im1,im2,mask);
  xx1=lsqnonlin(@myaffine2d_f_wrap,x0,xlb,xub,xopt,im1,im2,mask);

  % im1new now will be in the same space as im2
  im1new=myaffine2d_f(im1,xx1(1),xx1(2),xx1(3),xx1(4),xx1(5),size(im2));
end;


%%%
function y=myaffine2d_f_wrap(xx,im1,im2,mask)
  y=myaffine2d_f(im1,xx(1),xx(2),xx(3),xx(4),xx(5),im2,mask);
return,

