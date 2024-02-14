function [h,c]=parsePrairieXML(dname,config_flag)
% Usage ... header=parsePrairieXLM(fname)
% Requires xml_io library
% Returns a simplified structure that serves as a header

do_ver=5;

if nargin<2, config_flag=0; end;
%disp(sprintf('  config_flag= %d',config_flag));

if ~(strcmp(dname(end-3:end),'.xml')|strcmp(dname(end-3:end),'.XML')),
  if strcmp(dname(end),'/'),
    fname=sprintf('%s/%s.xml',dname,dname(1:end-1));
    cname=sprintf('%s/%sConfig.cfg',dname,dname(1:end-1));
  else,
    fname=sprintf('%s/%s.xml',dname,dname);
    cname=sprintf('%s/%sConfig.cfg',dname,dname);
  end;
else,
  fname=dname;
  cname=sprintf('%sConfig.cfg',dname(1:end-3));
  %disp(sprintf(' config file= %s\n',cname));
end;

%disp(sprintf(' xml file= %s\n',fname));

a=xml_read(fname);

if do_ver==5,
  %h=a; return;
  h.date=a.ATTRIBUTE.date;
  % parse PVShard
  for mm=1:length(a.PVStateShard.PVStateValue),
    tmp=a.PVStateShard.PVStateValue(mm);
    if length(tmp.IndexedValue)==1,
      for nn=1:length(tmp.IndexedValue),
        eval(sprintf('h.PV_shared.%s=tmp.IndexedValue(nn).ATTRIBUTE.value;',tmp.ATTRIBUTE.key));
      end;
    elseif length(tmp.IndexedValue)>1,
      for nn=1:length(tmp.IndexedValue),
        eval(sprintf('h.PV_shared.%s{nn}=tmp.IndexedValue(nn).ATTRIBUTE.value;',tmp.ATTRIBUTE.key));
      end;
    else,
      if isfield(tmp.ATTRIBUTE,'value'),
        tmpval=tmp.ATTRIBUTE.value;
      else,
        tmpval=[];
      end;
      eval(sprintf('h.PV_shared.%s=tmpval;',tmp.ATTRIBUTE.key));
    end;
  end;
  % parse Frames Sequence
  frameItems={'laserPower','twophotonLaserPower'};
  frameSubItems={'positionCurrent'};
  for mm=1:length(a.Sequence.Frame), 
    for nn=1:length(a.Sequence.Frame(mm).File),
      h.Frame(mm).fname{nn}=a.Sequence.Frame(mm).File(nn).ATTRIBUTE;
    end;
    h.Frame(mm).absTime=a.Sequence.Frame(mm).ATTRIBUTE.absoluteTime;
    h.Frame(mm).relTime=a.Sequence.Frame(mm).ATTRIBUTE.relativeTime;
    if ~isempty(a.Sequence.Frame(mm).PVStateShard),
    for nn=1:length(a.Sequence.Frame(mm).PVStateShard.PVStateValue),
      tmp=a.Sequence.Frame(mm).PVStateShard.PVStateValue(nn);
      for oo=1:length(frameItems),
        if strcmp(frameItems{oo},tmp.ATTRIBUTE.key),
          tmpval=tmp.IndexedValue.ATTRIBUTE.value;
          eval(sprintf('h.Frame(mm).%s=tmpval;',frameItems{oo}));
        end;
      end;
      for oo=1:length(frameSubItems),
        if strcmp(frameSubItems{oo},tmp.ATTRIBUTE.key),
          for qq=1:length(tmp.SubindexedValues),
            tmpval=tmp.SubindexedValues(qq).SubindexedValue.ATTRIBUTE.value;
            eval(sprintf('h.Frame(mm).%s=tmpval;',tmp.SubindexedValues(qq).ATTRIBUTE.index));
          end;
        end;
      end;
    end;
    end;
  end;

  return;
end;

frameItems={'absoluteTime','relativeTime','index','label'};

% General
h.Date=a.ATTRIBUTE.date;
h.Notes=a.ATTRIBUTE.notes;
h.Ver=a.ATTRIBUTE.version;

% SystemConfiguration
for mm=1:length(a.SystemConfiguration.Lasers),
  h.System.Lasers.Laser(mm).index=a.SystemConfiguration.Lasers.Laser(mm).ATTRIBUTE.index;
  h.System.Lasers.Laser(mm).name=a.SystemConfiguration.Lasers.Laser(mm).ATTRIBUTE.name;
end;

% Sequence
h.nCycles=length(a.Sequence);
for cc=1:h.nCycles,
  h.Sequence(cc).Cycle=a.Sequence.ATTRIBUTE(cc).cycle;
  h.Sequence(cc).Type=a.Sequence.ATTRIBUTE(cc).type;
  for mm=1:length(a.Sequence(cc).Frame),
    for nn=1:length(a.Sequence(cc).Frame(mm).File),
      h.Sequence(cc).Frame(mm).File(nn).Channel=a.Sequence(cc).Frame(mm).File(nn).ATTRIBUTE.channel;
      h.Sequence(cc).Frame(mm).File(nn).Filename=a.Sequence(cc).Frame(mm).File(nn).ATTRIBUTE.filename;
    end;
    h.Sequence(cc).Frame(mm).absoluteTime=a.Sequence(cc).Frame(mm).ATTRIBUTE.absoluteTime;
    h.Sequence(cc).Frame(mm).relativeTime=a.Sequence(cc).Frame(mm).ATTRIBUTE.relativeTime;
    h.Sequence(cc).Frame(mm).index=a.Sequence(cc).Frame(mm).ATTRIBUTE.index;
    h.Sequence(cc).Frame(mm).label=a.Sequence(cc).Frame(mm).ATTRIBUTE.label;
    for nn=1:length(a.Sequence(cc).Frame(mm).PVStateShard.Key),
      eval(sprintf('h.Sequence(cc).Frame(mm).%s=a.Sequence(cc).Frame(mm).PVStateShard.Key(nn).ATTRIBUTE.value;',a.Sequence.Frame(mm).PVStateShard.Key(nn).ATTRIBUTE.key));
    end;
  end;
end;

if (config_flag),
  c=xml_read(cname);
else,
  c=[];
end;



