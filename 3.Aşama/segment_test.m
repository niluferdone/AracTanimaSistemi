clear;
clc;

load segment_network
[TestAdi TestYolu] = uigetfile ('*.jpg','Test Resmi Seçiniz'); 
A=imread([TestYolu TestAdi]);
resim=A;
C = semanticseg(A,network);  %Test görüntüsünü segmentlere ayýrma
B = labeloverlay(A,C);
imshow(B);