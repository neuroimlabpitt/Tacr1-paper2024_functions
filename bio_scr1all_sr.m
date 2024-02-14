
clear all
close all

do_save=1;
do_detrend=1;


varnames={{'dyn1l1p0a','nk1r',[11 12 13 14 15],[-5 -1 36 39]},
          {'dyn1l1p0b','nk1r',[11 12 13 14 15],[-5 -1 36 39]},
          {'dyn1l1p0c','nk1r',[11 12 13 14 15],[-5 -1 36 39]},
          {'dyn2l1p0b','nk1r',[11 12 13 14 15],[-5 -1 36 39]},
          {'dyn4l1p0b','nk1r',[11 12 13 14 15],[-5 -1 36 39]},
          {'dyn8l1p0b','nk1r',[11 12 13 14 15],[-5 -1 36 39]},
          {'dyn1wh1','nk1r',[12 13 15],[-5 -1 36 39]},
          {'dyn1l1p0aS','nk1r',[12 13 14 15],[-4 -1 26 29]},
          {'dyn1l1p0bS','nk1r',[11 12 13 14 15],[-4 -1 26 29]},
          {'dyn1l1p0cS','nk1r',[12 13 14 15],[-4 -1 26 29]},
          {'dyn2l1p0bS','nk1r',[11 12 13 14 15],[-4 -1 26 29]},
          {'dyn4l1p0bS','nk1r',[11 12 13 14 15],[-4 -1 26 29]},
          {'dyn8l1p0bS','nk1r',[11 12 13 14 15],[-4 -1 26 29]},
          {'dyn1wh1S','nk1r',[12 13 15],[-4 -1 26 29]},
          {'dyn1l1p0bL','nk1r',[11 12 13 14 15],[-5 -1 53 58]},
          {'dyn1wh1L','nk1r',[12 13 15],[-5 -1 53 58]}};
         


studies{1}={'Study List by Type'};
studies{11}={'20170313mouse_nosk1','/Volumes/PhysRAID/towi/data/chr2_gaba_cre/'};
studies{12}={'20170327mouse_nosk3','/Volumes/PhysRAID/towi/data/chr2_gaba_cre/'};
studies{13}={'20170621mouse_nosk5','/Volumes/PhysRAID/towi/data/chr2_gaba_cre/'};
studies{14}={'20171129mouse_noskch1','/Volumes/PhysRAID/towi/data/chr2_gaba_cre/'};
studies{15}={'20180117mouse_nrk1c','/Volumes/PhysRAID/towi/data/chr2_gaba_cre/'};


for mm=1:length(varnames), 
  for nn=1:length(varnames{mm}{3}),
    ii=varnames{mm}{3}(nn);
    disp(sprintf('  var= %s  studyid= %d',varnames{mm}{1},ii));
    disp(sprintf('  load %s/%s/Biopac/biopac_data %s_new',studies{ii}{2},studies{ii}{1},varnames{mm}{1}));
    eval(sprintf('load %s/%s/Biopac/biopac_data %s_new',studies{ii}{2},studies{ii}{1},varnames{mm}{1}));

    tmpvarname=sprintf('%s_%s',varnames{mm}{1},varnames{mm}{2});
    eval(sprintf('%s_bioall.studies=varnames{mm}{3};',tmpvarname));
    eval(sprintf('%s_bioall.tt=%s_new.tt;',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.StimON_orig=%s_new.StimON_orig;',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.HR(nn)=mean(%s_new.HRavg);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.HRs(nn)=mean(%s_new.HRstd);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.FLUXbase(nn)=mean(%s_new.FLUXbase);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.FLUXbases(nn)=std(%s_new.FLUXbase);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.TBbase(nn)=mean(%s_new.FLUXbase);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.TBbases(nn)=std(%s_new.FLUXbase);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.FLUXall{nn}=%s_new.FLUX;',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.TBall{nn}=%s_new.TB;',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.FLUX(:,nn)=mean(%s_new.FLUX,2);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.FLUXs(:,nn)=std(%s_new.FLUX,[],2);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.TB(:,nn)=mean(%s_new.TB,2);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.TBs(:,nn)=std(%s_new.TB,[],2);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('tmpflag2=isfield(%s_new,''FLUX2'');',varnames{mm}{1}));
    if tmpflag2,
      eval(sprintf('%s_bioall.FLUX2all{nn}=%s_new.FLUX2;',tmpvarname,varnames{mm}{1}));
      eval(sprintf('%s_bioall.TB2all{nn}=%s_new.TB2;',tmpvarname,varnames{mm}{1}));
      eval(sprintf('%s_bioall.FLUX2(:,nn)=mean(%s_new.FLUX2,2);',tmpvarname,varnames{mm}{1}));
      eval(sprintf('%s_bioall.FLUX2s(:,nn)=std(%s_new.FLUX2,[],2);',tmpvarname,varnames{mm}{1}));
      eval(sprintf('%s_bioall.TB2(:,nn)=mean(%s_new.TB2,2);',tmpvarname,varnames{mm}{1}));
      eval(sprintf('%s_bioall.TB2s(:,nn)=std(%s_new.TB2,[],2);',tmpvarname,varnames{mm}{1}));
    end;
    eval(sprintf('%s_bioall.ts=%s_new.flxtb.tt;',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.fluxsall{nn}=%s_new.flxtb.flux;',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.tbsall{nn}=%s_new.flxtb.tb;',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.fluxs(:,nn)=mean(%s_new.flxtb.flux,2);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.fluxss(:,nn)=std(%s_new.flxtb.flux,[],2);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.tbs(:,nn)=mean(%s_new.flxtb.tb,2);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('%s_bioall.tbss(:,nn)=std(%s_new.flxtb.tb,[],2);',tmpvarname,varnames{mm}{1}));
    eval(sprintf('clear %s_new',varnames{mm}{1}));
  end;
  eval(sprintf('%s_bioall.HRavg=mean(%s_bioall.HR);',tmpvarname,tmpvarname));
  eval(sprintf('%s_bioall.HRstd=std(%s_bioall.HR);',tmpvarname,tmpvarname));
  eval(sprintf('%s_bioall.FLUXbaseavg=mean(%s_bioall.FLUXbase);',tmpvarname,tmpvarname));
  eval(sprintf('%s_bioall.FLUXbasestd=std(%s_bioall.FLUXbase);',tmpvarname,tmpvarname));
  eval(sprintf('%s_bioall.TBbaseavg=mean(%s_bioall.TBbase);',tmpvarname,tmpvarname));
  eval(sprintf('%s_bioall.TBbasestd=std(%s_bioall.TBbase);',tmpvarname,tmpvarname));

  if do_detrend, 
    tmpiis=varnames{mm}{4};
    eval(sprintf('tmpdata=mean(%s_bioall.FLUX,2); tmptt=%s_bioall.tt;',tmpvarname,tmpvarname));
    eval(sprintf('tmpbase=mean(%s_bioall.FLUXbase,2);',tmpvarname));
    tmpdata=tmpdata.*(ones(size(tmpdata,1),1)*tmpbase);
    tmpi0=find((tmptt>tmpiis(1))&(tmptt<tmpiis(2))); tmpi9=find((tmptt>tmpiis(3))&(tmptt<tmpiis(4)));
    tmpdatad=tcdetrend(tmpdata,1,[tmpi0(1) tmpi0(end) tmpi9(1) tmpi9(end)]);
    tmpdatad=tmpdatad./(ones(size(tmpdatad,1),1)*mean(tmpdatad(tmpi0,:),1));
    eval(sprintf('%s_bioall.FLUXavg=mean(tmpdatad,2);',tmpvarname));
    eval(sprintf('%s_bioall.FLUXstd=std(tmpdatad,[],2);',tmpvarname));

    eval(sprintf('tmpdata=mean(%s_bioall.TB,2); tmptt=%s_bioall.tt;',tmpvarname,tmpvarname));
    eval(sprintf('tmpbase=mean(%s_bioall.TBbase,2);',tmpvarname));
    tmpdata=tmpdata.*(ones(size(tmpdata,1),1)*tmpbase);
    tmpi0=find((tmptt>tmpiis(1))&(tmptt<tmpiis(2))); tmpi9=find((tmptt>tmpiis(3))&(tmptt<tmpiis(4)));
    tmpdatad=tcdetrend(tmpdata,1,[tmpi0(1) tmpi0(end) tmpi9(1) tmpi9(end)]);
    tmpdatad=tmpdatad./(ones(size(tmpdatad,1),1)*mean(tmpdatad(tmpi0,:),1));
    eval(sprintf('%s_bioall.TBavg=mean(tmpdatad,2);',tmpvarname));
    eval(sprintf('%s_bioall.TBstd=std(tmpdatad,[],2);',tmpvarname));

    eval(sprintf('tmpdata=mean(%s_bioall.fluxs,2); tmptt=%s_bioall.ts;',tmpvarname,tmpvarname));
    eval(sprintf('tmpbase=mean(%s_bioall.FLUXbase,2);',tmpvarname));
    tmpdata=tmpdata.*(ones(size(tmpdata,1),1)*tmpbase);
    tmpi0=find((tmptt>tmpiis(1))&(tmptt<tmpiis(2))); tmpi9=find((tmptt>tmpiis(3))&(tmptt<tmpiis(4)));
    tmpdatad=tcdetrend(tmpdata,1,[tmpi0(1) tmpi0(end) tmpi9(1) tmpi9(end)]);
    tmpdatad=tmpdatad./(ones(size(tmpdatad,1),1)*mean(tmpdatad(tmpi0,:),1));
    eval(sprintf('%s_bioall.fluxsavg=mean(tmpdatad,2);',tmpvarname));
    eval(sprintf('%s_bioall.fluxsstd=std(tmpdatad,[],2);',tmpvarname));

    eval(sprintf('tmpdata=mean(%s_bioall.tbs,2); tmptt=%s_bioall.ts;',tmpvarname,tmpvarname));
    eval(sprintf('tmpbase=mean(%s_bioall.TBbase,2);',tmpvarname));
    tmpdata=tmpdata.*(ones(size(tmpdata,1),1)*tmpbase);
    tmpi0=find((tmptt>tmpiis(1))&(tmptt<tmpiis(2))); tmpi9=find((tmptt>tmpiis(3))&(tmptt<tmpiis(4)));
    tmpdatad=tcdetrend(tmpdata,1,[tmpi0(1) tmpi0(end) tmpi9(1) tmpi9(end)]);
    tmpdatad=tmpdatad./(ones(size(tmpdatad,1),1)*mean(tmpdatad(tmpi0,:),1));
    eval(sprintf('%s_bioall.tbsavg=mean(tmpdatad,2);',tmpvarname));
    eval(sprintf('%s_bioall.tbsstd=std(tmpdatad,[],2);',tmpvarname));
  else,
    eval(sprintf('%s_bioall.FLUXavg=mean(%s_bioall.FLUX,2);',tmpvarname,tmpvarname));
    eval(sprintf('%s_bioall.FLUXstd=std(%s_bioall.FLUX,[],2);',tmpvarname,tmpvarname));
    eval(sprintf('%s_bioall.TBavg=mean(%s_bioall.TB,2);',tmpvarname,tmpvarname));
    eval(sprintf('%s_bioall.TBstd=std(%s_bioall.TB,[],2);',tmpvarname,tmpvarname));
    eval(sprintf('%s_bioall.fluxsavg=mean(%s_bioall.fluxs,2);',tmpvarname,tmpvarname));
    eval(sprintf('%s_bioall.fluxsstd=std(%s_bioall.fluxs,[],2);',tmpvarname,tmpvarname));
    eval(sprintf('%s_bioall.tbsavg=mean(%s_bioall.tbs,2);',tmpvarname,tmpvarname));
    eval(sprintf('%s_bioall.tbsstd=std(%s_bioall.tbs,[],2);',tmpvarname,tmpvarname));
  end;
end;

if do_save,
  clear tmp* mm nn ii
  save biopac_summ 
end;

