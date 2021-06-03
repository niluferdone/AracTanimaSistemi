dataDir = fullfile('C:\Users\ASUS\Desktop\road_Line');%i�erisinde foto�raf var bu klas�r�n i�inde e�itm ve test diye klas�r var. e�itim i�in hem segmetlenmi� foto�raflar 
dataDi = fullfile(dataDir,'data_road');
dataD = fullfile(dataDi,'training');
imDir = fullfile(dataD,'image_2_yenii');
pxDir = fullfile(dataD,'gt_image_2_yenii');
imds = imageDatastore(imDir);
I = readimage(imds,18);
%figure
%imshow(I)
classNames = ["arac"];
labelIDs = roadLinePixelLabelIDs()
pxds = pixelLabelDatastore(pxDir,classNames,labelIDs);
C = readimage(pxds,18);
B = labeloverlay(I,C);
%figure
%imshow(B)
buildingMask = C == 'araba';
%figure
%imshowpair(I, buildingMask,'montage')
inputSize = [144 144 3];
imgLayer = imageInputLayer (inputSize)
filterSize = [3 3]; %3'e 3'l�k filtre kulland�m.
filterSize1 = [5 5];
filterSize2 = [7 7];
filterSize3 = [9 9];
numFilters = 25; %filtre kulanarak bu say� kadar �zellik haritas� olmas�n� sa�lad�m.
numFilters1 = 50;
numFilters2 = 75;
numFilters3 = 100;
conv = convolution2dLayer(filterSize,numFilters,'Stride',1,'Padding','same'); %Same padding, her zaman g�r�nt�n�n d���ndaki bo� sat�rlar� ve s�tunlar� doldurur. Sonuc olarak k�vr�ml� matris giri� ile ayn� boyutta olur.
conv1 = convolution2dLayer(filterSize1,numFilters1,'Stride',1,'Padding','same'); 
conv2 = convolution2dLayer(filterSize2,numFilters2,'Stride',1,'Padding','same'); 
conv3 = convolution2dLayer(filterSize3,numFilters3,'Stride',1,'Padding','same'); 
relu = reluLayer();  %Evri�imin ��kt�s� aktivasyon fonksiyonundan ge�irilir. ReLu aktivasyon fonk.
poolSize =[2 2] ;
maxPoolDownsample2x = maxPooling2dLayer(poolSize,'Stride',2); %Pooling tabakas� Convolved Unsurun uzamsal boyutunu azaltmaktan sorumludur.Maksimum Havuzlama,g�r�nt�n�n filtre taraf�ndan kapsanan k�sm�ndan maksimum de�eri d�nd�r�r. Girdi 2 kat a��a�� �rneklendi.
downsamplingLayers = [  % 6x1 Katmanl� katman
    conv      %144
    relu
    maxPoolDownsample2x    %72
    conv1
    relu
    maxPoolDownsample2x   %36
    conv2
    relu
    maxPoolDownsample2x         %18
    conv3
    relu
    maxPoolDownsample2x         %9
    ]
filterSize = [2 2];
transposedConvUpsample2x = transposedConv2dLayer(filterSize,numFilters3,'Stride',2);%yukar� �rnekleme(dekonv.kullan�larak yap�l�r.).Aktar�lm�� bir evri�im yukar� �rnekleme i�in kullan�ld���nda, yukar� �rnekleme ve filtreleme ayn� anda ger�ekle�tirir.
upsamplingLayers = [   % 4x1 Katmanl� katman 
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    ]
numClasses = 1;   %"yol" "arka_plan" "isaret"  olmak �zere piksel �d'li 3 adet s�n�f var
conv1x1 = convolution2dLayer(1,numClasses);
finalLayers = [  % piksel s�n�fland�rmalar�ndan sorumlu olan son katman. Giri� g�r�nt�s� ile ayn� uzamsal boyutlara sahip(y�kseklik,geni�ik) giri�leri i�ler.Kanal say�s�(���nc� boyut)daha fazlad�r ve bu ���nc� boyutun, segmentlere ay�rmak istedi�imiz s�n�f say�s�na kadar s�k��t�r�lmas� gerekir.
    conv1x1
    softmaxLayer()   % softmax ve piksel s�n�fland�rma katmanlar� her bir g�r�nt� pikseli i�in kategorik etiketi tahmin etmek �zere birle�ir.
    pixelClassificationLayer()
    ]
net = [  %A�� tamamlamak �zere t�m katmanlar y���nlan�r. Toplamda 14x1 katman
    imgLayer    %G�r�nt� giri� katman�
    downsamplingLayers  %a�a�� �rnekleme
    upsamplingLayers  %yukar� �rnekleme
    finalLayers  %s�n�fland�rma katm.
    ]
 %E�itim se�eneklerini ayarlama.
opts = trainingOptions('sgdm', ...  %E�itim a�� i�in ��z�c�. sgdm'- Momentum (SGDM) optimize edici ile stokastik gradyan ini� kullan�n.Momentum de�erini, 'Momentum'ad-de�er �ifti ba��ms�z de�i�kenini kullanarak belirtebilirsiniz .
    'InitialLearnRate',1e-3, ...  %�lk ��renme oran�. E�itim i�in kullan�lan ba�lang�� ??��renme oran�, virg�lle ayr�lm�� �ift 'InitialLearnRate've pozitif bir skalerden olu�ur. Varsay�lan de�er 'sgdm'��z�c� i�in 0.01 ,��renme oran� �ok d���kse, e�itim uzun zaman al�r. ��renme oran� �ok y�ksekse, e�itim yetersiz bir sonuca ula�abilir veya farkl� olabilir.
    'MaxEpochs',500, ...   %Maksimum d�nem say�s�. E�itim i�in kullan�lacak maksimum d�nem say�s�, virg�lle ayr�lm�� �ift 'MaxEpochs've pozitif bir tamsay�dan olu�ur.Yineleme(iterasyon), gradyan ini� algoritmas�nda, bir mini-batch kullanarak kay�p fonksiyonunu en aza indirgemek i�in at�lan bir ad�md�r. Bir epoh, e�itim algoritmas�n�n t�m e�itim seti boyunca tam ge�i�idir.
    'MiniBatchSize',64);%Her e�itim yinelemesi i�in kullan�lacak mini-batch boyutu, virg�lle ayr�lm�� �ift 'MiniBatchSize've pozitif bir tamsay� olarak belirtilir. Mini-batch i�, kay�p i�levinin gradyan�n� de�erlendirmek ve a��rl�klar� g�ncellemek i�in kullan�lan e�itim k�mesinin bir alt k�mesidir.
trainingData = pixelLabelImageDatastore(imds,pxds); 
tbl = countEachLabel (trainingData)  %piksel veya kutu etiketleri hakk�nda bilgi i�eren bir tablo d�nd�r�r 
prior = 1/numel(classNames);
uniformClassWeights = prior./tbl.PixelCount  %e�it �n a��rl�kland�rma 
%freq = tbl.PixelCount ./ tbl.ImagePixelCount
%medFreqClassWeights = median(freq) ./ freq      % Ortanca frekans a��rl�kland�rma
net(end) = pixelClassificationLayer('Classes',tbl.Name,'ClassWeights',uniformClassWeights);
network = trainNetwork(trainingData,net,opts);  %A�� e�itme
imshow (I2)
C = semanticseg(I2,network);  %Test g�r�nt�s�n� segmentlere ay�rma
B = labeloverlay(I2,C);
imshow(B)
save network
function labelIDs = roadLinePixelLabelIDs() %segmentlenmi� ve normal g�r�nt�leri e�le�tiriyor
labelIDs = { ...
     
    [
      ... 
      0 0 0
    ]
    }
end
