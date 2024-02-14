function plotmany(x,y_vec,nmax,newaxis)
% Usage ... plotmany(x,y_vec,nmax,axis)

if nargin==1, y_vec=x; x=[1:size(y_vec,1)]'; end;
if nargin==2, if length(y_vec)==4, newaxis=y_vec; y_vec=x; x=[1:size(y_vec,1)]'; end; end;

if ~exist('nmax'), nmax=[]; end; 
if ~exist('newaxis'), newaxis=[]; end;

ydim=size(y_vec);
if isempty(nmax), nmax=ydim(end); end;
disp(sprintf('  #plots= %d',nmax));

if length(newaxis)==0, 
  redoaxis=0;
elseif length(newaxis)==4,
  redoaxis=4;
else,
  redoaxis=1;
end;

if size(y_vec,2)>nmax, do_more=1; nmore=ceil(size(y_vec,2)/nmax)-1; else, do_more=0; end;
nrows=ceil(sqrt(nmax));
ncols=ceil(nmax/nrows);

for mm=1:nmax,
  crow=rem(mm,ncols);
  ccol=floor(mm/ncols)+1;
  subplot(nrows,ncols,mm),
  if length(ydim)==3, plot(x,y_vec(:,:,mm)), else, plot(x,y_vec(:,mm)), end;
  axis('tight'), grid('on'),
  title(num2str(mm)),
  if redoaxis==1, tmpax=axis; tmpax([1:length(newaxis)])=newaxis; axis(tmpax); end;
  if redoaxis==4, axis(newaxis); end;
end;

if do_more,
  cnt=mm;
  for nn=1:nmore,
    figure,
    for oo=1:nmax,
      cnt=cnt+1;
      if cnt<=size(y_vec,2),
        subplot(nrows,ncols,oo),
        if length(ydim)==3, plot(x,y_vec(:,:,cnt)), else, plot(x,y_vec(:,cnt)), end;
        axis('tight'), grid('on'),
        title(num2str(cnt)),
        if redoaxis==1, tmpax=axis; tmpax([1:length(newaxis)])=newaxis; axis(tmpax); end;
        if redoaxis==4, axis(newaxis); end;
      end;
    end;
  end;
end;

