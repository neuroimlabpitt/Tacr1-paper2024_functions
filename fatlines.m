function fatlines(wid,ii)
dlha = get(gca,'children');
if nargin==0, wid=2; end;
if isempty(wid), disp(sprintf(' #lines= %d',length(dlha))); return, end;
if ~exist('ii'), ii=[1:length(dlha)]; end;
if isempty(ii), disp(sprintf(' #lines= %d',length(dlha))); end;
set(dlha(ii),'LineWidth',wid);
clear dlha
