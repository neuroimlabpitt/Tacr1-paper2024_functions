function y=parseBiopac(fname,trigCh,trigs,samples,chIDlist)
% Usage ... y=parseBiopac(fname,trigCh,trigs,samples,chIDlist)
%
% For ex. 
%   parseBiopac('MyACQfile.acq','StimON');
%   parseBiopac('MyACQfile',[],[],123456+[-5000 25000]);
%   parseBiopac('MyACQfile','StimON',[2:11],[-5000 25000]);


if nargin<3,
  trigs=[];
  samples=[];
end;

if (strcmp(fname(end-3:end),'.ACQ')|strcmp(fname(end-3:end),'.acq')),
  biopac_binary2(fname);
  fname2=fname(1:end-4);
else,
  fname2=fname;
end;

if nargin==1,
  return;
else,
  eval(sprintf('load %s',fname2));
end;

if isempty(trigCh)&isempty(trigs),
  for nn=1:nChannels,
    eval(sprintf('y.%s=biopacData.%s(samples(1):samples(2));',deblank(chVarName(nn,:)),deblank(chVarName(nn,:))));
  end;
  return;
end;

if ~isstr(trigCh),
  trigCh=deblank(chVarName(trigCh,:));
end;

if isempty(trigs),
  % need to find trigs, report them and save them
  % trigs are 5V TTL pulses
  eval(sprintf('trigLoc=find(diff(biopacData.%s)>1.0);',trigCh));
  eval(sprintf('trigDist=diff(trigLoc);'));
  trigDist(end+1)=0;
  trigs_all=[[1:length(trigLoc)]' trigLoc(:) trigDist(:)]
  eval(sprintf('save %s -append trigLoc trigDist trigs_all ',fname2));
else,,
  if (length(samples)>2),
    error('Multiple sample sizes are not currently supported');
  elseif (length(samples)==1),
    samples(2)=samples(1);
    samples(1)=1;
  end;
  if (max(trigs)<99999),
    if (~exist('trigLoc')),
      eval(sprintf('trigLoc=find(diff(biopacData.%s)>1.0);',trigCh));
      eval(sprintf('trigDist=diff(trigLoc);'));
      trigDist(end+1)=0;
      eval(sprintf('save %s -append trigLoc trigDist ',fname2));
    end;
    for mm=1:length(trigs),
      for nn=1:nChannels,
        %disp(sprintf('y.%s(:,mm)=biopacData.%s(trigLoc(trigs(mm))+samples(1):trigLoc(trigs(mm))+samples(2)-1);',deblank(chVarName(nn,:)),deblank(chVarName(nn,:))));
        eval(sprintf('y.%s(:,mm)=biopacData.%s(trigLoc(trigs(mm))+samples(1):trigLoc(trigs(mm))+samples(2)-1);',deblank(chVarName(nn,:)),deblank(chVarName(nn,:))));
      end;
    end;
  else,
    for mm=1:length(trigs),
      disp(sprintf('  trig #%d (%d)',mm,trigs(mm)));
      for nn=1:nChannels,
        eval(sprintf('y.%s(:,mm)=biopacData.%s(trigs(mm)+samples(1):trigs(mm)+samples(2)-1);',deblank(chVarName(nn,:)),deblank(chVarName(nn,:))));
      end;
    end;
  end;
end;

if (nargin==5),
  y2=y;
  clear y
  for nn=1:length(chIDlist),
    eval(sprintf('y.%s=y2.%s;',deblank(chVarName(nn,:)),deblank(chVarName(nn,:))));
  end;
end;

y.fname=fname2;

