load maynet% Önceen eðitilen aðý yüklüyoruz.
[TestAdi TestYolu] = uigetfile ('*.png','Test Resmi Seçiniz'); 
% Test resmi seç. 
A=imread([TestYolu TestAdi]);
[Pred scores] = classify(mynet,A);% Burda aðý test ediyor