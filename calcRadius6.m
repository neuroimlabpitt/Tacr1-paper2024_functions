function [r,rs]=calcRadius6(im,rmask_struc,inv_flag,fit_flag)
% Usage ... [r,rs]=calcRadius6(im,rmask_struc,inv_flag,fit_flag)

if ~exist('fit_flag'), fit_flag=''; end;
if ~exist('inv_flag'), inv_flag=''; end;

if isempty(fit_flag), fit_flag=0; end;
if isempty(inv_flag), inv_flag=0; end;

check_flag=1;

if iscell(im),
  fname=im{1};
  nims=im{2};
  for mm=1:nims, 
    disp(sprintf('  im# %d of %d',mm,nims));
    tmpim=readOIS3(fname,mm); 
    for nn=1:length(rmask_struc),
      rw=rmask_struc(nn).rw;
      dx=rmask_struc(nn).dxy;
      ctr=[rmask_struc(nn).aloc(1) rmask_struc(nn).aloc(2)];
      ang=rmask_struc(nn).ang;

      [imc,imsk]=getRectImGrid(tmpim,rw,dx,ctr,ang);
      proj=mean(imc');
      if check_flag,
        if sum(isnan(proj))>0, proj=proj(find(~isnan(proj))); end;
      end;
      if (inv_flag), proj=max(proj)-proj; end;
      rs(mm,nn).fwhm=calcRadius3b(proj);
      if (fit_flag), rs(mm,nn).rfit=calcRadius2(proj); end;
      rs(mm,nn).proj=proj;
      r(mm,nn)=rs(mm,nn).fwhm(1)*dx;
      if (fit_flag), r(mm,nn,2)=rs(mm,nn).rfit(1); end;
    end; 
  end;
else,
  for mm=1:size(im,3), for nn=1:length(rmask_struc),
    rw=rmask_struc(nn).rw;
    dx=rmask_struc(nn).dxy;
    ctr=[rmask_struc(nn).aloc(1) rmask_struc(nn).aloc(2)];
    ang=rmask_struc(nn).ang;

    [imc,imsk]=getRectImGrid(im(:,:,mm),rw,dx,ctr,ang);
    proj=mean(imc');
    if check_flag,
      if sum(isnan(proj))>0, proj=proj(find(~isnan(proj))); end;
    end
    if (inv_flag), proj=max(proj)-proj; end;
    rs(mm,nn).fwhm=calcRadius3b(proj);
    if (fit_flag), rs(mm,nn).rfit=calcRadius2(proj); end;
    rs(mm,nn).proj=proj;
    r(mm,nn)=rs(mm,nn).fwhm(1)*dx;
    if (fit_flag), r(mm,nn,2)=rs(mm,nn).rfit(1); end;
  end; end;
end;

