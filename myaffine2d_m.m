function y=myaffine2d_m(im1,x0,y0,r0,sx0,sy0,type,imsize,mask)
% Usage ... y=myaffine2d_m(im1,x0,y0,r0,sx0,sy0,type,imsize,mask)


r0=r0*(pi/180);

[nx,ny,nz,nt]=size(im1);
[ii,jj,kk,ll]=ndgrid([1:nx],[1:ny],[1:nz],[1:nt]);

% rotation matrix
rmat=eye(4); 
rmat(1,1)=cos(zrot); 
rmat(2,2)=cos(zrot);
rmat(1,2)=-sin(zrot);
rmat(2,1)=sin(zrot);

% translation matrix
tmat=eye(4);
tmat(1,4)=x0;
tmat(2,4)=y0;

% scale matrix
smat=eye(4);
smat(1,1)=sx0;
smat(2,2)=sy0;

T=rmat*tmat*smat;

indmat=cat(1,reshape(ii,[1 nx*ny*nz*nt]),reshape(jj,[1 nx*ny*nz*nt]),reshape(kk,[1 nx*ny*nz*nt]),reshape(ll,[1 nx*ny*nz*nt]));
indmat=T*indmat;

xxi=reshape(indmat(1,:),[nx,ny,nz,nt]);
yyi=reshape(indmat(2,:),[nx,ny,nz,nt]);
zzi=reshape(indmat(3,:),[nx,ny,nz,nt]);

im1new=interp2(yy,xx,im1,yyi,xxi);

