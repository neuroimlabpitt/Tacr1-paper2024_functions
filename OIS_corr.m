function [f,meanimt,meanim,meanref]=OIS_corr(fname,reference,section,meanim)
% Usage ... f=OIS_corr(OISfname,reference,section)
%
% reference - reference waveform for correlation
% section- sections of the timecourse to regress only in images!
% sections can be the image #s to use, in that case reference should
% be of the same length as sections

% Image-course approach


if (nargin<4),
  calc_meanim=1;
else,
  calc_meanim=0;
end;

if nargin<3,
  [tmphdr,tmpim,tmphdr]=readOIS(fname);
  section=tmphdr.nfr;
end;

sumim=0;
sumref=0;
count=0;
sumnx=0; sumny=0; sumnxy=0; sumnx2=0; sumny2=0;

%t=clock;
%disp(['Time:']);
%disp(t);
disp(['Initiating Analysis...']);

if length(section)>=3,
  disp('Doing sections (images)...');
  if (calc_meanim),
    for m=1:length(section),
      im=getOISim(fname,section(m));
      sumim=sumim+im;
      sumref=sumref+reference(m);
      count=count+1;
      meanimt(m)=sum(sum(im));
    end;
    meanim=(1/count)*sumim;  %image
    meanref=(1/count)*sumref; %value
    meanimt=meanimt/prod(size(im));
  else,
    meanref=mean(reference(section));
    meanimt=0;
  end;
  count=1;
  for m=1:length(section),
    im=getOISim(fname,section(m));
    sumnx2=sumnx2+(reference(m)-meanref).*(reference(m)-meanref);
    sumny2=sumny2+(im-meanim).*(im-meanim);
    sumnxy=sumnxy+(reference(m)-meanref)*(im-meanim);
    count=count+1;
  end;
elseif length(section)==2,
  disp(['Doing sections...']);
  nsections=length(section)/2;
  if (calc_meanim),
    for k=1:nsections,
      for m=section(2*k-1):section(2*k),
        im=getOISim(fname,m);
        sumim=sumim+im;
        sumref=sumref+reference(m);
        count=count+1;
        meanimt(m)=sum(sum(im));
      end;
    end;
    meanim=(1/count)*sumim;  %image
    meanref=(1/count)*sumref; %value
    meanimt=meanimt/prod(size(im));
  else,
    meanref=mean(reference);
    meanimt=0;
  end;
  count=1;
  for k=1:nsections,
    disp(['Section ',int2str(k)]);
    for m=section(2*k-1):section(2*k),
      im=getOISim(fname,m);
      sumnx2=sumnx2+(reference(m)-meanref).*(reference(m)-meanref);
      sumny2=sumny2+(im-meanim).*(im-meanim);
      sumnxy=sumnxy+(reference(m)-meanref)*(im-meanim);
      count=count+1;
    end;
  end;
  disp(['Sections Done...']);
else,
  if length(section)==1, section(2)=section(1); section(1)=1; end;
  if (calc_meanim),
    for k=section(1):section(2),
      im=getOISim(fname,k);
      sumim=sumim+im;
      count=count+1;
      meanimt(k)=sum(sum(im));
    end;
    meanim=(1/count)*sumim;  %image
    meanref=mean(reference); %value
    meanimt=meanimt/prod(size(im));
  else,
    meanref=mean(reference(section(1):section(2)));
    meanimt=0;
  end;
  for k=section(1):section(2),
    im=getOISim(fname,k);
    sumnx2=sumnx2+(reference(k)-meanref).*(reference(k)-meanref);
    sumny2=sumny2+(im-meanim).*(im-meanim);
    sumnxy=sumnxy+(reference(k)-meanref)*(im-meanim);
  end;
end;

den=((sumnx2^(0.5))*(sumny2.^(0.5)));

for m=1:size(im,1), for n=1:size(im,2),
  if (den(m,n)==0)|(den(m,n)<1e-6),
    f(m,n)=0;
  else,
    f(m,n)=sumnxy(m,n)/den(m,n);
  end;  
end; end;

% convert r to t, just in case
%t=f*sqrt(count-1-2)/((1-f.*f).^0.5);

%disp(['Time: ']);
%disp(clock-t);
disp(['Done...']);

