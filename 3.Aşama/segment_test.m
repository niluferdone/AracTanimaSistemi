clear;
clc;

load segment_network
[TestAdi TestYolu] = uigetfile ('*.jpg','Test Resmi Se�iniz'); 
A=imread([TestYolu TestAdi]);
resim=A;
C = semanticseg(A,network);  %Test g�r�nt�s�n� segmentlere ay�rma
B = labeloverlay(A,C);
imshow(B);