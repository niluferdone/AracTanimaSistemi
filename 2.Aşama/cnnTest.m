load maynet% �nceen e�itilen a�� y�kl�yoruz.
[TestAdi TestYolu] = uigetfile ('*.png','Test Resmi Se�iniz'); 
% Test resmi se�. 
A=imread([TestYolu TestAdi]);
[Pred scores] = classify(mynet,A);% Burda a�� test ediyor