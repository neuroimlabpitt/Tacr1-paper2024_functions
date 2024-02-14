function [im,info]=readOIS3(fname,imno,prec,do_write)
% Usage ... [im,info]=readOIS3(fname,imno,prec,do_write)

% prec=[1:uint8,2:uint16,4:single,8:double];

if nargin<4, do_write=0; end;
if isempty(do_write), do_write=0; end;

do_transp=1;

if strcmp(fname(end-2:end),'raw'),
  if nargin==1, imno=1; end;
  [im,info]=readOIS(fname,imno);
  if do_transp,
    tmpim=zeros(size(im,2),size(im,1),size(im,3));
    for nn=1:size(im,3), tmpim(:,:,nn)=im(:,:,nn)'; end;
    clear im
    im=tmpim;
  end;
  return;
end;

if (nargout==2), info=imfinfo(fname); end;

if (nargin<3), prec=8; end;

if (nargin==1),
  %im=double(imread(fname));
  stk=tiffread2(fname,1);
  im=double(stk.data);
else,
  %im=double(imread(fname,imno));
  if isstr(imno)|(length(imno)==2),
    if isstr(imno),
      if strcmp(imno,'all'),
        stk=tiffread2(fname);
      end;
      %if prec==4,
      %  im=single(zeros(size(stk(1).data,1),stk(1).data,2,length(stk)));
      %  for mm=1:size(im,3), im(:,:,mm)=single(stk(mm).data); end;
      %if prec==2,
      %  im=uint16(zeros(size(stk(1).data,1),stk(1).data,2,length(stk)));
      %  for mm=1:size(im,3), im(:,:,mm)=uint16(stk(mm).data); end;
      %else, %prec==8
      %  im=zeros(size(stk(1).data,1),stk(1).data,2,length(stk));
      %  for mm=1:size(im,3), im(:,:,mm)=double(stk(mm).data); end;
      %end;
    else,
      stk=tiffread2(fname,imno(1),imno(2));
    end;
    if isempty(stk), im=[]; return; end;    
    if prec==1,
      im=uint8(zeros(size(stk(1).data,1),size(stk(1).data,2),length(stk)));
      for mm=1:length(stk), im(:,:,mm)=uint8(stk(mm).data); end;
    elseif prec==2,
      im=uint16(zeros(size(stk(1).data,1),size(stk(1).data,2),length(stk)));
      for mm=1:length(stk), im(:,:,mm)=uint16(stk(mm).data); end;
    elseif prec==4,
      im=single(zeros(size(stk(1).data,1),size(stk(1).data,2),length(stk)));       
      for mm=1:length(stk), im(:,:,mm)=single(stk(mm).data); end;
    else,
      im=zeros(size(stk(1).data,1),size(stk(1).data,2),length(stk));
      for mm=1:length(stk), im(:,:,mm)=double(stk(mm).data); end;
    end;
  else,
    for mm=1:length(imno),
      stk=tiffread2(fname,imno(mm));
      if isempty(stk), im=[]; return; end;
      if prec==1,
        im(:,:,mm)=uint8(stk.data);
      elseif prec==2,
        im(:,:,mm)=uint16(stk.data);
      elseif prec==4,
        im(:,:,mm)=single(stk.data);
      else,
        im(:,:,mm)=double(stk.data);
      end;
    end;
  end;
end;

if do_write,
    tmpname=sprintf('%s.jpg',fname(1:end-4));
    disp(sprintf('  writing %s ...',tmpname));
    imwrite(imwlevel(im(:,:,1),[],1),tmpname,'JPEG','BitDepth',12,'Quality',100);
end;

if nargout==0,
    clear im
end;




