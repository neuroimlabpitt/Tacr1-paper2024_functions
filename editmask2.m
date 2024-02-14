function x=editmask2(x,im)
% Usage ... x=editmask2(x,im)
%
% same as editmask but will let you edit labeled images
% by selection

wait_flag=0;

if exist('im','var'),
  if iscell(im),
    im_overlay4(im{1},x,256);
  elseif size(im,3)>1,
    im_overlay4(im(:,:,1),x,256);
  else,
    im_overlay4(im,x,256);
  end;
else,
  im=zeros(size(x));
  im_overlay4(im,x), 
end;
drawnow,
if wait_flag,
  tmpin=input('press enter to get started or 0 to skip... ');
  if ~isempty(tmpin), if tmpin==0, return, end; end;
end;

imdim=size(x);

do_labeledit=0;
if max(x(:))>1, do_labeledit=1; end;

tmpgood=0;
while(~tmpgood),
tmpmask=double(x>0); tmpmask2=zeros(size(tmpmask));
im_overlay4(im(:,:,1),tmpmask), drawnow;
found=0;
while(~found),
  [tmpy,tmpx,tmpbut]=ginput(1);
  tmpx=round(tmpx); tmpy=round(tmpy);
  %disp(sprintf(' [%d,%d; %d]',tmpx,tmpy,tmpbut));
  tmpedit=1;
  if (tmpx<1)|(tmpx>imdim(1)), tmpedit=0; found=1; end;
  if (tmpy<1)|(tmpy>imdim(2)), tmpedit=0; found=1; end;
  if (tmpedit)&(tmpbut==1),
    if tmpmask2(tmpx,tmpy),
      tmpmask2(tmpx,tmpy)=0;
      if x(tmpx,tmpy)>0, tmpmask(tmpx,tmpy)=1; else, tmpmask(tmpx,tmpy)=0; end;
    else,
      tmpmask2(tmpx,tmpy)=1;
    end;
    tmpmask(find(tmpmask2>0))=2;
    disp(sprintf('  select (%d,%d)=%d  origID=%d',tmpx,tmpy,tmpmask2(tmpx,tmpy),x(tmpx,tmpy)));
  elseif (tmpbut==3)&exist('im'),
    disp(sprintf('  maskID (%d,%d)=%d',tmpx,tmpy,x(tmpx,tmpy)));
    if iscell(im),
      for mm=1:length(im), show(im{mm}), drawnow, pause(1), end;
    elseif size(im,3)>1,
      for mm=1:size(im,3), show(im(:,:,mm)), drawnow, pause(1), end;
    else,
      show(im); drawnow; pause(2);
    end;
  elseif tmpbut==3,
    found=1;
  end;
  if exist('im','var'),
    if iscell(im),
      im_overlay4(im{1},tmpmask,256);
    elseif size(im,3)>1,
      im_overlay4(im(:,:,1),tmpmask,256);
    else,
      im_overlay4(im,tmpmask,256);
    end;
  else,
    show(tmpmask), 
  end;
  drawnow,
end;
tmpin=input('  NewID (-1=exit): ');
if tmpin<0,
 tmpgood=1;
else,
  x(find(tmpmask2))=tmpin;
end;
end;

if exist('im'),
  if iscell(im),
    im_overlay4(im{1},x,256);
  elseif size(im,3)>1,
    im_overlay4(im(:,:,1),x,256);
  else,
    im_overlay4(im,x,256);
  end;
else,
  show(x), 
end;
drawnow,


