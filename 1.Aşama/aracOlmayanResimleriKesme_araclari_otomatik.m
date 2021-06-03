clc;
clear;

N=input('ka� b�lge keseceksin');
for kacDefaTekrarla=1:N%ka� defa kesilecek ise o kadar d�ng�ye gir
    
    
dosya_uzantisi='.jpg';%%% Baska uzant� var ise onlar� da eklemelisin 
muzik_klasoru = 'vehicleImages\';
muzik_klasoru_icerigi = dir ([muzik_klasoru,'*',dosya_uzantisi]);  %d�r komutu ile dosya i�eri�ini g�rebiliyoruz     
dosya_sayisi = size (muzik_klasoru_icerigi,1);  %Klas�rdeki dosya_sayisi kadar

[TestAdi TestYolu] = uigetfile ('*.jpg','Test Resmi Se�iniz');            % Test resmi se�. 
I=imread([TestYolu TestAdi]);
imshow(I);

x=ginput(2);%bir adet konum se� bir �rnek �zerinden 
x=int16(x);


for k=1:dosya_sayisi 
dosya_adi = [muzik_klasoru,muzik_klasoru_icerigi(k,1).name]; %Dosyay� ad�n� al
I = imread(dosya_adi);%Ald���n dosyay� oku
imshow(I)


for j=1:2:size(x,1)-1 %bu for ise yukarda se�ti�im tek �rnek koridinat�na g�re dosyan�n i�indeki t�m resimleri o kordinata g�re keser
    K=I(x(j,2):x(j+1,2),x(j,1):x(j+1,1),:);%K�rp�lan nesne
    K=imresize(K,[40 40]);% T�m k�rp�lan resimlerin boyutlar�n� e�it
    %lemek i�in resize
    ext='.png';
    name=num2str(kacDefaTekrarla+"--"+k);
    name=fullfile('c:','Users','Mehmet Akif YILMAZ','Desktop','derin ogrenme final proje','arac ba�ar�l� deneme','arac','2',strcat(name,ext));
    imwrite(K,name) 
    %Her k�rp�lan resmi sakla
end
end


end
