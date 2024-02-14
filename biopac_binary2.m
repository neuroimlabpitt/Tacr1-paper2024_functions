function biopac_binary2(fname)
% Usage biopac_binary2(fname)

% biopac_binary.m 
% 
% #AS156 - AcqKnowledge File Format for Windows/PC Updated Updated 060805 
% http://www.biopac.com/AppNotes/app156FileFormat/FileFormat.htm 
%  
% Simple m-file for loading samples of named channels from AcqKnowledge ACQ files.  
% Jesper G Ansson 
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=4989&objectType=file 
%  
% MatLab R13 
% 2006.07.04 Modified by Hiro 
% 2006.07.05 minor changes 
 
 
 
%filename = ''; 
%if(length(filename) == 0) 
%   [fname, pathname] = uigetfile('*.ACQ', 'Select a BioPac file'); 
%	i_filename = strcat(pathname, fname); 
%end 
% 
disp(sprintf('  Filename= %s',fname)); 
 
fid = fopen(fname, 'r','l'); 
if(fid == -1) 
   disp('cannot open file'); 
   return 
end 
 
% short = int16 
% long = int32 
% double = double 
 
% ### Graph header section ### 
nItemHeaderLen = fread(fid, 1, 'int16');    % Not currently used 
% 39 = version of Acq 3.7.3 or above (Win 98, 98SE, 2000, Me, XP) 
lVersion = fread(fid, 1, 'int32');           % File version identifier 
if lVersion == 38 
    fprintf('  Version of Acq 3.7.0-3.7.2 (Win 98, 98SE, NT, Me, 2000)\n'); 
elseif lVersion == 39 
    fprintf('  Version of Acq 3.7.3 or above (Win 98, 98SE, 2000, Me, XP)\n'); 
else 
    fprintf('This program will not work properly!\n'); 
    return; 
end 
        
lExtItemHeaderLen = fread(fid, 1, 'int32');  % Extended item header length 
nChannels = fread(fid, 1, 'int16');          % Number of channels stored 
nHorizAxisType = fread(fid, 1, 'int16');     % Horizontal scale type, one of the  following; 0 = Time in seconds, 1 = Time in HMS format, 2 = Frequency, 3 = Arbitray 
fseek(fid, 16, 'bof'); 
dSampleTime = fread(fid, 1, 'double');        % The number of milliseconds per sample 

disp(sprintf('  # Channels= %d',nChannels));
disp(sprintf('  Sample Time= %f',dSampleTime));
 
% ### Per Channel Data Section ### 
sectionstart = lExtItemHeaderLen;             
fseek(fid, sectionstart, 'bof'); 
lChanHeaderLen = fread(fid, 1, 'int32');     % Length of channel header. 
if lVersion == 38 
    fseek(fid, sectionstart+88, 'bof');      % I think this is correct 
elseif lVersion == 39 
    fseek(fid, sectionstart+88, 'bof'); 
else 
    fprintf('This program will not work properly!\n'); 
end 
 
lBufLength = fread(fid, 1, 'int32');         % Number of data samples 
for i=1:nChannels 
    sectionstart = lExtItemHeaderLen + (i-1)*lChanHeaderLen; 
    fseek(fid, sectionstart+4, 'bof');        
    nNum(i) = fread(fid, 1, 'int16');               % Channel number 
    szCommentText(i,1:40) = fscanf(fid, '%40c', 1); % Channel label 
    fseek(fid, sectionstart+68, 'bof'); 
    szUnitsText(i,1:20) = fscanf(fid, '%20c', 1);   % Units text 
    fseek(fid, sectionstart+92, 'bof'); 
    dAmplScale(i) = fread(fid, 1, 'double');        % Units/count 
    dAmplOffset(i) = fread(fid, 1, 'double');       % Units 
end 
 
% ### Foreign Data Section ### 
fseek(fid, lExtItemHeaderLen+lChanHeaderLen*nChannels, 'bof'); 
nLength = fread(fid, 1, 'int16');    % Total length of foreign data packet. 
 
% ### Per Channel Data Types Section ### 
% This block is repeated for as many channels that were detected in the graph header packet nChannels field. 
sectionstart = lExtItemHeaderLen + lChanHeaderLen*nChannels + nLength; 
fseek(fid, sectionstart, 'bof'); 
for i=1:nChannels 
    nSize(i) = fread(fid, 1, 'int16'); 
    nType(i) = fread(fid, 1, 'int16'); 
end 
choffset = cumsum([0 nSize(1:end-1)]);  % Interleave offset 
 
% ### Channel Data Section ### 
% The individual channel data is stored after the Per Channel Data Types Section.  
% The channel data is in an interleaved format. 
% Read samples, one channel at a time. 
fprintf('\n%s\n\n', 'Reading data... ' ); 
 
chindex = 1:nChannels; 
 
sectionstart = lExtItemHeaderLen + lChanHeaderLen*nChannels + nLength + 4*nChannels; 
fseek(fid, sectionstart, 'bof'); 
blocksize = sum(nSize); 
for k=1:nChannels, 
    fseek(fid, sectionstart + choffset(chindex(k)), 'bof'); 
    switch nType(chindex(k)) 
        case 1  % double 
            varargout(k) = {fread(fid, lBufLength, 'double', blocksize-8)}; 
        case 2  % int 
            varargout(k)= {dAmplScale(chindex(k)) * fread(fid, lBufLength, 'int16', blocksize-2) + ...  
                                    dAmplOffset(chindex(k))}; 
    end 
end 
fclose(fid); 

for mm=1:nChannels,
  if (mm==1),
    fnString=sprintf('fn={''%s''',str2varname(szCommentText(mm,:)));
    fnString2=sprintf('chVarName=str2mat(''%s''',str2varname(szCommentText(mm,:)));
  elseif (mm==nChannels),
    fnString=sprintf('%s,''%s''};',fnString,str2varname(szCommentText(mm,:)));
    fnString2=sprintf('%s,''%s'');',fnString2,str2varname(szCommentText(mm,:)));
  else,
    fnString=sprintf('%s,''%s''',fnString,str2varname(szCommentText(mm,:)));
    fnString2=sprintf('%s,''%s''',fnString2,str2varname(szCommentText(mm,:)));
  end;
end;
eval(fnString);
eval(fnString2);

if (strcmp(fname(end-3:end),'.ACQ')|strcmp(fname(end-3:end),'.acq')),
  fname2=fname(1:end-4);
else,
  fname2=fname;
end;

%keyboard,

chUnitsText=szUnitsText;
chAmplOffset=dAmplOffset;
chAmplScale=dAmplScale;
chSampleTime=dSampleTime;
for mm=1:length(fn),
  tmp1=fn{mm};
  for nn=1:length(fn),
    if (mm~=nn),
      if strcmp(tmp1,fn{nn}),
        fn{nn}=sprintf('%s_%02d',fn{nn},nn);
      end;
    end;
  end;
end;
% check var names prior to converting
for mm=1:length(fn),
  if ~isempty(str2num(fn{mm}(1))),
    if length(fn{mm})>1,
      if ~isempty(str2num(fn{mm}(2))),
        tmpnew=sprintf('Ch_%s',fn{mm});
      else,
        tmpnew=fn{mm}(2:end);
      end;
    else,
      tmpnew=sprintf('Ch_%s',fn{mm});
    end;
    disp(sprintf('  replacing channel name from %s to %s',fn{mm},tmpnew));
    fn{mm}=tmpnew;
    tmpnew2=char(zeros(1,size(chVarName,2)));
    tmpnew2(1:length(tmpnew))=tmpnew;
    chVarName(mm,:)=tmpnew2;
    clear tmpnew tmpnew2
  end;
end;    
biopacData=cell2struct(varargout,fn,2);

disp(sprintf('Saving data to %s',fname2));

eval(sprintf('save %s biopacData chVarName nChannels chUnitsText chSampleTime chAmplOffset chAmplScale fname ',fname2));

clear all
return

