function [yy,msk,yrp,dd]=getRectImGrid(im1,rw,dx,ctr,ang,rline_flag)
% Usage ... [y,msk]=getRectImGrid(im,rw,dx,ctr,ang,radline_flag)

if isstruct(rw),
  rmsk=rw;
  clear rw
  rw=rmsk.rw;
  dx=rmsk.dxy;
  ctr=rmsk.aloc;
  ang=rmsk.ang;
  if isfield(rmsk,'rline_flag'),
    rline_flag=rmsk.rline_flag;
  else,
    rline_flag=0;
  end;
end;

if ~exist('rline_flag','var'), rline_flag=0; end;

skip_flag=1;
check_flag=1;
if nargout>2, check_flag=1; end;

if length(dx)==1, dx(2)=dx(1); end;

im1sz=size(im1);
[xg,yg]=meshgrid([1:im1sz(2)],[1:im1sz(1)]);
[xg0,yg0]=meshgrid([1:dx(1):rw(1)],[1:dx(2):rw(2)]);
xg0r=reshape(xg0,prod(size(xg0)),1);
yg0r=reshape(yg0,prod(size(yg0)),1);
if rline_flag, 
  ctr0=[1 1];
else,
  ctr0=mean([xg0r yg0r])-0.5;
end;

ang=ang*(pi/180);
rotm=[cos(ang) -sin(ang); sin(ang) cos(ang)];
tmpr=([xg0r yg0r]-ones(length(xg0r),1)*ctr0)*rotm + ones(length(xg0r),1)*ctr;

zii=interp2(xg,yg,im1,tmpr(:,2),tmpr(:,1));
yy=reshape(zii,size(xg0,1),size(xg0,2));

msk=zeros(im1sz);
tmprr=round(tmpr);
cnt=1;
for mm=1:size(tmprr,1), 
  if ((tmprr(mm,1)>=1)&(tmprr(mm,1)<=im1sz(1))&(tmprr(mm,2)>=1)&(tmprr(mm,2)<=im1sz(2))),
    msk(tmprr(mm,1),tmprr(mm,2))=1; 
    tmprr2(cnt,:)=tmprr(mm,:);
    cnt=cnt+1;
  end;
end;

if check_flag,
  if size(yy,1)==1,
    yy=yy(find(~isnan(yy)));
  else,
    cnt=0;
    for mm=1:size(yy,1),
      tmpii=find(~isnan(yy(mm,:)));
      if ~isempty(tmpii), 
        if skip_flag,
          cnt=cnt+1; yrp(cnt)=mean(yy(mm,tmpii));
        else,
          yrp(mm)=mean(yy(mm,tmpii));
        end;
      else,
        if ~skip_flag, yrp(mm)=0; end;
      end;
    end;
  end;
else,
  yrp=mean(yy');
end;
  
if rline_flag, 
  yrp=tmprr2;
end;

if nargout==4,
  yD2=calcRadius2(yrp);
  yD3b=calcRadius3b(yrp);
  dd=[yD2(1) yD3b(1)];
else,
  dd=[];
end;

if nargout==0,
  figure(1)
  show(im_super(im1,msk,0.3))
  figure(2)
  subplot(211)
  show(yy')
  subplot(212)
  plot(yrp)
end;

