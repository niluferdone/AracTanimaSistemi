% unzip vehicleDatasetImages.zip
% data = load('vehicleDatasetGroundTruth.mat');
% vehicleDataset = data.vehicleDataset;
clear
clc
load veriSeti.mat

i=1;
for j=1:295
I=vehicleDataset{j,1};
veriSetiIsim=I;
Bolge=cell2mat(vehicleDataset{j,2});
[sat,sut]=size(Bolge);

I=imread(cell2mat(I));
for k=1:sat
    BolgeDeg=Bolge(k,:);
%I=imread(cell2mat(I));
rows=BolgeDeg(1):BolgeDeg(1)+BolgeDeg(3);
cols=BolgeDeg(2):BolgeDeg(2)+BolgeDeg(4);
I(cols,rows,:)=0;

 ext='.png';
    name=num2str("image_0000"+i+"--"+k);%1 yerine i olmalý
    name=fullfile('c:','Users','Mehmet Akif YILMAZ','Desktop','segment','road_line','egitim','segmentlenmis',strcat(name,ext));
    imwrite(I,name) 
    
imshow(I)

end
i=i+1;
end
    