
clear all
close all

do_save=1;
bioroot='MOUSE_NOSK15_7_20170818';


bparms1=[-2000 18000];
bparms2=[-5000 62000];
bparms4=[-5000 42000];

sparms1=[200 20];	% 5Hz 4s
sparms12=[200 40];	% 5Hz 8s
sparms2=[100 40];	% 10Hz 4s
sparms22=[100 80];	% 10Hz 8s
sparms4=[50 80];	% 20Hz 4s
sparms42=[50 160];	% 20Hz 8s

skpi=[4:62];
skp1=skpi-bparms1(1);  for mm=2:sparms1(2),  skp1=[skp1 skpi+(mm-1)*sparms1(1)-bparms1(1)]; end;
skp12=skpi-bparms1(1); for mm=2:sparms12(2), skp12=[skp12 skpi+(mm-1)*sparms12(1)-bparms1(1)]; end;
skp2=skpi-bparms2(1);  for mm=2:sparms2(2),  skp2=[skp2 skpi+(mm-1)*sparms2(1)-bparms2(1)]; end;
skp22=skpi-bparms2(1); for mm=2:sparms22(2), skp22=[skp22 skpi+(mm-1)*sparms22(1)-bparms2(1)]; end;
skp4=skpi-bparms4(1);  for mm=2:sparms4(2),  skp4=[skp4 skpi+(mm-1)*sparms4(1)-bparms4(1)]; end;
skp42=skpi-bparms4(1); for mm=2:sparms42(2), skp42=[skp42 skpi+(mm-1)*sparms42(1)-bparms4(1)]; end;


biots=0.001;
imChName='FPS';
trigChName='StimON';

bioid={{'SETUP','dyn1wh1',[1 10],bparms2,'skp1'},
       {'SETUP','dyn1l1p0b',[11 20],bparms2,'skp1'},
       {'SETUP','dyn1l1p0a',[21 30],bparms2,'skp1'},
       {'SETUP','dyn1l1p0c',[31 40],bparms2,'skp1'},
       {'SETUP','dyn2l1p0b',[41 60],bparms2,'skp2'},
       {'SETUP','dyn4l1p0b',[51 60],bparms2,'skp4'},
       {'SETUP','dyn8l1p0b',[61 70],bparms2,'skp4'},
       {'SETUP','dyn1wh1S',[71 80],bparms4,'skp1'},
       {'SETUP','dyn1l1p0bS',[81 90],bparms4,'skp1'},
       {'SETUP','dyn1l1p0aS',[91 100],bparms4,'skp1'},
       {'SETUP','dyn1l1p0cS',[101 110],bparms4,'skp1'},
       {'SETUP','dyn2l1p0bS',[111 120],bparms4,'skp1'},
       {'SETUP','dyn4l1p0bS',[121 130],bparms4,'skp1'},
       {'SETUP','dyn8l1p0bS',[131 140],bparms4,'skp1'},
       {'SETUP','dyn1wh1L',[141 150],bparms2,'skp1'},
       {'SETUP','dyn1l1p0bL',[151 160],bparms2,'skp1'}};


if do_save,
  save biopac_data bioroot bioid biots imChName bparms* sparms* skp*
end;

for mm=1:length(bioid),
  disp(sprintf('%s=parseBiopac(''%s_%s'',''StimON'',[%d:%d],[%d %d]);',bioid{mm}{2},bioroot,bioid{mm}{1},bioid{mm}{3}(1),bioid{mm}{3}(2),bioid{mm}{4}(1),bioid{mm}{4}(2)));
  eval(sprintf('%s=parseBiopac(''%s_%s'',''StimON'',[%d:%d],[%d %d]);',bioid{mm}{2},bioroot,bioid{mm}{1},bioid{mm}{3}(1),bioid{mm}{3}(2),bioid{mm}{4}(1),bioid{mm}{4}(2)));
  disp(sprintf('save biopac_data -append %s',bioid{mm}{2}));
  eval(sprintf('save biopac_data -append %s',bioid{mm}{2}));
  disp(sprintf('%s_new=processBiopacStruc2(%s,[1/biots 100 0.1],4,[-4 -1],[[-4 -1] [-6 -3]+%d*biots],[],[],[],%s);',bioid{mm}{2},bioid{mm}{2},bioid{mm}{4}(2),bioid{mm}{5}));
  eval(sprintf('%s_new=processBiopacStruc2(%s,[1/biots 100 0.1],4,[-4 -1],[[-4 -1] [-6 -3]+%d*biots],[],[],[],%s);',bioid{mm}{2},bioid{mm}{2},bioid{mm}{4}(2),bioid{mm}{5}));
  disp(sprintf('save biopac_data -append %s_new',bioid{mm}{2}));
  eval(sprintf('save biopac_data -append %s_new',bioid{mm}{2}));
end;

