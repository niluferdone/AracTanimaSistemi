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


asd=size(I);
resimSat=asd(1,1);
resSut=asd(1,2);
for str=1:resimSat
    for stn=1:resSut
       if I(str,stn,:)~=0
           I(str,stn,1)=0;
           I(str,stn,2)=0;
           I(str,stn,3)=255; 
           
       end
    end
end


 ext='.png';
    name=num2str("image_0000"+i+"--"+k);%1 yerine i olmalý
    name=fullfile('c:','Users','Mehmet Akif YILMAZ','Desktop','araka','hjkl',strcat(name,ext));
    imwrite(I,name) 
    
imshow(I)

end
i=i+1;
end
    