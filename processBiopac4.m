function f=processBiopac4(bio,tt,desres,skpii)
% Usage ... f=processBiopac4(bio,tt,desres,skpii)
% 
% Processing applied to all trials in structure

do_aux=1;
if do_aux&isfield(bio,'AUX3'), do_aux=1; else, do_aux=0; end;

original_flag=0;

dt=tt(2)-tt(1);
tmpii=find(tt>=0);
if isempty(tmpii),
  ii0=1;
else,
  ii0=tmpii(1);
end;
navg=round(desres/dt);
ii00=rem(ii0,navg)+1;
nsam=floor((size(bio.FLUX,1)-ii00+1)/navg);

f.ii00=ii00;
f.nsamp=nsam;
if original_flag,
  f.tt_orig=tt(ii00:ii00+nsam*navg-1);
  f.flux_orig=bio.FLUX(ii00:ii00+nsam*navg-1,:);
  f.tb_orig=bio.TB(ii00:ii00+nsam*navg-1,:);
  if do_aux,
    f.flux2_orig=bio.AUX3(ii00:ii00+nsam*navg-1,:);
    f.tb2_orig=bio.AUX2(ii00:ii00+nsam*navg-1,:);
  end;
end;
f.desiredRes=desres;
f.skpii=skpii;

for nn=1:nsam,
  tmpii=[1:navg]+(nn-1)*navg+ii00-1;
  cnt3=0; tmpii1=[];
  for oo=1:length(tmpii),
    if isempty(find(tmpii(oo)==skpii)),
      cnt3=cnt3+1;
      tmpii1(cnt3)=tmpii(oo);
    end;
  end;
  f.ns(nn)=cnt3;
  f.flux(nn,:)=sum(bio.FLUX(tmpii1,:),1)/cnt3;
  f.tb(nn,:)=sum(bio.TB(tmpii1,:),1)/cnt3;
  f.tt(nn)=sum(tt(tmpii1))/cnt3;
  if do_aux,
    f.flux2(nn,:)=sum(bio.AUX3(tmpii1,:),1)/cnt3;
    f.tb2(nn,:)=sum(bio.AUX2(tmpii1,:),1)/cnt3;
  end;
end;

