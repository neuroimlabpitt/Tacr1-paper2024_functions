function yy=ring2(inmat,rrad,rwid,xy0,ang)
% Usage ... y=ring2(inmat,rad,wid,xy0,ang)
%
% xy0=[0 0] will place ring in the center of the image floor(sz/2)

if ~exist('ang','var'), ang=0; end;
if ~exist('xy0','var'), xy0=[]; end;

if isempty(xy0), xy0=[0 0]; end;

if length(inmat)==2, 
    yy=zeros(inmat);
else,
    yy=zeros(size(inmat));
end;

if length(rrad)==1, rrad=[1 1]*rrad; end;
if length(xy0)==1, xy0=[1 1]*xy0; end;

rf=rrad(2)/rrad(1);
if rf<1, rwid=rwid/rf; end;

[rr,cc]=meshgrid([0:size(yy,2)-1]-floor(size(yy,2)/2)-xy0(2),([0:size(yy,1)-1]-floor(size(yy,1)/2))/rf-xy0(1));

% if abs(ang)>10*eps,
%   ang=ang*(pi/180);
%   disp(sprintf('  rotating %.2f',ang));
%   rr2=rr; cc2=cc;
%   for mm=1:size(rr,1), for nn=1:size(rr,2),
%     tmprot=[cos(ang) -sin(ang); sin(ang) cos(ang)]*[rr(mm,nn);cc(mm,nn)];
%     rr2(mm,nn)=tmprot(1); cc2(mm,nn)=tmprot(2);
%   end; end;
%   rr=rr2; cc=cc2;
% end;

yy=exp(-((sqrt(rr.^2+cc.^2)-rrad(1))/rwid).^2);
yy=(yy/max(yy(:))).^2;
if abs(ang)>10*eps, yy=rot2d_f(yy,ang); end;
yy(find(abs(yy)<100*eps))=0;

if nargout==0,
    clf, show(yy)
    %subplot(221), show(yy)
    %subplot(222), show(rr)
    %subplot(224), show(cc)
    clear yy
end;


