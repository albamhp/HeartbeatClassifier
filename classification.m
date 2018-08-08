clc;
clear all;
close all;


%load ICAData.mat;
load Featureextallzscore.mat;



for i=1:2
    
    switch i
        case 1 % Class-based assesment
            
            
        case 2 % Subject based assesment
            
            YData = mergecats(YData,{'N','L','R','e','j'});
            YData = mergecats(YData,{'S','A','a','J'});
            YData = mergecats(YData,{'V','E','!'});
            YData = mergecats(YData,{'Q','f'});

    end

    
    %% Define LSTM Network Architecture            
    
    
    isLabels= unique(YData);
    numClasses = numel(isLabels);


    inputSize = 2;
    numHiddenUnits = 100;


    layers = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits,'OutputMode','last')
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer]


    % Specify the training options.
    maxEpochs = 5;
    options = trainingOptions('adam', ...
        'GradientThreshold',1, ...
        'MaxEpochs',maxEpochs, ...
        'InitialLearnRate',0.01, ...
        'LearnRateSchedule','piecewise', ...
        'LearnRateDropPeriod',20, ...
        'Verbose',0, ...
        'Plots','training-progress')


    % Train the LSTM network 
    net = trainNetwork(ICA,YData,layers,options)



    %% Test LSTM Network


    YPred = classify(net,ICA);
    acc = sum(YPred == YData)./numel(YData)

    plotconfusion(YData,YPred)

    
end
