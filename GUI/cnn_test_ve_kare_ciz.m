load test-cnn
[Pred scores] = classify(mynet,K);
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
resim_sonuc=imresize(resim,[224 330]);
end
