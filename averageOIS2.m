function averageOIS2(fname,fps,ntr,noff,nper,nfa,zoomdn,basediff)
% Usage ... averageOIS2(fname,fps,ntrials,offset,trialdur,desiredres,zoomdown,basediff)

if (nargin<8), basediff=[]; end;
if (nargin<7), zoomdn=[]; end;

if isempty(basediff),
  do_norm=0;
else,
  do_norm=1;
end;
if isempty(zoomdn),
  zoomdn=1;
  do_zoomdn=0;
else,
  do_zoomdn=abs(zoomdn)>0;
  if (do_zoomdn==0),
    zoomdn=1;
  else,
    zoomdn=2*abs(zoomdn);
  end;
end;


fname2=sprintf('%s',fname);
if (strcmp(fname(end-3:end),'.stk')),
  fname3=fname(1:end-4);
else,
  fname3=fname;
end;

verbose_flag=1;
if (verbose_flag),
  disp(sprintf('  Filename= \t%s',fname2));
  disp(sprintf('  DestFile= \t%s',fname3));
  disp(sprintf('  Fr/sec= \t%f',fps));
  disp(sprintf('  #Trials= \t%d',ntr));
  disp(sprintf('  #Off= \t%f (s)',noff));
  disp(sprintf('  Period= \t%f (s)',nper));
  disp(sprintf('  Des.Res.= \t%f',nfa));
  disp(sprintf('  ZmDn= \t%d x2 (%d)',do_zoomdn,zoomdn));
  disp(sprintf('  BaseDiff= \t%d (%d)',do_norm,basediff));
  disp('  ');
end;

tic,
disp(sprintf('Reading DC image'));
stk=tiffread2(fname2,1);
dcim=double(stk(1).data);
noff=round(noff*fps);
nper=round(nper*fps);
nfa=nfa*fps;

if (do_norm),
  if (length(basediff)<5),
    if (length(basediff)==1),
      basediff=[0 basediff];
      basediff=round(basediff*fps/nfa);
      basediff(1)=1;
    elseif (length(basediff)==2),
      basediff=basediff*fps/nfa;
      if (basediff(1)==0), basediff(1)=1; end;
    elseif (length(basediff)==4),
      basediff=basediff*fps/nfa;
      if (basediff(1)==0), basediff(1)=1; end;
      if (basediff(3)==0), basediff(3)=1; end;
    end;
  end;
end;

cnt=noff; cnt2=0;
avgim=zeros([size(dcim,1)/zoomdn size(dcim,2)/zoomdn round(nper/nfa)]);
avgim2=avgim;
for mm=1:ntr,
  disp(sprintf('Reading Trial # %d',mm));
  tmpim=zeros([size(dcim,1)/zoomdn size(dcim,2)/zoomdn round(nper/nfa)]);
  tmpim2=zeros(size(dcim)/zoomdn);
  tmpim3=zeros(size(dcim)/zoomdn);
  for nn=1:round(nper/nfa),
    clear tmpstk
    tmpstk=tiffread2(fname2,cnt+1,cnt+nfa);
    tmpim1=zeros(size(tmpstk(1).data));
    for oo=1:length(tmpstk),
      cnt2=cnt2+1; avgimtc(cnt2)=mean(mean(double(tmpstk(oo).data)));
      tmpim1=tmpim1+double(tmpstk(oo).data);
    end;
    tmpim1=tmpim1/nfa;
    avgtc(nn,mm)=mean(mean(tmpim1));
    if (do_zoomdn), tmpim1=zoomdn2(tmpim1); end;
    cnt=cnt+nfa;
    if (do_norm),
      if ((nn>=basediff(1))&(nn<=basediff(2))),
        tmpim2=tmpim2+tmpim1/(basediff(2)-basediff(1)+1);
      end;
      if (length(basediff)==4),
      if ((nn>=basediff(3))&(nn<=basediff(4))),
        tmpim3=tmpim3+tmpim1/(basediff(4)-basediff(3)+1);
      end;
      end;
    end;
    tmpim(:,:,nn)=tmpim(:,:,nn)+tmpim1;
  end;
  if (do_norm),
    disp(' subtracting trial baseline contribution');
    tmpim2dc=mean(mean(tmpim2));
    for nn=1:nper/nfa,
      tmpim(:,:,nn)=tmpim(:,:,nn)-tmpim2+tmpim2dc;
      tmpimdiv(:,:,nn)=tmpim(:,:,nn)./tmpim2;
    end;
  end;
  baseim(:,:,mm)=tmpim2;
  baseim2(:,:,mm)=tmpim3;
  avgim=avgim+tmpim*(1/ntr);
  avgim2=avgim2+tmpimdiv/ntr;
  clear tmpim tmpim1 tmpim2 tmpim3
end;

disp(sprintf('Saving data to %s.mat',fname3));
if (do_norm), 
  eval(sprintf('save %s.mat avgim avgim2 avgtc avgimtc baseim baseim2 noff ntr nper nfa do_norm do_zoomdn basediff dcim stk',fname3));
else,
  eval(sprintf('save %s.mat avgim avgim2 avgtc avgimtc noff ntr nper nfa do_norm do_zoomdn dcim stk',fname3));
end;
toc,

clear

