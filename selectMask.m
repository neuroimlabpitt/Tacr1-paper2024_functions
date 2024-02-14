function [y,ys]=selectMask(im,pos_flag)
% Usage ... [y,ys]=selectMask(im,pos_flag)

if nargin==1, pos_flag=1; end;
if pos_flag<=0, pos_flag=0; end;

y=ones(size(im));
mask=ones(size(im));
im1=im;

smw=[];
thr=[];
hcf=[];

tmpok=0;
while(~tmpok),
  clf,
  subplot(121), show(im1),
  subplot(122), show(y),
  tmpin=input('  enter [s=smooth, t=thr, f=flat, d/D=draw, i=invert, L=label, r=reset, enter=accept]: ','s');
  if ~isempty(tmpin),
    if strcmp(tmpin,'d'),
      subplot(121), 
      mask=mask&roipoly;
      y=y&mask;
    elseif strcmp(tmpin,'D'),
      subplot(121), 
      if sum(mask(:)==0)<1, mask=roipoly; else, mask=mask|roipoly; end;
      y=mask;
    elseif strcmp(tmpin,'i'),
      y=(~y);
    elseif strcmp(tmpin,'r'),
      im1=im;
      y=ones(size(im));
    elseif strcmp(tmpin,'R'),
      y=bwlabel(y);
    elseif strcmp(tmpin,'L'),
      im1=im;
      mask=ones(size(im));
      y=ones(size(im));
    elseif length(tmpin)>1,
      if strcmp(tmpin(1),'t'),
        thr=str2double(tmpin(2:end));
        y=mask&(im1>thr); 
      elseif strcmp(tmpin(1),'s'),
        smw=str2double(tmpin(2:end));
        im1=im_smooth(im1,smw);
      elseif strcmp(tmpin(1),'f')|strcmp(tmpin(1),'h'),
        hcf=str2double(tmpin(2:end));
        im1=homocorOIS(im1,hcf);
      elseif strcmp(tmpin(1),'p'),
        ppe=str2double(tmpin(2:end));
        im1=im1.^ppe; im1=im1/max(im1(:));
      end;
    else,
      tmpin2=input(['  enter ',tmpin,' value= ']);
      if (~isstr(tmpin2))&strcmp(tmpin,'s'),
        smw=tmpin2;
        im1=im_smooth(im,smw);
      elseif (~isstr(tmpin2))&strcmp(tmpin,'c'),
        ct=tmpin2;
        tmpmask=bwlabel(y);
        if length(ct)==1,
          for nn=1:max(tmpmask(:)), tmpii=find(tmpmask==nn); if length(tmpii)<ct, tmpmask(tmpii)=0; end; end;
        else,
          for nn=1:max(tmpmask(:)), tmpii=find(tmpmask==nn); if (length(tmpii)<ct(1))|(length(tmpii)>ct(2)), tmpmask(tmpii)=0; end; end;
        end;
        tmpmask=tmpmask>0;
        y=tmpmask;
      elseif (~isstr(tmpin2))&strcmp(tmpin,'t'),
        thr=tmpin2;
        if pos_flag, y=mask&(im1>thr); else, y=mask&(im1<thr); end;
      elseif (~isstr(tmpin2))&(strcmp(tmpin,'f')|strcmp(tmpin,'h')),
        hcf=tmpin2;
        im1=homocorOIS(im1,hcf);
      elseif (~isstr(tmpin2))&strcmp(tmpin,'p'),
        ppe=tmpin2;
        im1=im1.^ppe; im1=im1/max(im1(:));
      end;
    end;
  else,
    tmpok=1;
  end;
end;

if nargout==2,
  ys.im=im;
  ys.pos_flag=pos_flag;
  ys.thr=thr;
  ys.smw=smw;
  ys.hcf=hcf;
  ys.im1=im1;
  ys.mask=y;
end;

