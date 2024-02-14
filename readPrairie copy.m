function [f,header]=readPrairie(fname,imno,header)
% Usage ... [f]=readPrairie(fname,imno,header)


do_files=0;
if strcmp(fname(end-3:end),'.tif')|strcmp(fname(end-3:end),'.TIF'),
  do_files=1;
end;

if do_files,
  if length(imno)==2, imno=[imno(1):imno(2)]; end;
  for mm=1:length(imno),
    tmpname=sprintf('%s_%06d.tif',fname(1:end-11),imno(mm));
    disp(sprintf('  reading file %s',tmpname));
    tmpstk=tiffread2(tmpname);
    f(:,:,mm)=single(tmpstk.data);
  end;
else,
  if strcmp(fname(end),'/'),
    fname_xml=sprintf('%s/%s.xml',fname,fname(1:end-1));
  else,
    fname_xml=sprintf('%s/%s.xml',fname,fname);
  end;
  if ~exist(fname_xml),
    [tmp1,fname_xml]=unix(sprintf('ls -1 %s/*.xml | head -1',fname));
    if strcmp(fname_xml(end-1),'*'),
      tmpxml=fname_xml(1:end-2);
      clear fname_xml
      fname_xml=tmpxml;
    end;
  end;
  if ~exist('header'),
    disp(sprintf('  reading xml file %s',fname_xml));
    header=parsePrairieXML(fname_xml);
  end;
  if ~exist('imno'), imno=[1:length(header.Sequence.Frame)]; end;
  if imno==0,
    f=header;
  else,
    nch=length(header.Sequence.Frame(1).File);
    for mm=1:length(imno),
      for nn=1:nch,
        tmpname=sprintf('%s/%s',fname,header.Sequence.Frame(imno(mm)).File(nn).Filename);
        disp(sprintf('  reading file %s',tmpname));
        tmpstk=tiffread2(tmpname);
        header.Sequence.Frame(imno(mm)).data(:,:,nn)=(tmpstk.data);
        %f(:,:,nn,mm)=single(tmpstk.data);
      end;
    end;
  end;
end;

if ~exist('f','var'), f=header; end;

