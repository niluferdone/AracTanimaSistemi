clear;
clc;
%resmi alarak segmentliuyor
load segment_network
[TestAdi TestYolu] = uigetfile ('*.jpg','Test Resmi Se�iniz'); 
A=imread([TestYolu TestAdi]);
 A=imresize(A,[144 144]);
resim=A;
C = semanticseg(A,network);  %Test g�r�nt�s�n� segmentlere ay�rma
B = labeloverlay(A,C);
%imshow(B);



%------------------------------------------------------------

%segmentlenen resmi bw ye �evirir

for i=1:144
    for j=1:144
        
        if C(i,j)=="arka_plan"
            A(i,j,:)=0;
        else
            A(i,j,:)=255;
        end
    end
end

b=rgb2gray(A);
e=graythresh(A);
c=im2bw(A,e);
f = c;
t = strel('square',41);
f = imopen(f,t);
%figure, imshow(f)
bas=1;
kareBas=[];
for i=1:144
    for j=1:144
        if ((f(i,j)==1)&&(bas==1)) 
            kareBas=[i,j];
            bas=0;
        end
    end
end

bas=1;
kareSon=[];
for i=144:-1:1
    for j=144:-1:1
        if ((f(i,j)==1)&&(bas==1)) 
            kareSon=[i,j];
            bas=0;
        end
    end
end

x=[kareBas; kareSon];

  i=1;
for j=1:2:size(x,1)-1
    K=resim(x(j,2):x(j+1,2),x(j,1):x(j+1,1),:);%K�rp�lan nesne
    K=imresize(K,[40 40]);% T�m k�rp�lan resimlerin boyutlar�n� e�it
    %lemek i�in resize
   % ext='.png';
   % name=num2str(i);
   % name=fullfile(strcat(name,ext));
   % imwrite(K,name) 
    i=i+1;
    %Her k�rp�lan resmi sakla
end

%-------------------------------------------------------------
%cnn test
load maynet% �nceen e�itilen a�� y�kl�yoruz.
%[TestAdi TestYolu] = uigetfile ('*.png','Test Resmi Se�iniz'); 
% Test resmi se�. 
%A=imread([TestYolu TestAdi]);
[Pred scores] = classify(mynet,K);% Burda a�� test ediyor

sonuc=scores(1,2);
sonuc=uint8(sonuc);
if sonuc==1
    ustCerceve=-1*(kareBas(1,2)-kareSon(1,2));
for i=0:ustCerceve
    resim(kareBas(1,1),kareBas(1,2)+i,:)=255;
    resim(kareSon(1,1),kareSon(1,2)-i,:)=255;
end

yancerc=-1*(kareBas(1,1)-kareSon(1,1));
for j=0:yancerc
    resim(kareBas(1,1)+j,kareBas(1,2),:)=255;
    resim(kareSon(1,1)-j,kareSon(1,2),:)=255;
end
rrr=imresize(resim,[224 330]);
imshow(rrr);
end

