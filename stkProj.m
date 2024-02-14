function [y,ii]=stkProj(stk,range,dim,type)
% Usage ... [y,ii]=stkProj(stk,range,dim,type)
%
% Range is the start-end indeces for the desired
% dim dimension to take the projection of
% default is max in all directions. select option only works
% in 1 direction
%
% Ex. zMax=stkProj(data,[14 70],3,'max'); or zMax=stkProj(data,'select');

stk=squeeze(stk);

if ~exist('type','var'), type='max'; end;
if ~exist('range','var'), range=[]; end;
if ~exist('dim','var'), dim=[]; end;

if isempty(dim), dim=[3 1 2]; end;
if ischar(type), if strcmp(type,'mean'), do_type=1; else, do_type=2; end; end;

do_select=0;
if ischar(range),
  if strcmp(range,'select'), do_select=1; end;
else,
  if length(range)==2, ii=[range(1):range(2)]; end;
end;

if do_select,
  dim=dim(1);
  if dim==1, showStack(stk(:,:,[2 3 1])),
  elseif dim==2, showStack(stk(:,:,[3 1 2])),
  else, showStack(stk);
  end;
  tmprange=input('  enter desired range in braces [i1 i2]: ');
  ii=[tmprange(1):tmprange(2)];
end;

if ischar(dim),
  for mm=1:length(dim),
    if strcmp(dim(mm),'x'), dim(mm)=1;
    elseif strcmp(dim(mm),'y'), dim(mm)=2;
    else, dim(mm)=3;
    end;
  end;
end;

if length(dim)==1,
  if do_type==1,
    if dim==1,
      if isempty(range), ii=[1:size(stk,1)]; end;
      eval(sprintf('y=%s(stk(ii,:,:),1);',type));
    elseif dim==2,
      if isempty(range), ii=[1:size(stk,2)]; end;
      eval(sprintf('y=%s(stk(:,ii,:),2);',type));
    else,
      if isempty(range), ii=[1:size(stk,3)]; end;
      eval(sprintf('y=%s(stk(:,:,ii),3);',type));
    end;
  else,
    if dim==1,
      if isempty(range), ii=[1:size(stk,1)]; end;
      eval(sprintf('y=%s(stk(ii,:,:),[],1);',type));
    elseif dim==2,
      if isempty(range), ii=[1:size(stk,2)]; end;
      eval(sprintf('y=%s(stk(:,ii,:),[],2);',type));
    else,
      if isempty(range), ii=[1:size(stk,3)]; end;
      eval(sprintf('y=%s(stk(:,:,ii),[],3);',type));
    end;
  end;
  %[ii([1 end])],
else,
  for mm=1:length(dim),
    if do_type==1,
      if dim(mm)==1,
        if isempty(range), ii=[1:size(stk,1)]; end;
        eval(sprintf('y.xi=ii; y.x=%s(stk(ii,:,:),1);',type));
      elseif dim(mm)==2,
        if isempty(range), ii=[1:size(stk,2)]; end;
        eval(sprintf('y.yi=ii; y.y=%s(stk(:,ii,:),2);',type));
      else,
        if isempty(range), ii=[1:size(stk,3)]; end;
        eval(sprintf('y.zi=ii; y.z=%s(stk(:,:,ii),3);',type));
      end;
    else,
      if dim(mm)==1,
        if isempty(range), ii=[1:size(stk,1)]; end;
        eval(sprintf('y.xi=ii; y.x=%s(stk(ii,:,:),[],1);',type));
      elseif dim(mm)==2,
        if isempty(range), ii=[1:size(stk,2)]; end;
        eval(sprintf('y.yi=ii; y.y=%s(stk(:,ii,:),[],2);',type));
      else,
        if isempty(range), ii=[1:size(stk,3)]; end;
        eval(sprintf('y.zi=ii; y.z=%s(stk(:,:,ii),[],3);',type));
      end;
    end;
  end; 

end;

