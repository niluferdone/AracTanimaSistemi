load network
[TestAdi TestYolu] = uigetfile ('*.jpg','Test Resmi Se�iniz'); 
A=imread([TestYolu TestAdi]);
C = semanticseg(A,network);  %Test g�r�nt�s�n� segmentlere ay�rma
B = labeloverlay(A,C);
imshow(B);