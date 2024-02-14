function im=readlsm(fname,imno,chName)
% Usage ... function im=readlsm(fname,imno,chName)

if nargin<3,
  ch_flag=0;
else,
  ch_flag=1;
end;

if nargin<2,
  imno=1;
end;

if isstr(imno),
  found=0; cnt=1; tmpim=0;
  while(~found),
    tmpstk=tiffread2c(fname,cnt);
    if isempty(tmpstk),
      found=1;
    else,
      if ch_flag,
        eval(sprintf('im(:,:,cnt)=double(stk.%s);',chName));
      else,
        im(:,:,cnt)=double(tmpstk.data);
      end;
      cnt=cnt+1;
    end;
  end;
else,
  if length(imno)==2,
    stk=tiffread2c(fname,imno(1),imno(2));
  else,
    stk=tiffread2c(fname,imno);
  end;
  if ch_flag,
    eval(sprintf('im=[stk(:).%s];',chName));
  else,
    im=[double(stk(:).data)];
  end;
  im=reshape(im,size(im,1),stk(1).height,size(im,2)/stk(1).height);
end;



