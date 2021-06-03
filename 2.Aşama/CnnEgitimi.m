layers = [
    imageInputLayer([40 40 3],"Name","imageinput")
    convolution2dLayer([3 3],32,"Name","conv_1","Padding","same")
    maxPooling2dLayer([5 5],"Name","maxpool_1","Padding","same")
    reluLayer("Name","relu_1")
    fullyConnectedLayer(2,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];


allImages=imageDatastore('arac','IncludeSubfolders',true,'LabelSource','foldernames');

[trainingImages,testImages]= splitEachLabel(allImages,0.8,'randomized');
options = trainingOptions('adam', ...
    'MaxEpochs',120, ...
    'InitialLearnRate',1e-4, ...
    'MiniBatchSize',40, ...
    'Plots','training-progress');
mynet = trainNetwork(trainingImages,layers,options);
Pred = classify(mynet,testImages);
accuracy=mean(Pred==testImages.Labels);
Conf=confusionmat(Pred,testImages.Labels);
fig=figure();
plotconfusion(testImages.Labels,Pred);

