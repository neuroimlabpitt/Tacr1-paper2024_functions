function show_positionMask2d(yy)
% Usage ... show_positionMask2d(out_str)

if (nargout==0)
  [tmpname,tmppath]=uigetfile('*.*','Select PositionMask File to Open');
  yy=[tmppath,tmpname];
  disp(sprintf('  loading %s',yy));
end;

if ischar(yy),
  load(yy),
  tmpvar=who; clear yy
  if exist('tmpname','var'),
    yy=ys; clear ys
  else,
    eval(sprintf('yy=%s;',tmpvar{1}));
  end;
end;

figure(1), clf,
for mm=1:length(yy.subIm),
    subplot(121), show(im_super(yy.mainIm,yy.mask{mm},0.5)), 
    subplot(122), show(yy.subIm{mm})
    pause,
end;