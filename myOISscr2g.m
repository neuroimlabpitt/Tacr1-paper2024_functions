function myOISscr2g(fname,nk,idname)
% Usage ... myOISscr2g(fname,nk,idname)
%
% This function writes masks onto pre-processed mat files to
% define ROIs for further analysis
% Setting a value of nk furhter defines ROIs using k-clustering
% If nk is replaced with fname2, masks are remapped
%
% Ex. myOISscr2g('');
%  or myOISscr2g('');

if ischar(nk),

  fname2=nk;
  disp(sprintf('  loading data from %s as reference',fname2));
  eval(sprintf('load %s data maskG kimG',fname2));
  tmpim_ref=data(:,:,1);
  maskG_ref=maskG;
  kimG_ref=kimG;
  clear data maskG kimG

  disp(sprintf('  loading data from %s',fname));
  eval(sprintf('load %s data',fname));
  tmpim1=data(:,:,1);

  [tmpim_ref1,xo0to1]=imFlipSelect(tmpim_ref,tmpim);
  maskG_ref1=imFlipSelect(maskG_ref,xo0to1);
  kimG_ref1=imFlipSelect(kimG_ref,xo0to1);
  xx0to1=myaffine2d_scr(tmpim_ref1,tmpim,[],'point-select');

  tmpim=zeros(size(tmpim1));
  kimG1=zeros(size(tmpim1));
  for mm=1:max(kimG_ref(:)),
    tmpim=myaffine2d_f(double(kimG_ref1==mm),xx0to1,size(kimG1));
    kimG1(find(tmpim.^2>0.5))=mm;
  end;
  for mm=1:max(maskG_ref(:)),
    tmpim=myaffine2d_f(double(maskG_ref1==mm),xx0to1,size(kimG1));
    maskG1(find(tmpim.^2>0.5))=mm;
  end;
  avgtcG1=getStkMaskTC(data,kimG1);
  tmpmr=mreg(mean(avgtcG1.atc,2),avgtcG1.atc);
  avgtcG1.atc_gr=tmpmr.yf;
  im1_ref=tmpim_ref;
  im1=tmpim1;
  clear data

  disp(sprintf('save %s -append im1_ref maskG_ref kimG_ref xo0to1 maskG_ref1 kimG_ref1 im1 maskG1 kimG1 avgtcG1',fname));
  eval(sprintf('save %s -append im1_ref maskG_ref kimG_ref xo0to1 maskG_ref1 kimG_ref1 im1 maskG1 kimG1 avgtcG1',fname));

else,

  do_mask=1;
  tmpname=fname;
  do_print=0;
  if nargin>2, do_print=1; end;
  do_kclust=0;
  if nargin>1, do_kclust=1; end;

  eval(sprintf('load %s data mask maskV maskG avgtcG',tmpname));
  %tmpim=data(:,:,1);
  tmpim=mean(data,3);
  
  if exist('maskG','var'),
    tmpin=input('  maskG found, overwrite? (0=no+exit, 1=yes, 2=no+cont): ');
    if ~isempty(tmpin),
      if tmpin==0,
        return,
      elseif tmpin==2,
        do_mask=0;
      end;
    end;
  end;

  if do_mask,
    disp('  select brain mask...');
    mask=selectMask(tmpim);

    disp('  select vessel mask (vessels=1)...');
    maskV=selectMask(tmpim.*mask);
    if sum(maskV(:).*mask(:))>0.3*prod(size(maskV)),
      tmpin=input('  invert maskV? (0=no, 1=yes): ');
      if ~isempty(tmpin), if tmpin==1, maskV=~maskV; end; end;
    end;

    disp(' select GCaMP mask...');
    maskG=bwlabel(selectMask(tmpim.*mask));
    maskGnV=bwlabel((maskG>0).*(~maskV));

    clf,
    subplot(221), show(tmpim),
    subplot(222), show(mask),
    subplot(223), show(maskV),
    subplot(224), show(maskG),
    drawnow,
    if do_print, eval(sprintf('print -dpng samplefig_%s_masks',idname)); end;

    clf, show(im_super(tmpim,maskGnV,0.5)), drawnow,
    if do_print, eval(sprintf('print -dpng samplefig_%s_maskGnV',idname)); end;

    avgtcG=getStkMaskTC(data,maskG);
    avgtcGnV=getStkMaskTC(data,maskGnV);
    clf, plot(avgtcGnV.atc), axis('tight'), grid('on'),
    if do_print, eval(sprintf('print -dpng samplefig_%s_avgtcGnV',idname)); end;
  
    %disp('  press any key to continue...'); pause;
    eval(sprintf('save %s -append mask maskV maskG maskGnV avgtcG avgtcGnV',tmpname));
  else,
    maskGnV=bwlabel((maskG>0).*(~maskV));
  end;

  if do_kclust,
    tmpnk=nk;
    myk=mykdecomp(data,tmpnk,maskGnV>0);

    tmpval=0.9*mean(myk.ks.rim(:));
    figure(1), clf, 
    subplot(121), tile3d(myk.ks.rim,[tmpval 1]), colormap jet, colorbar, 
    subplot(122), imagesc(myk.klim), axis image, colorbar, drawnow,
    if do_print, eval(sprintf('print -dpng samplefig_%s_myk%d_rims',idname,tmpnk(1))); end;
    figure(2), clf,
    show(data(:,:,1)), drawnow,
   
    tmpin=input('  select ROIs= ');
    kii=tmpin;
    maskGnew=zeros(size(maskG));
    kimG=zeros(size(maskG));
    for mm=1:length(kii),
      tmpim=myk.ks.rim(:,:,kii(mm));
      tmpii=find(maskGnV>0);
      thrG(mm)=mean(tmpim(tmpii))+1.00*std(tmpim(tmpii));
      kimG(find(myk.klim==kii(mm)))=mm;
      maskGnew(find((tmpim>thrG(mm))))=mm;
      %maskGnew(find((tmpim>thrG(mm))&(kimG==mm)))=mm;
    end;
    avgtcGk=getStkMaskTC(data,kimG);
    avgtcGnew=getStkMaskTC(data,maskGnew);
    tmpmr=mreg(mean(avgtcGk.atc,2),avgtcGk.atc);
    avgtcGk.atc_gr=tmpmr.yf;
    tmpmr=mreg(mean(avgtcGnew.atc,2),avgtcGnew.atc);
    avgtcGnew.atc_gr=tmpmr.yf;

    maskGk=kimG;
    maskG_orig=maskG; maskG=maskGnew;
    avgtcG_orig=avgtcG; avgtcG=avgtcGnew;

    figure(1), clf,
    subplot(211), imagesc(kimG), axis image, colormap jet, drawnow,
    subplot(212), plot(avgtcGnew.atc), axis tight, grid on, drawnow,
    if do_print, eval(sprintf('print -dpng samplefig_%s_maskGnew',idname)); end;
  
    eval(sprintf('save %s -append myk kii maskGnew kimG avgtcGnew avgtcGk avgtcG avgtcG_orig maskG maskG_orig maskGk',tmpname));
  end;
  
  clear data

end;

