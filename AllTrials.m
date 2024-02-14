
darn=[]
dar=reshape(rr1([1:nimtr*ntr]+noff,:),[nimtr ntr size(rr1,2)]);
for mm=1:4, darn(:,:,mm)=dar(:,:,mm)./(ones(150,1)*squeeze(mean(dar(1:25,:,mm),1))); end;


%figure; plot(dar(:,:,1))

spacing = 1;
figure;
hold on
yshift=0;
wROI=1;
for iii = 1:size(dar,2)
    plot(tt,dar(:,iii,wROI)+yshift)
    yshift=yshift+spacing;
end
plot(tt,rr1a(:,wROI)-spacing,'k','Linewidth',3)

%figure; plot(dar(:,:,1))

%% my additions
yproj2max_darn=[];
yproj2max_dar=reshape(yproj2max([1:nimtr*ntr]+noff,:),[nimtr ntr size(yproj2max,2)]); 
for mm=1:3, yproj2max_darn(:,:,mm)=yproj2max_dar(:,:,mm)./(ones(150,1)*squeeze(mean(yproj2max_dar(1:25,:,mm),1))); end;

%yproj2max_a=squeeze(mean(reshape(yproj2max([1:nimtr*ntr]+noff,:),[nimtr ntr size(yproj2max,2)]),2)); 
%yproj2max_an=yproj2max_a./(ones(size(yproj2max_a,1),1)*mean(yproj2max_a(1:nbase,:),1));

spacing = 1;
figure;
hold on
yshift=0;
wROI=1;
for iii = 1:size(yproj2max_dar,2)
    plot(tt,yproj2max_dar(:,iii,wROI)+yshift)
    yshift=yshift+spacing;
end
plot(tt,yproj2max_a(:,wROI)-spacing,'k','Linewidth',3)



dar=reshape(rr1([1:nimtr*ntr]+noff,:),[nimtr ntr size(rr1,2)]);

%figure; plot(dar(:,:,1))

spacing = 2;
figure;
hold on
yshift=0;
wROI=1;
for iii = 1:size(dar,2)
    plot(tt,dar(:,iii,wROI)+yshift)
    yshift=yshift+spacing;
end
plot(tt,rr1a(:,wROI)-spacing,'k','Linewidth',3)