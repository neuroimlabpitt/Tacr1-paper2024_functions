function y=str2varname(x)
% Usage ... y=str2varname(x)

x=deblank(x);
cnt=1;
for mm=1:length(x),
  if strcmp(x(mm),'-'),
    y(cnt)='_';
    cnt=cnt+1;
  elseif strcmp(x(mm),' '),
    % skip
  else,
    y(cnt)=x(mm);
    cnt=cnt+1;
  end;
end;

if (nargout==0),
  disp(sprintf('  in-Str: %s',x));
  disp(sprintf('  out-Str: %s',y));
end;

