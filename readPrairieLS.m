function y=readPrairieLS(pname,rname,labelid,chid)
% Usage ...  y=readPrairieLS(pname,rname,labelid,chid)


if nargin<4, chid=[]; end;
if nargin<3, labelid=[]; end;
if nargin<2, rname=[]; end;

if isempty(rname), rname=pname; end;
if isempty(labelid), labelid='CurrentSettings'; end;
if isempty(chid), chid=1; end;

% determine number of repetitions
tmpname=sprintf('%s/%s_Cycle%03d_%s_Ch%d_*.tif',pname,rname,1,labelid,chid);
if isunix,
  [tmpa,tmpb]=unix(sprintf('ls -1 %s | wc -l',tmpname));
  nrep=str2num(tmpb);
  if isempty(nrep), nrep=0; end;
else,
  eval(sprintf('tmpa=dir(''%s'');',tmpname));
  nrep=length(tmpa);
end;
disp(sprintf('  #rep= %d (%s)',nrep,tmpname));

% determine number of cycles
tmpname=sprintf('%s/%s_Cycle*_%s_Ch%d_%06d.tif',pname,rname,labelid,chid,1);
if isunix,
  [tmpa,tmpb]=unix(sprintf('ls -1 %s | wc -l',tmpname));
  ncyc=str2num(tmpb);
  if isempty(ncyc), ncyc=0; end;
else,
  eval(sprintf('tmpa=dir(''%s'');',tmpname));
  ncyc=length(tmpa);
end;
disp(sprintf('  #cyc= %d (%s)',ncyc,tmpname));

y.path=pname;
y.root=rname;
y.labelID=labelid;
y.chID=chid;
y.ncyc=ncyc;
y.nrep=nrep;

% determine if LineScanReference file is present
tmpname=sprintf('%s/%s-Cycle*-LinescanReference.tif',pname,rname);
if isunix,
  [tmpa,tmpb]=unix(sprintf('ls -1 %s | wc -l',tmpname));
  ref_flag=str2num(tmpb);
  if isempty(ref_flag), ref_flag=0; end;
else,
  eval(sprintf('tmpa=dir(''%s'');',tmpname));
  ref_flag=length(tmpa);
end;
if ref_flag,
  ncref=ref_flag;
  ref_flag=1;
  for nn=1:ncref,
    tmpname=sprintf('%s/%s-Cycle%03d-LinescanReference.tif',pname,rname,nn);
    y.Ref(:,:,:,nn)=imread(tmpname);
    %y.Ref=tiffread2(tmpname);
  end;
end;

% determine if ChXSource file is present
tmpname=sprintf('%s/%s-Cycle*_Ch%dSource.tif',pname,rname,chid);
if isunix,
  [tmpa,tmpb]=unix(sprintf('ls -1 %s | wc -l',tmpname));
  src_flag=str2num(tmpb);
  if isempty(src_flag), src_flag=0; end;
else,
  eval(sprintf('tmpa=dir(''%s'');',tmpname));
  src_flag=length(tmpa);
end;
if src_flag,
  ncsrc=src_flag;
  src_flag=1;
  for nn=1:ncsrc,
    tmpname=sprintf('%s/%s-Cycle%03d_Ch%dSource.tif',pname,rname,nn,chid);
    %y.ChSource=imread(tmpname);
    y.ChSource=tiffread2(tmpname);
  end;
end;

% determine if there is linescandata file and parse it if necessary
if isunix,
  [tmpa,tmpb]=unix(sprintf('cat %s/%s_Ch%d.lsd',pname,rname,chid));
  lsd_flag=~tmpa;
  if lsd_flag,
    y.lsInfo=tmpb;
    tmpi10=find(tmpb==char(10));
    tmpi11=find(tmpb=='=');
    for mm=1:ncref,
      clear tmpstr* tmpi1 tmpi2 tmpi3 tmpii1 tmpii2 tmpii3 tmpx1 tmpx2 tmpx3
      tmpstr1=sprintf('Line%d Line Start Pixel Y=',mm);
      tmpstr2=sprintf('Line%d Line Start Pixel X=',mm);
      tmpstr3=sprintf('Line%d Line Stop Pixel X=',mm);
      tmpi1=strfind(tmpb,tmpstr1);
      tmpii1=find(tmpi10>tmpi1);
      tmpii1eq=find(tmpi11>tmpi1);
      tmpy1=str2num(tmpb(tmpi11(tmpii1eq(1))+1:tmpi10(tmpii1(1))));
      tmpi2=strfind(tmpb,tmpstr2);
      tmpii2=find(tmpi10>tmpi2);
      tmpii2eq=find(tmpi11>tmpi2);
      tmpx1=str2num(tmpb(tmpi11(tmpii2eq(1))+1:tmpi10(tmpii2(1))));
      tmpi3=strfind(tmpb,tmpstr3);
      tmpii3=find(tmpi10>tmpi3);
      tmpii3eq=find(tmpi11>tmpi3);
      tmpx2=str2num(tmpb(tmpi11(tmpii3eq(1))+1:tmpi10(tmpii3(1))));
      y.Y1(mm)=tmpy1;
      y.X1(mm)=tmpx1;
      y.X2(mm)=tmpx2;
    end;
  end;
end;
% load data
for mm=1:nrep,
  for nn=1:ncyc,
    tmpname=sprintf('%s/%s_Cycle%03d_%s_Ch%d_%06d.tif',pname,rname,nn,labelid,chid,mm);
    tmpstk=tiffread2(tmpname);
    y.data(mm,nn,:,:)=double(tmpstk.data);
  end;
end;

% undo repetitions
for mm=1:ncyc, 
  tmpdata=[];
  for nn=1:nrep,
    tmpdata=[tmpdata;squeeze(y.data(nn,mm,:,:))];
  end;
  y.data2(:,:,mm)=squeeze(tmpdata);
end;

y.lsim=[];
for mm=1:ncyc,
  y.lsim=[y.lsim;squeeze(y.data(1,mm,:,:))];
end;

