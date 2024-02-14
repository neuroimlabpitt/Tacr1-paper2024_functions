function [oisii,trigid,dii]=reportBiopacImageIntake(bname,imchname,tw,bts)
% Usage ... [ii,trigid]=reportBiopacImageIntake(biopac_matname,imChName,time_extent,sampling_time)

if length(nargin)<4,
  ts=0.001;
end;

if length(nargin)<3,
  tw=160;
end;

if isempty(imchname),
  imchname='MainCam';
end;

verbose_flag=1;

disp(sprintf('load %s',bname));
eval(sprintf('load %s',bname));

eval(sprintf('tmpii=find(biopacData.%s>0);',imchname));
tmpii2=diff(tmpii);
tmpii3=find(tmpii2>2);
oisii=[tmpii(1);tmpii(tmpii3+1)];

wii=round(tw/ts);
for mm=1:length(oisii),
  tmpii=[oisii(mm):oisii(mm)+wii];
  tmpii2=find(biopacData.StimON(tmpii)>1);
  if isempty(tmpii2),
    disp(sprintf('  ImID #%d:  No StimID within %d samples',mm,wii));
    dii(mm)=-1;
  else,
    if length(tmpii2)==1,
      disp(sprintf('  ImID# %d:  %d to StimON',tmpii2-tmpii(1)+1));
    else,
      tmpii3=diff(tmpii2);
      tmpii4=find(tmpii3>2);
      tmpii5=[tmpii2(1);tmpii2(tmpii4+1)];
      if verbose_flag,
      if length(tmpii5)>2,
        disp(sprintf('  ImID# %d:  %d %d (%d) to StimON',mm,tmpii5(1),tmpii5(2),length(tmpii5)));
      elseif length(tmpii5)==2,
        disp(sprintf('  ImID# %d:  %d %d to StimON',mm,tmpii5(1),tmpii5(2)));
      else,
        disp(sprintf('  ImID# %d:  %d to StimON',mm,tmpii5(1)));
      end;
      end;
    end;
    dii(mm)=tmpii5(1);
  end;
  tmpti=find(trigLoc>oisii(mm));
  if ~isempty(tmpti),
    trigid(mm)=tmpti(1);
    disp(sprintf('  nearest trig# %d',trigid(mm)));
  end;
end;


