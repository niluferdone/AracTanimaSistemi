clc;
clear;

N=input('kaç bölge keseceksin');
for kacDefaTekrarla=1:N%kaç defa kesilecek ise o kadar döngüye gir
    
    
dosya_uzantisi='.jpg';%%% Baska uzantý var ise onlarý da eklemelisin 
muzik_klasoru = 'vehicleImages\';
muzik_klasoru_icerigi = dir ([muzik_klasoru,'*',dosya_uzantisi]);  %dýr komutu ile dosya içeriðini görebiliyoruz     
dosya_sayisi = size (muzik_klasoru_icerigi,1);  %Klasördeki dosya_sayisi kadar

[TestAdi TestYolu] = uigetfile ('*.jpg','Test Resmi Seçiniz');            % Test resmi seç. 
I=imread([TestYolu TestAdi]);
imshow(I);

x=ginput(2);%bir adet konum seç bir örnek üzerinden 
x=int16(x);


for k=1:dosya_sayisi 
dosya_adi = [muzik_klasoru,muzik_klasoru_icerigi(k,1).name]; %Dosyayý adýný al
I = imread(dosya_adi);%Aldýðýn dosyayý oku
imshow(I)


for j=1:2:size(x,1)-1 %bu for ise yukarda seçtiðim tek örnek koridinatýna göre dosyanýn içindeki tüm resimleri o kordinata göre keser
    K=I(x(j,2):x(j+1,2),x(j,1):x(j+1,1),:);%Kýrpýlan nesne
    K=imresize(K,[40 40]);% Tüm kýrpýlan resimlerin boyutlarýný eþit
    %lemek için resize
    ext='.png';
    name=num2str(kacDefaTekrarla+"--"+k);
    name=fullfile('c:','Users','Mehmet Akif YILMAZ','Desktop','derin ogrenme final proje','arac baþarýlý deneme','arac','2',strcat(name,ext));
    imwrite(K,name) 
    %Her kýrpýlan resmi sakla
end
end


end
