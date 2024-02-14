function f=readPrairie2(froot,cycle,label,chno,imno)
% Usage ... f=readPrairie2(froot,cycle,label,chno,imno)
%
% PrairieView data reader
% This function will read individual images if the froot name includes the
% file extension. If froot ends in a slash to indicate a folder, it will
% read all images within cycles, labels, ch#s and im#s.
% If you do not wish to read all images in the folder, you can include
% arguments for the cycle#s, ch#s, imno#s you would like to read.
% To read default labels (older versions of PV) use [].

if ~exist('cycle','var'), cycle=[]; end;
if ~exist('label','var'), label=[]; end;
if ~exist('chno','var'), chno=[]; end;
if ~exist('imno','var'), imno=[]; end;
if length(imno)==2, imno=[imno(1):imno(2)]; end;
if isempty(label), label='CurrentSettings'; end;
%if isempty(cycle), cycle=1; end;
%if isempty(chno), chno=2; end;
if strcmp(froot(end),'/'), do_addpath=1; else, do_addpath=0; end;

if iscell(froot),
  if length(froot)==1, froot{2}=' '; end;
  tmpstr=strsplit(froot{1},froot{2});
  tmproot=[tmpstr{1},'/'];
  disp(sprintf('  delimeter name modification\n  in-name= %s\n  out-name= %s',froot{1},tmproot));
  froot1=sprintf('''%s''/',froot{1});
  froot=tmproot;
  do_addpath=1;
else,
  froot1=froot;
end;

do_version=5;

% find how many channels and then how many cycles
if do_addpath,
  tmpfound=0; tmpcnt=0;
  if isempty(chno),
    for mm=1:6,
      tmpname=sprintf('%s%s_Cycle%05d_Ch%d_%06d.ome.tif',froot1,froot(1:end-1),1,mm,1);
      if exist(tmpname), chno=[chno mm]; tmpfound=1; end;
    end;
    if ~tmpfound, do_version=3; end;
    for mm=1:6,
      tmpname=sprintf('%s%s_Cycle%05d_%s_Ch%d_%06d.tif',froot1,froot(1:end-1),1,label,mm,1);
      if exist(tmpname), chno=[chno mm]; tmpfound=1; end;
    end;
    if ~tmpfound, do_version=2; end;
    for mm=1:6,
      tmpname=sprintf('%s%s_Cycle%03d_%s_Ch%d_%06d.tif',froot1,froot(1:end-1),1,label,mm,1);
      if exist(tmpname), chno=[chno mm]; tmpfound=1; end;
    end;
    if ~tmpfound, disp('  could not find images to count number of channels...'); end;
    disp(sprintf('  #ch= %d',length(chno)));
  end;
  % find number of cycles
  if isempty(cycle),
    if do_version==2,
      tmpname=sprintf('%s%s_Cycle*_%s_Ch%d_%06d.tif',froot1,froot(1:end-1),label,chno(1),1);
    elseif do_version==3,
      tmpname=sprintf('%s%s_Cycle*_%s_Ch%d_%06d.tif',froot1,froot(1:end-1),label,chno(1),1);
    else,
      tmpname=sprintf('%s%s_Cycle*_Ch%d_%06d.ome.tif',froot1,froot(1:end-1),chno(1),1);
    end;
    tmpdir=dir(tmpname);
    if ~isempty(tmpname), cycle=[1:length(tmpdir)]; else, cycle=1; disp('  warning: could not find #cycles'); end;
    disp(sprintf('  #cycles= %d',length(cycle)));
  end;
  if isempty(imno),
    % find number of images
     if do_version==2,
      tmpname=sprintf('%s%s_Cycle%03d_%s_Ch%d_*.tif',froot1,froot(1:end-1),1,label,chno(1));
    elseif do_version==3,
      tmpname=sprintf('%s%s_Cycle%05d_%s_Ch%d_*.tif',froot1,froot(1:end-1),1,label,chno(1));
    else,
      tmpname=sprintf('%s%s_Cycle%05d_Ch%d_*.ome.tif',froot1,froot(1:end-1),1,chno(1));
    end;
    tmpdir=dir(tmpname);
    if ~isempty(tmpname), imno=[1:length(tmpdir)]; else, imno=[1:1000]; disp('  warning: could not find #images'); end;
    disp(sprintf('  #images= %d',length(imno)));
  end;
else,
  tmpfound=0;
  if isempty(chno),
    for mm=1:6,
      tmpname=sprintf('%s_Cycle%05d_Ch%d_%06d.ome.tif',froot1,cycle(1),mm,1);
     if exist(tmpname), chno=[chno mm]; tmpfound=1; end;
    end;
  end;
  if ~tmpfound, do_version=3; end;
end;


% read the images and find how many per channel
tmpout=0;
for mm=1:length(cycle),
  for nn=1:length(chno),
    for oo=1:length(imno),
      if do_addpath,
        if do_version==2,
          fname=sprintf('%s%s_Cycle%03d_%s_Ch%d_%06d.tif',froot1,froot(1:end-1),cycle(mm),label,chno(nn),imno(oo));      
        elseif do_version==3,
          fname=sprintf('%s%s_Cycle%05d_%s_Ch%d_%06d.tif',froot1,froot(1:end-1),cycle(mm),label,chno(nn),imno(oo));    
        else,
          fname=sprintf('%s%s_Cycle%05d_Ch%d_%06d.ome.tif',froot1,froot(1:end-1),cycle(mm),chno(nn),imno(oo));    
        end;
      else,
        if do_version==2,
          fname=sprintf('%s_Cycle%03d_%s_Ch%d_%06d.tif',froot1,cycle(mm),label,chno(nn),imno(oo));
        elseif do_version==3,
          fname=sprintf('%s_Cycle%05d_%s_Ch%d_%06d.tif',froot1,cycle(mm),label,chno(nn),imno(oo));
        else,
          fname=sprintf('%s_Cycle%05d_Ch%d_%06d.ome.tif',froot1,cycle(mm),chno(nn),imno(oo));
        end;
      end;
      if exist(fname),
        tmpstk=tiffread2(fname);
        if (mm==1)&(nn==1)&(oo==1), f=single(zeros(size(tmpstk.data,1),size(tmpstk.data,2),length(chno),length(imno),length(cycle))); end;
        f(:,:,nn,oo,mm)=double(tmpstk.data);
      else,
        disp(sprintf('  warning: did not find %s... returning...',fname));
        tmpout=1;
        break;
      end;
    end;
  end;
end;

f=squeeze(f(:,:,:,1:oo-tmpout,:));

