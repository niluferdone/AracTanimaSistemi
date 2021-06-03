load network
[TestAdi TestYolu] = uigetfile ('*.jpg','Test Resmi Seçiniz'); 
A=imread([TestYolu TestAdi]);
C = semanticseg(A,network);  %Test görüntüsünü segmentlere ayýrma
B = labeloverlay(A,C);
imshow(B);