function yy=positionMask2d_wrap(mainParms,subParms,mainIm)
% Usage ... yy=positionMask2d_wrap(mainParms,subParms,mainIm)
%
% mainParms = [FOVx FOVy x0 y0]
% subParms = [nx ny FOVx's FOVy's x0's y0's]

if isstruct(mainParms),
  if nargin==2, nref=subParms; tmpxy0=[0 0]; end;
  if nargin==3, nref=subParms; tmpxy0=mainIm; end;
  tmpstruct=mainParms;
  clear mainParms subParms
  mainIm=tmpstruct.mainIm;
  mainParms=tmpstruct.mainParms;
  if length(mainParms)==2, mainParms(3:4)=tmpxy0; end;
  for nn=1:length(tmpstruct.subIm),
    subParms(nn,:)=[size(tmpstruct.subIm{nn}) tmpstruct.subParms(nn,:) tmpstruct.subPos_info(nn,:)];
  end;
end; 
    
nsub=size(subParms,1);
nmain=length(mainParms);

if length(nmain)==4,
  tmp_mainParms=[size(mainIm) mainParms];
else,
  tmp_mainParms=[size(mainIm) mainParms 0 0];
end;

yy.mainIm=mainIm;
yy.mainParms=tmp_mainParms;

for nn=1:nsub,
  tmp_subParms=subParms(nn,:);
  tmp_subParms(5:6)=[1 -1].*(tmp_subParms(5:6)-subParms(nref,5:6));
  [tmpmsk,tmpim]=positionMask2d(tmp_mainParms,tmp_subParms,mainIm);
  yy.subParms(nn,:)=tmp_subParms;
  yy.mask(:,:,nn)=tmpmsk;
  %tmp_subParms=[yy.size(subIm{nn}) yy.subParms(nn,:) [1 -1].*(yy.subPos_info(nn,:)-yy.subPos_info(nref,:))]);
  %[tmpmsk,tmpim]=positionMask2d([346 464 yy.mainParms -400 -800],[ones(1,2)*512 yy.subParms(1,:) [1 -1].*(yy.subPos_info(nn,:)-yy.subPos_info(4,:))],yy.mainIm);
  if nargout==0,
    figure(1), clf, show(im_super(yy.mainIm,tmpmsk,0.5))
    if exist('tmpstruct','var'), figure(2), clf, subplot(121), show(tmpstruct.subIm{nn}), subplot(122), show(tmpim), end;
    drawnow,
    pause,
  end;
end;
