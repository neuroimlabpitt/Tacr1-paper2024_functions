function [oisii2]=getTrigLoc(data,tw,ts,thr,nthr)
% Usage ... [ii]=getTrigLoc(data,timeLook,sampling_time,thr,nthr)
%
% data is the analog trigger data, timeLook is the time-sample distance
% between triggers, thr is the threshold for the trigger

do_verbose=0;

if nargin<5, nthr=[]; end;
if nargin<4, thr=0.1; end;

if nargin<3,
  %ts=0.001;
  ts=1;
end;

if nargin<2,
  tw=5000;
else,
  tw=round(tw/ts);
end;

tmpii=find(data>thr);
tmpii2=diff(tmpii);
tmpii3=find(tmpii2>2);
oisii=[tmpii(1);tmpii(tmpii3+1)];

tmpii4=find(diff(oisii)>tw);

if do_verbose,
  disp(sprintf('  # parses= %d  based on spacing of %d',length(tmpii4),tw));
end;

if ~isempty(tmpii4);
for mm=1:length(tmpii4)+1,
  if mm==1,
    oisii2{mm}=oisii(1:tmpii4(mm));
  elseif mm==length(tmpii4)+1,
    oisii2{mm}=oisii(tmpii4(mm-1)+1:end);
  else,
    oisii2{mm}=oisii(tmpii4(mm-1)+1:tmpii4(mm));
  end;
  tmpdiff=diff(oisii2{mm});
  if do_verbose,
    disp(sprintf('  %d: #trigs= %d, avg diff= %f (%f)',mm,length(oisii2{mm}),mean(tmpdiff),mean(tmpdiff)*ts));
  end;
end;
else,
  oisii2=[];
end;
clear tmp*

if length(nthr)==1,
  tmpii=oisii2;
  tmpcnt=0;
  for mm=1:length(tmpii),
    if length(tmpii{mm})>nthr,
      tmpcnt=tmpcnt+1;
      tmpi2{tmpcnt}=tmpii{mm};
    end;
  end;
  oisii2=tmpi2;
  clear tmp*
elseif length(nthr)==2,
  tmpii=oisii2;
  tmpcnt=0;
  for mm=1:length(tmpii),
    if (length(tmpii{mm})>=nthr(1))&(length(tmpii{mm})<nthr(2)),
      tmpcnt=tmpcnt+1;
      tmpi2{tmpcnt}=tmpii{mm};
    end;
  end;
  oisii2=tmpi2;
  clear tmp*
end;
 
