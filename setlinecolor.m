function oldcolor=setlinecolor(colors)
% Usage ... setlinecolor(colors)
%

dlha = get(gca,'children');

if (nargin==0),
  colors=[];
end;

if (isempty(colors)),
  getcol=1;
  colors=ones(length(dlha),3);
else,
  getcol=0;
end;

if (length(dlha)>1)&(size(colors,1)==1),
  disp('  making all lines the same color'),
  colors=ones(length(dlha),1)*colors;
elseif (length(dlha)>size(colors,1)),
  error(sprintf('Incorrect #lines (%d) vs. #colors (%d)',length(dlha),size(colors,1)));
end;

dlha = dlha(end:-1:1);
for mm = 1:length(dlha),
  oldcolor(mm,:) = get(dlha(mm),'Color');
  if (~getcol),
    set(dlha(mm),'Color',colors(mm,:));
  else,
    disp(sprintf(' #%d: [%.2f %.2f %.2f]',mm,oldcolor(mm,1),oldcolor(mm,2),oldcolor(mm,3)));
  end;
end;

%oldcolor=oldcolor(end:-1:1,:);

if nargout==0,
  clear oldcolor
end;

