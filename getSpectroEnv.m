function dout=getSpectroEnv(data,t,wt,wr,wot,fs)
% Usage ... y=getSpectroEnv(x,t,ww_twid,ww_franges,ww_tskip,fs)
%
% data, time (t) for data, wt (window width in time),
% wr (frequency ranges), wot (window skip time), fs (sampling freq),


if ~exist('fs'), fs=1/mean(diff(t)); end;
if ~exist('wot'), wot=1/fs; end;

if length(data)==prod(size(data)),
  data=data(:);
end;

datalen=size(data,1);
ff=[0:datalen]*fs/datalen;
nwr=size(wr,1);

w_wid=round(fs*wt);
w_skip=round(fs*wot);
ww=hamming(w_wid);
ffw=[0:w_wid-1]*fs/w_wid;
for mm=1:nwr,
  wwi{mm}=find((ffw>=wr(mm,1))&(ffw<=wr(mm,2)));
  wr_n{mm}=length(wwi{mm});
end;
wwii=find((ffw>=min(min(wr)))&(ffw<=max(max(wr))));
wr_avg=mean(wr');

cnt=0;
found=0;
while(~found),
  cnt=cnt+1;
  tmppi=(cnt-1)*w_skip;
  tmpii=[tmppi+1:tmppi+w_wid];
  if (tmpii(end)<=datalen),
    tt(cnt)=mean(t(tmpii));
    for nn=1:size(data,2),
      tmpdata=data(tmpii,nn).*ww;
      tmpdataf=abs(fft(tmpdata).^2);
      tmpdatas=sum(tmpdataf);
      yim(cnt,:,nn)=tmpdataf(wwii);
      for mm=1:nwr,
        yy(cnt,mm,nn)=sum(tmpdataf(wwi{mm}));
      end;
      yy(cnt,mm+1,nn)=tmpdatas;
    end;
  else,
    found=1;
  end;
end;

for mm=1:size(yy,2)-1, for nn=1:size(data,2),
  yyn(:,mm,nn)=yy(:,mm,nn)./yy(:,end,nn);
end; end;


dout.fr=wr;
dout.fr_avg=wr_avg;
dout.ww=ww;
dout.fw=ffw;
dout.w_wid=w_wid;
dout.w_skip=w_skip;
dout.wwi=wwi;
dout.t=tt;
dout.y=yy;
dout.yn=yyn;
dout.fim=ffw(wwii);
dout.yim=yim;

if nargout==0,
  mesh(tt,double(dout.fim),double(yim)'), view(2), shading interp, axis tight,
  tmplim=get(gca,'clim'); title(sprintf('%.3e/%.3e',tmplim(1),tmplim(2)));
end;



