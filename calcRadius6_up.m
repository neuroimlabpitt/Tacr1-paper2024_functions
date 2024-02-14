function [rs]=calcRadius6_up(im,rmask_struc)
% Usage ... [rs]=calcRadius6_up(im,rmask_struc)

check_flag=1;

for mm=1:size(im,3), for nn=1:length(rmask_struc),
  %disp(sprintf('[%d,%d]',mm,nn));
  rw=rmask_struc(nn).rw;
  dx=rmask_struc(nn).dxy;
  ctr=[rmask_struc(nn).aloc(1) rmask_struc(nn).aloc(2)];
  ang=rmask_struc(nn).ang;

  [imc,imsk]=getRectImGrid(im(:,:,mm),rw,dx,ctr,ang);
  proj=mean(imc');
  if check_flag,
    if sum(isnan(proj))>0, proj=proj(find(~isnan(proj))); end;
  end;
  rs(mm,nn,:)=calcRadius3b_up(proj);
end; end;

rs=squeeze(rs);

