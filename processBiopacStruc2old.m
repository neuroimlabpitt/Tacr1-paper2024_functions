function y=processBiopacStruc(x,fs,fco,t0avg,dtt,po2cal,po2tr,refvar,skp)
% Usage ... y=processBiopacStruc(x,fs,fco,t0avg,dtt,po2cal,po2tr,refvar,skp)
%
% x- parseBiopac variable
% fs- sampling rate in Hz, fco- cutoff frequency in Hz, t0avg in time
%   note: a second entry in fs will be the interpolated desired sample rate
% t0avg- baseline time period in seconds (using refvar to figure out time ref)
% dtt- individual trial detrend range pairs in absolute time
% po2cal- column of refO2% and po2ABC order cal values
% po2tr- column vector of po2 time constants
% refvar- reference variable for timing (StimON is default)

do_aux=1;
if do_aux&isfield(x,'AUX3'), do_aux=1; else, do_aux=0; end;

do_remove=1;
if do_remove,
  rmflds={'pO2A','pO2B','LFP','BP','ISO','O2','Ex_CO2','SAMeanBP'};
  for mm=1:length(rmflds),
    if isfield(x,rmflds{mm}), x=rmfield(x,rmflds{mm}); end;
  end;
end;

if ~exist('refvar'),
  refvar='StimON';
end;
if isempty(refvar),
  refvar='StimON';
end;

eval(sprintf('ddim=size(x.%s);',refvar));

ts=1/fs(1);
tt=[1:ddim(1)]/fs(1);
tt=tt(:);

eval(sprintf('ii=find(x.%s(:,1)>1);',refvar));
dt0=tt(1)-tt(ii(1));
tt=tt-tt(ii(1));
y.ts=1./fs;
y.tt=tt;

if length(fs)>1, interp_flag=1; else, interp_flag=0; end;
if interp_flag, 
  tti=[tt(1):1/fs(2):tt(end)]; tti=tti(:);
  tti=tti-tti(1)+dt0;
  y.tt=tti;
end;

eval(sprintf('y.%s_orig=x.%s;',refvar,refvar));

if ~exist('dtt'), dtt=[]; end;
if ~exist('po2cal'), po2cal=[]; end;
if ~exist('po2tr'), po2tr=[]; end;

if ~isempty(dtt),
  detrend_flag=1;
  dord=1;
  y.detrend_range=dtt;
  dii=find((tt>=dtt(1))&(tt<=dtt(2)));
  if length(dtt)>2,
    for mm=2:floor(length(dtt)/2),
      tmpdii=find((tt>=dtt(2*mm-1))&(tt<=dtt(2*mm)));
      dii=[dii(:);tmpdii(:)];
    end;
  end;
else,
  detrend_flag=0;
end;
if ~isempty(po2cal),
  y.po2cal=po2cal;
  po2cal_flag=1;
else,
  po2cal_flag=0;
end;
if ~isempty(po2tr),
  po2cal_flag=2;
end;

ii0=find((tt>=t0avg(1))&(tt<=t0avg(2)));
if interp_flag,
  % detrend done before interpolating, normalization done after
  ii0=find((tti>=t0avg(1))&(tti<=t0avg(2)));
end;
y.ii0=ii0;


if isfield(x,'HR'),
  for mm=1:ddim(2), y.HRavg(mm)=mean(x.HR(:,mm)); end;
  for mm=1:ddim(2), y.HRstd(mm)=std(x.HR(:,mm)); end;
end;
if isfield(x,'ISO'),
  for mm=1:ddim(2), y.ISOavg(mm)=mean(x.ISO(:,mm)); end;
  for mm=1:ddim(2), y.ISOstd(mm)=std(x.ISO(:,mm)); end;
end;

if isfield(x,'BP'),
  for mm=1:ddim(2),
    y.BPavg(mm)=mean(x.BP(:,mm));
    y.BPstd(mm)=std(x.BP(:,mm));
    tmpBP=myfilter(x.BP(:,mm),fco,ts);
    if interp_flag,
      y.BP(:,mm)=interp1(tt,tmpBP,tti);
    else,
      y.BP(:,mm)=tmpBP;
    end;
  end;
end;
if isfield(x,'O2'),
  for mm=1:ddim(2),
    y.O2avg(mm)=mean(x.O2(:,mm));
    y.O2std(mm)=std(x.O2(:,mm));
    tmpO2=myfilter(x.O2(:,mm),fco,ts);
    if interp_flag,
      y.O2(:,mm)=interp1(tt,tmpO2,tti);
    else,
      y.O2(:,mm)=tmpO2;
    end;
  end;
end;
if isfield(x,'Ex_CO2'),
  for mm=1:ddim(2),
    y.CO2avg(mm)=mean(x.Ex_CO2(:,mm));
    y.CO2std(mm)=std(x.Ex_CO2(:,mm));
    tmpEx_CO2=myfilter(x.Ex_CO2(:,mm),fco,ts);
    if interp_flag, 
      y.Ex_CO2(:,mm)=interp1(tt,tmpEx_CO2,tti);
    else,
      y.Ex_CO2(:,mm)=tmpEx_CO2;
    end;
  end;
end;
 
if isfield(x,'FLUX'),
  for mm=1:ddim(2),
    tmpFLUX=myfilter(x.FLUX(:,mm),fco,ts);
    if detrend_flag,
      tmpp=polyfit(tt(dii),tmpFLUX(dii),dord);
      tmpv=polyval(tmpp,tt);
      tmpFLUX=tmpFLUX-tmpv+mean(tmpv);
    end;
    if interp_flag,
      tmpFLUXi=interp1(tt,tmpFLUX,tti);
      clear tmpFLUX
      tmpFLUX=tmpFLUXi;
    end;
    y.FLUXbase(mm)=mean(tmpFLUX(ii0));
    y.FLUX(:,mm)=tmpFLUX/mean(tmpFLUX(ii0));
  end;
end;
if isfield(x,'TB'),
  for mm=1:ddim(2),
    tmpTB=myfilter(x.TB(:,mm),fco,ts);
    if detrend_flag,
      tmpp=polyfit(tt(dii),tmpTB(dii),dord);
      tmpv=polyval(tmpp,tt);
      tmpTB=tmpTB-tmpv+mean(tmpv);
    end;
    if interp_flag,
      tmpTBi=interp1(tt,tmpTB,tti);
      clear tmpTB
      tmpTB=tmpTBi;
    end;
    y.TBbase(mm)=mean(tmpTB(ii0));
    y.TB(:,mm)=tmpTB/mean(tmpTB(ii0));
  end;
end;
if isfield(x,'FLUX')&exist('skp'),
  if length(fs)~=3, fs(3)=100/fs(1); end;
  y.flxtb=processBiopac4(x,tt,fs(3),skp);
end;

if do_aux==1,
if isfield(x,'AUX3'),
  for mm=1:ddim(2),
    tmpFLUX=myfilter(x.AUX3(:,mm),fco,ts);
    if detrend_flag,
      tmpp=polyfit(tt(dii),tmpFLUX(dii),dord);
      tmpv=polyval(tmpp,tt);
      tmpFLUX=tmpFLUX-tmpv+mean(tmpv);
    end;
    if interp_flag,
      tmpFLUXi=interp1(tt,tmpFLUX,tti);
      clear tmpFLUX
      tmpFLUX=tmpFLUXi;
    end;
    y.FLUX2base(mm)=mean(tmpFLUX(ii0));
    y.FLUX2(:,mm)=tmpFLUX/mean(tmpFLUX(ii0));
  end;
end;
if isfield(x,'AUX2'),
  for mm=1:ddim(2),
    tmpTB=myfilter(x.AUX2(:,mm),fco,ts);
    if detrend_flag,
      tmpp=polyfit(tt(dii),tmpTB(dii),dord);
      tmpv=polyval(tmpp,tt);
      tmpTB=tmpTB-tmpv+mean(tmpv);
    end;
    if interp_flag,
      tmpTBi=interp1(tt,tmpTB,tti);
      clear tmpTB
      tmpTB=tmpTBi;
    end;
    y.TB2base(mm)=mean(tmpTB(ii0));
    y.TB2(:,mm)=tmpTB/mean(tmpTB(ii0));
  end;
end;
if isfield(x,'AUX3')&exist('skp'),
  if length(fs)~=3, fs(3)=100/fs(1); end;
  y.flxtb=processBiopac4(x,tt,fs(3),skp);
end;
end;


po2cnt=0;

if isfield(x,'pO2A'),
  for mm=1:ddim(2),
    tmppO2A=myfilter(x.pO2A(:,mm),fco,ts);
    if detrend_flag,
      tmpp=polyfit(tt(dii),tmppO2A(dii),dord);
      tmpv=polyval(tmpp,tt);
      tmppO2A=tmppO2A-tmpv+mean(tmpv);
    end;
    if interp_flag,
      tmppO2Ai=interp1(tt,tmppO2A,tti);
      clear tmppO2A
      tmppO2A=tmppO2Ai;
    end;
    y.pO2Abase(mm)=mean(tmppO2A(ii0));
    y.pO2A(:,mm)=tmppO2A/mean(tmppO2A(ii0));
  end;
  if po2cal_flag,
    po2cnt=po2cnt+1;
    for mm=1:ddim(2),
      if po2cal_flag==2,
        y.pO2Acal(:,mm)=po2cal2(y.pO2A(:,mm)*y.pO2Abase(mm),po2cal(:,1),po2cal(:,po2cnt+1),po2tr(po2cnt));
        y.pO2Acal(:,mm)=myfilter(y.pO2Acal(:,mm),fco,ts);
      else,
        y.pO2Acal(:,mm)=po2cal2(y.pO2A(:,mm)*y.pO2Abase(mm),po2cal(:,1),po2cal(:,po2cnt+1));
      end;
      y.pO2Acalbase(mm)=mean(y.pO2Acal(ii0,mm));
      y.pO2Acal(:,mm)=y.pO2Acal(:,mm)/mean(y.pO2Acal(ii0,mm));
    end;
  end;
end;
if isfield(x,'pO2B'),
  for mm=1:ddim(2),
    tmppO2B=myfilter(x.pO2B(:,mm),fco,ts);
    if detrend_flag,
      tmpp=polyfit(tt(dii),tmppO2B(dii),dord);
      tmpv=polyval(tmpp,tt);
      tmppO2B=tmppO2B-tmpv+mean(tmpv);
    end;
    if interp_flag,
      tmppO2Bi=interp1(tt,tmppO2B,tti);
      clear tmppO2B
      tmppO2B=tmppO2Bi;
    end;
    y.pO2Bbase(mm)=mean(tmppO2B(ii0));
    y.pO2B(:,mm)=tmppO2B/mean(tmppO2B(ii0));
  end;
  if po2cal_flag,
    po2cnt=po2cnt+1;
    for mm=1:ddim(2),
      if po2cal_flag==2,
        y.pO2Bcal(:,mm)=po2cal2(y.pO2B(:,mm)*y.pO2Bbase(mm),po2cal(:,1),po2cal(:,po2cnt+1),po2tr(po2cnt));
        y.pO2Bcal(:,mm)=myfilter(y.pO2Bcal(:,mm),fco,ts);
      else,
        y.pO2Bcal(:,mm)=po2cal2(y.pO2B(:,mm)*y.pO2Bbase(mm),po2cal(:,1),po2cal(:,po2cnt+1));
      end;
      y.pO2Bcalbase(mm)=mean(y.pO2Bcal(ii0,mm));
      y.pO2Bcal(:,mm)=y.pO2Bcal(:,mm)/mean(y.pO2Bcal(ii0,mm));
    end;
  end;
end;
if isfield(x,'pO2C'),
  for mm=1:ddim(2),
    tmppO2C=myfilter(x.pO2C(:,mm),fco,ts);
    if detrend_flag,
      tmpp=polyfit(tt(dii),tmppO2C(dii),dord);
      tmpv=polyval(tmpp,tt);
      tmppO2C=tmppO2C-tmpv+mean(tmpv);
    end;
    if interp_flag,
      tmppO2Ci=interp1(tt,tmppO2C,tti);
      clear tmppO2C
      tmppO2C=tmppO2Ci;
    end;
    y.pO2Cbase(mm)=mean(tmppO2C(ii0));
    y.pO2C(:,mm)=tmppO2C/mean(tmppO2C(ii0));
  end;
  if po2cal_flag,
    po2cnt=po2cnt+1;
    for mm=1:ddim(2),
      if po2cal_flag==2,
        y.pO2Ccal(:,mm)=po2cal2(y.pO2C(:,mm)*y.pO2Cbase(mm),po2cal(:,1),po2cal(:,po2cnt+1),po2tr(po2cnt));
        y.pO2Ccal(:,mm)=myfilter(y.pO2Ccal(:,mm),fco,ts);
      else,
        y.pO2Ccal(:,mm)=po2cal2(y.pO2C(:,mm)*y.pO2Cbase(mm),po2cal(:,1),po2cal(:,po2cnt+1));
      end;
      y.pO2Ccalbase(mm)=mean(y.pO2Ccal(ii0,mm));
      y.pO2Ccal(:,mm)=y.pO2Ccal(:,mm)/mean(y.pO2Ccal(ii0,mm));
    end;
  end;
end;

%keyboard,

