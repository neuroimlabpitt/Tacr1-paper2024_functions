function x=editmask(x,im,ax)
% Usage ... x=editmask(x,im,ax)

do_relabel=0;
if max(x(:))>1,
  disp('  X > 1, turning it to a mask and relabeling at the end...');
  do_relabel=1;
  xorig=x;
  x=x>1;
end;

if nargin<3, ax=[1 size(x,2) 1 size(x,1)]; end;
if ischar(ax), if strcmp(ax,'roi'),
  do_relabel=2;
  ax=[1 size(x,2) 1 size(x,1)];
  if ~exist('xorig','var'), xorig=bwlabel(x>0); end;
end; end;

if ~exist('im','var'), im=[]; end;

if ~isempty(im),
  if iscell(im),
    im_overlay4(im{1},x,64);
  elseif size(im,3)>1,
    im_overlay4(im(:,:,1),x,64);
  else,
    im_overlay4(im,x,64);
  end;
else,
  show(x), 
end;
axis(ax);
drawnow,
%tmpin=input('press enter to get started or 0 to skip... '); 
%if ~isempty(tmpin), if tmpin==0, return, end; end;

imdim=size(x);
found=0;
while(~found),
  [tmpy,tmpx,tmpbut]=ginput(1);
  tmpx=round(tmpx); tmpy=round(tmpy);
  disp(sprintf(' [%d,%d]= %d',tmpx,tmpy,tmpbut));
  tmpedit=1;
  %if (tmpx<1)|(tmpx>imdim(1)), tmpedit=0; found=1; end;
  %if (tmpy<1)|(tmpy>imdim(2)), tmpedit=0; found=1; end;
  if (tmpx<ax(3))|(tmpx>ax(4)), tmpedit=0; found=1; end;
  if (tmpy<ax(1))|(tmpy>ax(2)), tmpedit=0; found=1; end;
  if (tmpedit)&(tmpbut==1),
    if do_relabel==2,
      if x(tmpx,tmpy),
        tmpval=xorig(tmpx,tmpy);
        x(find(xorig==tmpval))=0;
      else,
        tmpval=xorig(tmpx,tmpy);
        if tmpval>0, x(find(xorig==tmpval))=1; end;
      end;
    else,
      if x(tmpx,tmpy),
        x(tmpx,tmpy)=0;
      else,
        x(tmpx,tmpy)=1;
      end;
    end;
  elseif (tmpbut==3)&exist('im'),
    if iscell(im),
      for mm=1:length(im), show(im{mm}), axis(ax); drawnow, pause(0.5), end;
    elseif size(im,3)>1,
      for mm=1:size(im,3), show(im(:,:,mm)), axis(ax); drawnow, pause(0.5), end;
    else,
      show(im); axis(ax); drawnow; pause(2);
    end;
  elseif tmpbut==3,
    found=1;
  end;
  if ~isempty(im),
    if iscell(im),
      im_overlay4(im{1},x,64);
    elseif size(im,3)>1,
      im_overlay4(im(:,:,1),x,64);
    else,
      im_overlay4(im,x,64);
    end;
  else,
    show(x), 
  end;
  axis(ax); xlabel('click mask to edit, select outside to exit')
  drawnow,
end;

if do_relabel, x=bwlabel(x); end;
 
