load segment_semantic
[TestAdi TestYolu] = uigetfile ('*.jpg','Test Resmi Se�iniz'); 
A=imread([TestYolu TestAdi]);
 A=imresize(A,[144 144]);
resim=A;
C = semanticseg(A,network);
B = labeloverlay(A,C);



