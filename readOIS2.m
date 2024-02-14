function [y,dimage,header]=readOIS(fname,im)
% Usage ... y=readOIS(fname,im)
%
% If a range of images is selected, a 3D set is returned

verbose_flag=0;

fid=fopen(fname,'rb','l');
if (fid<3), error('Could not open file!'); end;

if (fname(end-5:end)=='oldraw'),
  verinfo='    ';
  dateinfo='                        ';
  hdroff=8;
else,
  verinfo=char(fread(fid,4,'char'));	% version
  dateinfo=char(fread(fid,24,'char'));	 % date
  hdroff=36;
end;
nx=fread(fid,1,'short'); %width
ny=fread(fid,1,'short'); %height
nf=fread(fid,1,'short'); %frames
nc=fread(fid,1,'short'); %not used

header.verinfo=verinfo';
header.dateinfo=dateinfo';
header.nx=nx;
header.ny=ny;
header.nfr=nf;
header.ncam=nc;
header.offset=hdroff;

if (verbose_flag),
  disp(sprintf('  xdim= %d, ydim= %d, nfr= %d, ncam= %d',nx,ny,nf,nc));
end;

dimage=fread(fid,[nx ny],'short');
fpos=ftell(fid);

avg_flag=0;
if (nargin==1), im=0; end;
if (isstr(im)),
  if (im=='all'),
    im=[1:nf];
  elseif (im=='first'),
    im=1;
  elseif (im=='last'),
    im=nf;
  elseif (im=='avg'),
    im=[1:nf];
    avg_flag=1;
  else,
    disp('Returning reference image...')
    im=0;
  end;
end;

if (length(im)==1),
  if (im==0),
    y=dimage;
    dimage=header;
  else,
    fstat=fseek(fid,nx*ny*(im-1)*1,'cof');
    if (fstat~=0), error('Could not get the requested image'); end;
    %y=fread(fid,[nx ny],'int8')+dimage;
    y=fread(fid,[nx ny],'int8');
    if (verbose_flag), disp(sprintf('  floc_end= %d',ftell(fid))); end;
  end;
elseif (avg_flag),
  tmp=0;
  for mm=1:nf,
    tmp=tmp+fread(fid,[nx ny],'int8');
  end;
  y=dimage+tmp/nf;
else,
  y=zeros(nx,ny,length(im));
  for mm=1:length(im),
    fstat=fseek(fid,fpos+nx*ny*(im(mm)-1)*1,'bof');
    if (fstat~=0), error(sprintf('Could not get the requested image (%d)',im(mm))); end;
    %y(:,:,mm)=fread(fid,[nx ny],'int8')+dimage;
    y(:,:,mm)=fread(fid,[nx ny],'int8');
    if (verbose_flag), disp(sprintf('  floc_end= %d',ftell(fid))); end;
  end;
end;

fclose(fid);

