
tmpvars={'do_crop','do_load','do_loadall','do_motc','do_realign',...
         'do_maskreg','do_intc','do_bin','do_binfirst','do_average',...
         'do_arfilt','do_ffilt','do_arfilt_apply','do_intc_apply',...
         'do_motc_apply','do_motcmask','do_detrend',...
         'do_timing','do_sequential','do_seqinterp'};

for mm=1:length(tmpvars),
  eval(sprintf('if exist(''%s'',''var''), flags.%s=%s; clear %s ; end;',tmpvars{mm},tmpvars{mm},tmpvars{mm},tmpvars{mm}));
end;

for mm=1:length(tmpvars),
  tmpvar2=tmpvars{mm}(4:end);
  eval(sprintf('if exist(''%s_parms'',''var''), flags.%s_parms=%s_parms; clear %s_parms ; end;',tmpvar2,tmpvar2,tmpvar2,tmpvar2));
end;

for mm=1:length(tmpvars),
  eval(sprintf('if exist(''%s_done'',''var''), flags.%s_done=%s_done; clear %s_done ; end;',tmpvars{mm},tmpvars{mm},tmpvars{mm},tmpvars{mm}));
end;

clear mm tmpvars tmpvar2

