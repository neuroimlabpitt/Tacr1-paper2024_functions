function vol=volzAdj1(vol,adjv,env)
% Usage ... y=volzAdj1(vol,adjvec,env)

vdim=size(vol);

if nargin<3, env=ones(vdim(end),1); end;

if length(env)==1,
  env=(1-[1:vdim(end)]/(vdim(end)/env));
  plot(env)
elseif length(env)==2,
  tmpenv=(1-[1:vdim(end)]/(vdim(end)/env(1)));
  tmpenv=exp(tmpenv*env(2));
  env=tmpenv;
  plot(env);
end;

if ischar(adjv),
  if strcmp(adjv,'mean')|strcmp(adjv,'avg'),
    adjv=1./mean(vol,length(vdim));
  elseif strcmp(adjv,'max'),
    adjv=1./max(vol,[],length(vdim));
  elseif strcmp(adjv,'min'),
    adjv=1./min(vol,[],length(vdim));
  else,
    adjv=ones(vdim(end),1);
  end;
end;

if prod(size(adjv))==length(adjv),
  if length(vdim)==4, adjv=repmat(adjv,[1 vdim(3)]); end;
end;

if length(vdim)==4,
  for mm=1:vdim(4), for nn=1:vdim(3),
    vol(:,:,nn,mm)=vol(:,:,nn,mm)*adjv(mm,nn);
  end; end;
else,
  for mm=1:vdim(3),
    vol(:,:,mm)=vol(:,:,mm)*adjv(mm)*env(mm);
  end;
end;

