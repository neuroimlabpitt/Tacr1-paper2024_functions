function showMovie(data,subim,wl,pausetime,mycmap,do_write)
% Usage ... showMovie(data,subIm,wl,pauseTime,cmap,writeims)
%
% data is a 3-dim variable with time images to show
% when subIm is supplied, subtracted images will be showed
% wl will fix the windowing to [min max] if specified
% pauseTime will show the movie slower
% if pauseTime is set to 'write' the images will be saved as jpeg
% a colormap may be specified

data=squeeze(data);
if length(size(data))==4, do_color=1; else, do_color=0; end;

if ~exist('subim','var'), subim=[]; end;
if ~exist('wl','var'), wl=[]; end;
if ~exist('pausetime','var'), pausetime=[]; end;
if ~exist('mycmap','var'), mycmap=[]; end;
if ~exist('do_write','var'), do_write=0; end;

do_pause=1;

if isempty(mycmap), colormap(gray); else, colormap(mycmap); end;
if isempty(subim), if do_color, subim=zeros(size(data(:,:,:,1))); else, subim=zeros(size(data(:,:,1))); end; end;
if isempty(pausetime), do_pause=0; end;
if ischar(pausetime), 
  if strcmp(pausetime,'write'), do_write=1; end; 
  if strcmp(pausetime,'WRITE'), do_write=2; end; 
  if strcmp(pausetime,'wait'), do_pause=2; end;
  if strcmp(pausetime(end-2:end),'mp4'), do_write=1; end;
  if strcmp(pausetime(end-2:end),'MP4'), do_write=1; end;
  if strcmp(pausetime(end-2:end),'mov'), do_write=1; end;
  if strcmp(pausetime(end-2:end),'MOV'), do_write=1; end;
end;
if ischar(do_write), movname=do_write; do_write=1; end;
if ischar(subim),
  if strcmp(subim,'avg')|strcmp(subim,'mean'),
    if do_color, subim=mean(data,4); else, subim=mean(data,3); end;
  end;
end;
if length(subim)==1, 
  if do_color, subim=data(:,:,:,subim); else, subim=data(:,:,subim); end;
end;
if do_color,
  tmpz=size(data,3); if tmpz>3, tmpz=3; end;
  tmpim=zeros(size(data,1),size(data,2),3);
  tmpim(:,:,1:tmpz)=subim;
  subim=tmpim;
end;

if do_write,
  do_newvideo=0;
  if exist('VideoWriter'),
     if exist('movname','var'), %continue
     elseif ischar(pausetime),
      if strcmp(pausetime(end-2:end),'mp4'), movname=pausetime;
      elseif strcmp(pausetime(end-2:end),'MP4'), movname=pausetime;
      elseif strcmp(pausetime(end-2:end),'mov'), movname=pausetime;
      elseif strcmp(pausetime(end-2:end),'MOV'), movname=pausetime;
      end;
    else, movname='tmpMovie.mp4';
    end;
    if exist(movname,'file'),
      tmpin=input(sprintf('  movie file %s exists [1=rewrite,0=quit]: ',movname));
      if isempty(tmpin), tmpin=1; end;
      if tmpin, unix(sprintf('rm tmpMovie.mp4',movname)); else, return, end;
    end;
    vid=VideoWriter(movname,'MPEG-4');
    vid.FrameRate=7;
    vid.Quality=100;
    open(vid);
    do_newvideo=1;
  elseif ~exist('tmp','dir'),
    disp('  creating tmp folder to save images...');
    unix('mkdir tmp');
  end;
  
end;

if do_color, nfr=size(data,4); else, nfr=size(data,3); end;

if (do_write==0)|(do_write==2),
  clf, 
  for mm=1:nfr,
    if do_color,
      tmpim=zeros(size(data,1),size(data,2),3);
      tmpim(:,:,1:tmpz)=data(:,:,:,mm);
      if isempty(wl),
        tmpim=imwlevel(tmpim-subim,[],1);
      else,
        tmpim=imwlevel(tmpim-subim,wl,1);
      end;
      image(tmpim),
    else,
      tmpim=data(:,:,mm)-subim;
      if isempty(wl),
        imagesc(tmpim),
        tmpim=imwlevel(tmpim,[],1);
      else,
        imagesc(tmpim,wl),
        tmpim=imwlevel(tmpim,wl,1);
      end;
    end;
    axis('image'),
    xlabel(sprintf('fr# %d',mm)),
    if do_pause==1, pause(pausetime), elseif do_pause==2, pause; end;
    drawnow,

    if do_write==2, % display first, then write
      tmpname=sprintf('tmp/tmp_%04d.jpg',mm);
      if isempty(wl),
        if do_newvideo, writeVideo(vid,tmpim);
        else, imwrite(imwlevel(data(:,:,mm)-subim,[],1),tmpname,'JPEG','Quality',100); end;
      else,
        if do_newvideo, writeVideo(vid,tmpim);
        else, imwrite(imwlevel(data(:,:,mm)-subim,wl,1),tmpname,'JPEG','Quality',100); end;
      end;
    end;
  end;
else,
  disp('  saving images as jpegs in tmp folder...');
  for mm=1:nfr,
    tmpname=sprintf('tmp/tmp_%04d.jpg',mm);
    if do_color,
      tmpim=zeros(size(data,1),size(data,2),3);
      tmpim(:,:,1:tmpz)=data(:,:,1:tmpz,mm)-subim(:,:,1:tmpz); 
    else, 
      tmpim=data(:,:,mm)-subim; 
    end;
    if isempty(wl),
      if do_newvideo, writeVideo(vid,imwlevel(tmpim,[],1));
      else, imwrite(imwlevel(tmpim,[],1),tmpname,'JPEG','Quality',100); end;
    else,
      if do_newvideo, writeVideo(vid,imwlevel(tmpim,wl,1));
      else, imwrite(imwlevel(tmpim,wl,1),tmpname,'JPEG','Quality',100); end;
    end;
  end;
end;

if do_write&do_newvideo,
  close(vid);
  disp(sprintf('  movie saved as %s',movname));
end;
