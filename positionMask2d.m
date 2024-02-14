function [y,yi,subim1loc,im1loc]=positionMask2d(mainParms,subParms,mainIm,subIm)
% Usage ... y=positionMask2d(mainParms,subParms,mainIm,subIm)
%
% mainParms=[xSize,ySize,xFOV,yFOV,x0loc,y0loc]
% subParms=[xSize,ySize,xFOV,yFOV,x0loc,y0loc]
%
% Ex. positionMask2d([],[],im1)

if length(mainParms)<6,
  if length(mainParms)==2,
    mainParms(3:4)=mainParms;
    mainParms(1:2)=size(mainIm);
    mainParms(5:6)=[0 0];
  elseif length(mainParms)==4,
    mainParms(3:6)=mainParms;
    mainParms(1:2)=size(mainIm);
  else,
    error('  error: main parms needs 2, 4 or 6 entries');
  end;
end;

do_select=0;
if exist('subIm','var'),
  if length(subParms)==2,
    subParms(3:4)=subParms;
    subParms(1:2)=size(subIm);
    subParms(5:6)=[0 0];
    do_select=1;
  elseif length(subParms)==4,
    subParms(3:6)=subParms;
    subParms(1:2)=size(subIm);
    do_select=1;
  end;
end;

im1sz=[mainParms(1:2)];
im1FOV=[mainParms(3:4)];
im1loc=[mainParms(5:6)];

subim1sz=[subParms(1:2)];
subim1FOV=[subParms(3:4)];
subim1loc=[subParms(5:6)];

% location relative to image center
im1x=([0:im1sz(1)-1]-floor(im1sz(1)/2))*im1FOV(1)/im1sz(1);
im1y=([0:im1sz(2)-1]-floor(im1sz(2)/2))*im1FOV(2)/im1sz(2);
subim1x=([0:subim1sz(1)-1]-floor(subim1sz(1)/2))*subim1FOV(1)/subim1sz(1);
subim1y=([0:subim1sz(2)-1]-floor(subim1sz(2)/2))*subim1FOV(2)/subim1sz(2);

if do_select,
  im1loc=[0 0];
  tmpfound=0;
  while(~tmpfound),
    figure(1), clf, 
    subplot(121), show(mainIm),
    subplot(122), show(subIm), drawnow,
    disp(' select common point on main image (left)...');
    [tmploc1y,tmploc1x]=ginput(1);
    tmpmask=zeros(size(mainIm));
    tmpmask(round(tmploc1x),round(tmploc1y))=1;
    subplot(121), show(im_super(mainIm,tmpmask,0.5)), drawnow,
    disp(' select common point on sub image (right)...');
    [tmploc2y,tmploc2x]=ginput(1);
    tmpsubmask=zeros(size(subIm));
    tmpsubmask(round(tmploc2x),round(tmploc2y))=1;
    subplot(122), show(im_super(subIm,tmpsubmask,0.5)), drawnow,
    tmpin=input('  selection ok? [0=no, 1/enter=yes]: ');
    if isempty(tmpin), tmpin=1; end;
    if tmpin,
      subim1loc(1)=im1x(round(tmploc1x))+subim1x(round(tmploc2x));
      subim1loc(2)=im1y(round(tmploc1y))+subim1y(round(tmploc2y));
      disp(sprintf('  im1loc=[%.2f %.2f], subim1loc=[%.2f %.2f]',im1loc,subim1loc));
      tmpfound=1; 
    end;
  end;
end;

im1xx=im1x+im1loc(1);
im1yy=im1y+im1loc(2);

subim1xx=subim1x+subim1loc(1);
subim1yy=subim1y+subim1loc(2);

%disp(sprintf('  %.2f %.2f / %.2f %.2f',[im1xx([1 end]) subim1xx([1 end])]))
%disp(sprintf('  %.2f %.2f / %.2f %.2f',[im1yy([1 end]) subim1yy([1 end])]))

% mask the region of subIm inside mainIm
tmp1x=find((im1xx>=subim1xx(1))&(im1xx<=subim1xx(end)));
tmp1y=find((im1yy>=subim1yy(1))&(im1yy<=subim1yy(end)));

if (length(tmp1x)*length(tmp1y))>0,
  y=zeros(im1sz);
  y(tmp1x,tmp1y)=1;
  if exist('mainIm','var'),
    % interpolate mainIm in the space for subIm for comparison
    tmp2x=find((subim1xx>=im1xx(1))&(subim1xx<=im1xx(end)));
    tmp2y=find((subim1yy>=im1yy(1))&(subim1yy<=im1yy(end)));
    [xx1,yy1]=meshgrid(im1yy,im1xx);
    [xx1s,yy1s]=meshgrid(subim1yy(tmp2y),subim1xx(tmp2x));
    disp(sprintf('  %.2f %.2f / %.2f %.2f',[min(xx1(:)) max(xx1(:)) min(yy1(:)) max(yy1(:))]))
    disp(sprintf('  %.2f %.2f / %.2f %.2f',[min(xx1s(:)) max(xx1s(:)) min(yy1s(:)) max(yy1s(:))]))
    yi=interp2(xx1,yy1,mainIm,xx1s,yy1s);
  else,
    yi=[];
  end;
else,
  warning('  no overlay found...');
  y=[];
end;

if nargout==0,
  if ~isempty(y), 
    if ~isempty(yi),
      figure(1), clf, show(im_super(mainIm,y,0.3)), figure(2), clf, show(yi),
    else,
      show(y),
    end;
  end; 
end;
