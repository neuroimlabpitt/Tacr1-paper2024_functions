function [f,qm,im,info1,info2,info3,ind]=readraw(pfilename,frm,fastrecflag)
% Usage ... [f,qm,im,info1,info2,info3]=fidread(pfilename,frame#,fastrecflag)
%

% P file is organized as follows:
%  coil 1:
%  slice 1: baseline interleaves time1, interleaves time 2, etc...
%  slice 2: baseline interleaves time1, interleaves time 2, etc...
%  etc...
%  coil 2: same as above but some random skip between them
%  if #leaves and #points is odd then there is an extra baseline at end

%  
%  Slice 1 Frame 0 is baseline (example, expect more)
%  Note: there is frame 0 but not slice 0!
%
%  For sf3d - slc is the phase encode of interest and frm
%  would be the spiral shot of interest (0 is the baseline).
%
%  nslices=info1(3);
%  nechoes=info1(4);
%  nexcitations=info1(5);
%  nframes=info1(6);
%  framesize=info1(9);
%  psize=info1(10);


RAWHEADERSIZE=39984;
%RAWHEADERSIZE=39984;
%RAWHEADERSIZE=40080;

HEADERSIZE=39940;
RDBRAWHEADEROFFSET=30;  % For version > 5.4 use 30.
LOC1 = RDBRAWHEADEROFFSET + 34;
LOC2 = RDBRAWHEADEROFFSET + 70;
LOC3 = RDBRAWHEADEROFFSET + 186;
%OPXRESLOC = 74;
%OPYRESLOC = 76;
%NFRAMESLOC = 46;
%NSLICES = 
%FRAMESIZELOC = 52;
%POINTSIZELOC = 54;

if isstr(pfilename),
  fid=fopen(pfilename,'r','b');
  if (fid<3), disp(['Could not open file! ...']); end;
else
  fid=pfilename;
end;


status=fseek(fid,LOC1,'bof');
if (status), disp(['Could not seek to file location 1! ...']); end;
info1=fread(fid,10,'short');
status=fseek(fid,LOC2,'bof');
if (status), disp(['Could not seek to file location 2! ...']); end;
info2=fread(fid,6,'short');
status=fseek(fid,LOC3,'bof');
if (status), disp(['Could not seek to file location 3! ...']); end;
info3=fread(fid,20,'float');

if (nargin==1),

  f=info1;
  qm=info2;
  im=info3;

else,

  nslices=info1(3);
  nechoes=info1(4);
  nexcitations=info1(5);
  nframes=info1(6);
  framesize=info1(9);
  psize=info1(10);

    fidloc = RAWHEADERSIZE + psize*2*framesize*frm;
    status=fseek(fid,fidloc,'bof');
    if (status), error(['Could not seek to file fid location! ...']); end;
    if (psize==4), str=['long']; else, str=['short']; end;
    ind=ftell(fid);
    out=fread(fid,2*framesize,str);
    for m=1:framesize,
      qm(m)=out(2*m-1);
      im(m)=out(2*m);
    end;
    qm=qm(:); im=im(:);
    f=qm+i*im;

end;

if isstr(pfilename),
  fclose(fid);
end;

if nargin<3, fastrecflag=1; end;
if (fastrecflag),
  th=2*pi*[1:framesize]'/4;
  f=f.*exp(-i*th);
  qm=qm.*cos(th);
  im=im.*sin(th);
end;

if (nargout==0),
  if (nargin==1),
    info1
    info2
    info3
  else,
    plot([1:length(qm)],qm,[1:length(im)],im)
  end;
end;

