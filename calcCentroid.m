function [maskC2b,maskA2bcenter,maskA2sm,maskC2bedgedil]=calcCentroid(fname,magn,diam,iactim,diffthr)
% Usage ... [maskC,center,maskA,maskCdil]=calcCentroid(fname,magn,diam,iactim,diffthr)
%
% fname is the mat file processed using quickmap_scr
% magn is the microscope magnification
% diam is the width of the hotspot area to calculate (in micro-meters)
% iactim is the image numbers that correspond to the desired activation

if (nargin<5), diffthr=0.25; end;

eval(sprintf('load %s',fname));

actim=mean(avgim(:,:,iactim),3);
actim=actim-mean(mean(actim));
actim_std=std(reshape(actim,prod(size(actim)),1));

microm_per_pix=9;
magnification=magn;
maskCdiameter_microm=diam;

smwid=4;

maskCrad=0.5*maskCdiameter_microm*magnification/microm_per_pix;

%f.actim_std=actim_std;
%f.microm_per_pix=microm_per_pix;
%f.magnification=magnification;
%f.sm_width=smwid;
%f.diameter_microm=maskCdiameter_microm;
%f.radius_pix=maskCrad;

%wlev=[400 800];
%dcim_wl=imwlevel(dcim,wlev);
%
%edge_sig=1;
%[edgeim,edge_thr]=edge(dcim_wl,'canny');
%%edge_thr=0.15;
%[edgeim,edge_thr]=edge(dcim_wl,'canny',edge_thr,edge_sig);
%
%maskA=im_thr(-corr620_dip,0.5,1);
%maskAsm=real(im_smooth(maskA,2));
%maskAcenter=mycentroid(maskAsm>0.5);
%maskAbcenter=mycentroid((maskAsm>0.5).*(maskAsm-0.5));
%maskC=ellipse(zeros(size(dcim)),maskAcenter(1),maskAcenter(2),maskCrad,maskCrad,0,1);
%maskCb=ellipse(zeros(size(dcim)),maskAbcenter(1),maskAbcenter(2),maskCrad,maskCrad,0,1);
%maskCedge=edge(maskC,'canny');
%maskCedgedil=imdilate(maskCedge,ones(4,4));
%maskCbedge=edge(maskCb,'canny');
%maskCbedgedil=imdilate(maskCbedge,ones(4,4));

maskA2=im_thr(-actim,1.5*actim_std,1);
maskA2sm=real(im_smooth(maskA2,smwid));
maskA2center=mycentroid(maskA2sm>diffthr);
maskA2bcenter=mycentroid((maskA2sm>diffthr).*(maskA2sm-diffthr));
maskC2=ellipse(zeros(size(dcim)),maskA2center(1),maskA2center(2),maskCrad,maskCrad,0,1);
maskC2b=ellipse(zeros(size(dcim)),maskA2bcenter(1),maskA2bcenter(2),maskCrad,maskCrad,0,1);
maskC2edge=edge(maskC2,'canny');
maskC2bedge=edge(maskC2b,'canny');
maskC2edgedil=imdilate(maskC2edge,ones(4,4));
maskC2bedgedil=imdilate(maskC2bedge,ones(4,4));

%f.maskAsm=maskA2sm;
%f.maskAthr=1.5*actim_std;
%f.diffthr=diffthr;
%f.center=maskA2bcenter;
%f.maskC=maskC2b;
%f.maskCedge=maskC2bedgedil;

if (nargout==0),

%
%subplot(321)
%show(im_super(dcim,maskCbedgedil+maskC2bedgedil,0.5))
%
%subplot(322)
%show(edgeim)
%
%subplot(323)
%show(maskA)
%
%subplot(324)
%show(im_super(maskAsm,maskCedgedil|maskCbedgedil,1))
%
%subplot(325)
%show(maskA2)
%
%subplot(326)
%show(im_super(maskA2sm,maskC2edgedil|maskC2bedgedil,1))
%

%subplot(221)
%show(im_super(dcim_wl,maskCC,-min(min(dcim_wl))/max(max(dcim_wl)))
%subplot(222)
%show(im_super(actim_wl,maskCC,0.75*max(max(actim_wl))))
%subplot(224)
%show(maskA2sm>diffthr),
%subplot(223)
%for mm=1:size(avgim,3), acttc(mm)=sum(sum(avgim(:,:,mm).*(maskA2sm>diffthr))); end;
%acttc=acttc/sum(sum(maskA2sm>diffthr));
%plot(acttc)

end;

