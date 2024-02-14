function [varargout] = setpapersize(psize)
% Usage ... setpapersize OR setpapersize([W H])
% 
% Sizes are in inches, if no input is provided it will set it to the
% figure's screen size.
% Note: it is best to print to a PostScript file of some sort since
% printing to a .pdf file may give problems since the new paper size will
% probably not correspond to any standard (e.g., US Letter, A4, etc.).

% version 1.1
% DD Steele, 16 Feb 2005
% A Vazquez, 14 Apr 2005

DEFAULTPAPERSIZE=[8 6];

if nargin == 1
  getsize_flag=0;
else
  getsize_flag=1;
end

if nargout > 1
    error('May only have one output.');
end


set(gcf,'Units','inches');
paperpos = get(gcf,'Position');
papersz = get(gcf,'PaperSize');

if getsize_flag
  psize=paperpos(3:4);
  %disp(sprintf('  size= [%.2f %.2f]  psize=[ %.2f %.2f]',psize(1),psize(2),papersz(1),papersz(2)));
else
  newpos=[paperpos(1:2) paperpos(3:4).*(psize./DEFAULTPAPERSIZE)];
  set(gcf,'Position',newpos);
  %disp(sprintf('  screen= [%.2f %.2f],  paper= [%.2f %.2f]',newpos(3),newpos(4),psize(1),psize(2)));
end

set(gcf,'PaperSize',[psize(1) psize(2)]);
set(gcf,'PaperPositionMode','auto');            % centers figure on page

if nargout == 0
    return;
else
    varargout(1) = {paperpos};
end

