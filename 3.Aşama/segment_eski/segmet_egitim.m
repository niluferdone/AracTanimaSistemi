dataDir = fullfile('C:\Users\ASUS\Desktop\road_Line');%içerisinde fotoðraf var bu klasörün içinde eðitm ve test diye klasör var. eðitim için hem segmetlenmiþ fotoðraflar 
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
filterSize = [3 3]; %3'e 3'lük filtre kullandým.
filterSize1 = [5 5];
filterSize2 = [7 7];
filterSize3 = [9 9];
numFilters = 25; %filtre kulanarak bu sayý kadar özellik haritasý olmasýný saðladým.
numFilters1 = 50;
numFilters2 = 75;
numFilters3 = 100;
conv = convolution2dLayer(filterSize,numFilters,'Stride',1,'Padding','same'); %Same padding, her zaman görüntünün dýþýndaki boþ satýrlarý ve sütunlarý doldurur. Sonuc olarak kývrýmlý matris giriþ ile ayný boyutta olur.
conv1 = convolution2dLayer(filterSize1,numFilters1,'Stride',1,'Padding','same'); 
conv2 = convolution2dLayer(filterSize2,numFilters2,'Stride',1,'Padding','same'); 
conv3 = convolution2dLayer(filterSize3,numFilters3,'Stride',1,'Padding','same'); 
relu = reluLayer();  %Evriþimin çýktýsý aktivasyon fonksiyonundan geçirilir. ReLu aktivasyon fonk.
poolSize =[2 2] ;
maxPoolDownsample2x = maxPooling2dLayer(poolSize,'Stride',2); %Pooling tabakasý Convolved Unsurun uzamsal boyutunu azaltmaktan sorumludur.Maksimum Havuzlama,görüntünün filtre tarafýndan kapsanan kýsmýndan maksimum deðeri döndürür. Girdi 2 kat aþþaðý örneklendi.
downsamplingLayers = [  % 6x1 Katmanlý katman
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
transposedConvUpsample2x = transposedConv2dLayer(filterSize,numFilters3,'Stride',2);%yukarý örnekleme(dekonv.kullanýlarak yapýlýr.).Aktarýlmýþ bir evriþim yukarý örnekleme için kullanýldýðýnda, yukarý örnekleme ve filtreleme ayný anda gerçekleþtirir.
upsamplingLayers = [   % 4x1 Katmanlý katman 
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    ]
numClasses = 1;   %"yol" "arka_plan" "isaret"  olmak üzere piksel ýd'li 3 adet sýnýf var
conv1x1 = convolution2dLayer(1,numClasses);
finalLayers = [  % piksel sýnýflandýrmalarýndan sorumlu olan son katman. Giriþ görüntüsü ile ayný uzamsal boyutlara sahip(yükseklik,geniþik) giriþleri iþler.Kanal sayýsý(üçüncü boyut)daha fazladýr ve bu üçüncü boyutun, segmentlere ayýrmak istediðimiz sýnýf sayýsýna kadar sýkýþtýrýlmasý gerekir.
    conv1x1
    softmaxLayer()   % softmax ve piksel sýnýflandýrma katmanlarý her bir görüntü pikseli için kategorik etiketi tahmin etmek üzere birleþir.
    pixelClassificationLayer()
    ]
net = [  %Aðý tamamlamak üzere tüm katmanlar yýðýnlanýr. Toplamda 14x1 katman
    imgLayer    %Görüntü giriþ katmaný
    downsamplingLayers  %aþaðý örnekleme
    upsamplingLayers  %yukarý örnekleme
    finalLayers  %sýnýflandýrma katm.
    ]
 %Eðitim seçeneklerini ayarlama.
opts = trainingOptions('sgdm', ...  %Eðitim aðý için çözücü. sgdm'- Momentum (SGDM) optimize edici ile stokastik gradyan iniþ kullanýn.Momentum deðerini, 'Momentum'ad-deðer çifti baðýmsýz deðiþkenini kullanarak belirtebilirsiniz .
    'InitialLearnRate',1e-3, ...  %Ýlk öðrenme oraný. Eðitim için kullanýlan baþlangýç ??öðrenme oraný, virgülle ayrýlmýþ çift 'InitialLearnRate've pozitif bir skalerden oluþur. Varsayýlan deðer 'sgdm'çözücü için 0.01 ,Öðrenme oraný çok düþükse, eðitim uzun zaman alýr. Öðrenme oraný çok yüksekse, eðitim yetersiz bir sonuca ulaþabilir veya farklý olabilir.
    'MaxEpochs',500, ...   %Maksimum dönem sayýsý. Eðitim için kullanýlacak maksimum dönem sayýsý, virgülle ayrýlmýþ çift 'MaxEpochs've pozitif bir tamsayýdan oluþur.Yineleme(iterasyon), gradyan iniþ algoritmasýnda, bir mini-batch kullanarak kayýp fonksiyonunu en aza indirgemek için atýlan bir adýmdýr. Bir epoh, eðitim algoritmasýnýn tüm eðitim seti boyunca tam geçiþidir.
    'MiniBatchSize',64);%Her eðitim yinelemesi için kullanýlacak mini-batch boyutu, virgülle ayrýlmýþ çift 'MiniBatchSize've pozitif bir tamsayý olarak belirtilir. Mini-batch iþ, kayýp iþlevinin gradyanýný deðerlendirmek ve aðýrlýklarý güncellemek için kullanýlan eðitim kümesinin bir alt kümesidir.
trainingData = pixelLabelImageDatastore(imds,pxds); 
tbl = countEachLabel (trainingData)  %piksel veya kutu etiketleri hakkýnda bilgi içeren bir tablo döndürür 
prior = 1/numel(classNames);
uniformClassWeights = prior./tbl.PixelCount  %eþit ön aðýrlýklandýrma 
%freq = tbl.PixelCount ./ tbl.ImagePixelCount
%medFreqClassWeights = median(freq) ./ freq      % Ortanca frekans aðýrlýklandýrma
net(end) = pixelClassificationLayer('Classes',tbl.Name,'ClassWeights',uniformClassWeights);
network = trainNetwork(trainingData,net,opts);  %Aðý eðitme
imshow (I2)
C = semanticseg(I2,network);  %Test görüntüsünü segmentlere ayýrma
B = labeloverlay(I2,C);
imshow(B)
save network
function labelIDs = roadLinePixelLabelIDs() %segmentlenmiþ ve normal görüntüleri eþleþtiriyor
labelIDs = { ...
     
    [
      ... 
      0 0 0
    ]
    }
end
