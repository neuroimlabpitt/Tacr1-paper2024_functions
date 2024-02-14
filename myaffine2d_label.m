function y=myaffine2d_label(im1,xx,imsize,mask)
% Usage ... y=myaffine2d_label(labelim1,[x0,y0,r0,sx0,sy0],imresize)
%
% Uses translation, rotation and scaling of im1 
% if im2 is included in imresize then im1 is rescaled to match im2 first

athr=0.7;
for mm=1:max(im1(:)),
  tmpim1=double(im1==mm);
  tmpim2=myaffine2d_f(tmpim1,xx,imsize);
  if mm==1, tmpim5=zeros(size(tmpim2)); end;
  tmpim5(find(tmpim2>athr))=mm;
end;
y=tmpim5;

if nargout==0,
  clf,
  subplot(121), show(im1), xlabel('Original'),
  subplot(122), show(y), xlabel('Final'),
  clear
end;


