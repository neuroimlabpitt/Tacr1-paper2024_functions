function myOISscr1_wrap(flist,saveid,opt1,opt2,vars2load,skip1load,checkflag)
% Usage ... myOISscr1_wrap(filelist,saveids,option1str,optionAllstr,loadVars,skip1load,checkflag)
%
% Ex.
%   opt1=sprintf('''do_load'',[1:6200],''do_crop'',''do_bin'',[2 2 2],''do_binfirst'',''do_motc'',''do_maskreg'',''do_intc''');
%   opt2=sprintf('''do_load'',[1:6200],''do_crop'',crop_ii,''do_bin'',[2 2 2],''do_binfirst'',''do_motc'',''do_maskreg'',mask_reg,''do_intc''');
%   myOISscr1_wrap('*.stk',[],opt1,opt2,{'crop_ii','mask_reg'})
% or
%   opt1=sprintf('''do_load'',[1:9302],''do_crop'',''do_bin'',[3 3 3],''do_binfirst'',''do_motc'',''do_maskreg'',''do_intc''');
%   opt2=sprintf('''do_load'',[1:9302],''do_crop'',crop_ii,''do_bin'',[3 3 3],''do_binfirst'',''do_motc'',''do_maskreg'',mask_reg,''do_intc''');
%   myOISscr1_wrap('*.raw',[],opt1,opt2,{'crop_ii','mask_reg'})

do_testload=0;
if nargin==1, do_testload=1; end;

if do_testload,
  tmpdir=dir(flist);
  for mm=1:length(tmpdir),
    im1_all{mm}=readOIS3(tmpdir(mm).name);
    info_all{mm}=imfinfo(tmpdir(mm).name);
    tmpi=strfind(info_all{1}.ImageDescription,'Exposure');
    info_all{mm}.nImages=length(tmpi);
  end;
  fnames=tmpdir;
  save tmp_wrap_res im1_all info_all fnames
  return,
end;

do_dryrun=0;

if nargin<7, checkflag=0; end;
if nargin<6, skip1load=[]; end;
if nargin<5, vars2load=[]; end;
if nargin<4, opt2=[]; end;

if checkflag, do_dryrun=1; end;

if isempty(flist),
  tmpdir=dir('*.stk');
  if isempty(tmpdir), tmpdir=dir('*.raw'); end;
  if isempty(tmpdir), tmpdir=dir('*.tif'); end;
  if isempty(tmpfir),
    disp('  error: no files found');
    return,
  end;
end;

if isstruct(flist),
  tmpdir=flist;
end;

if ischar(flist),
  disp(sprintf('  searching for files %s',flist));
  tmpdir=dir(flist);
  for mm=1:length(tmpdir),
    tmpflist{mm}=tmpdir(mm).name;
  end;
  flist=tmpflist;
end;

if iscell(flist), if length(flist)==1,
  tmpdir=dir(flist{1});
end; end;

if exist('tmpdir','var'),
  for mm=1:length(tmpdir),
    tmpflist{mm}=tmpdir(mm).name;
  end;
  flist=tmpflist;
end;

do_loadvars=0;
if ~isempty(vars2load),
  do_loadvars=1;
  tmpvars2load=[];
  for mm=1:length(vars2load),
    tmpvars2load=[tmpvars2load,' ',vars2load{mm}];
    %if ~istrcmp(opt2{mm}(1:3),'do_'),
    %  tmpvars2load=[tmpvars2load,' ',opt2{mm}];
    %end;
  end;
  disp(sprintf('  load vars (#%d)= %s',mm,tmpvars2load));
end;

if checkflag,
  disp('  Check images and dry-run');
  for mm=1:length(flist),
    figure(1), clf, show(flist{mm}),
    xlabel(sprintf('file #%d: %s',mm,flist{mm}));
    disp(sprintf(' file #%d: %s',mm,flist{mm}));
    drawnow, pause;
  end;
  disp('  check done');
end;

if isempty(saveid), do_makeid=1; else, do_makeid=0; end;

if do_makeid,
  for mm=1:length(flist),
    saveid{mm}=flist{mm}(1:end-4);
  end;
end;

if isempty(skip1load),
  i1=1;
else,
  i1=2;
  disp(sprintf('  loading %s_res  %s',saveid{1},tmpvars2load));
  eval(sprintf('  load %s_res %s',saveid{1},tmpvars2load));
end;

for mm=i1:length(flist),
  if mm==1,
    if do_dryrun,
      disp(sprintf('  myOISscr1_new(''%s'',''%s'',%s);',flist{mm},saveid{mm},opt1));
      disp(sprintf('  loading %s_res  %s',saveid{mm},tmpvars2load));
    else,
      disp(sprintf('  myOISscr1_new(flist{mm},saveid{mm},%s);',opt1));
      eval(sprintf('  myOISscr1_new(flist{mm},saveid{mm},%s);',opt1));
      if do_loadvars,
        disp(sprintf('  loading %s_res  %s',saveid{mm},tmpvars2load));
        eval(sprintf('  load %s_res %s',saveid{mm},tmpvars2load));
      end;
    end;
  else,
    if do_loadvars,
      if do_dryrun,
        disp(sprintf('  myOISscr1_new(''%s'',''%s'',%s);',flist{mm},saveid{mm},opt2));
      else,
        disp(sprintf('  myOISscr1_new(flist{mm},saveid{mm},%s);',opt2));
        eval(sprintf('  myOISscr1_new(flist{mm},saveid{mm},%s);',opt2));
      end;
    else,
      if do_dryrun,
        disp(sprintf('  myOISscr1_new(''%s'',''%s'',%s);',flist{mm},saveid{mm},opt1));
      else,
        disp(sprintf('  myOISscr1_new(flist{mm},saveid{mm},%s);',opt1));
        eval(sprintf('  myOISscr1_new(flist{mm},saveid{mm},%s);',opt1));
      end;
    end;
  end;
end;

