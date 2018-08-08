clc
clear all
close all
%% Load data
homedir = pwd;


XData = [XTest; XTrain];
YData = [YTest; YTrain];
YData =  categorical(cellstr(YData));

load ECGallzscore.mat
XData = XSeq;
YData = categorical(cellstr(YSeq));


%% Discrete cosinus transform

for i=1:length(YData)
    for ii=1:2
        x = XData{i}(ii,:);
        X = dct(x);
        [XX,ind] = sort(abs(X),'descend');
        X(ind(50+1:end)) = 0;    %  xx = idct(X); to reconstruct signal
        switch ii
            case 1
                lead1DCT(i,:) = X;
            case 2
                lead2DCT(i,:) = X;
        end
        

    end
end

plot([XData{1}(1,:);idct(lead1DCT(1,:))]')
legend('Original',['Reconstructed, N = 50'], ...
       'Location','SouthEast')
   
%% Feature extraction with ICA

features=10;

lead1Mdl = rica(lead1DCT,features,'IterationLimit',10);
lead1ICA = transform(lead1Mdl,lead1DCT);

lead2Mdl = rica(lead2DCT,features,'IterationLimit',10);
lead2ICA = transform(lead2Mdl,lead2DCT);


for i=1:length(YData)
    ICA{i,1}(1,:) = lead1ICA(i,:);
    ICA{i,1}(2,:) = lead2ICA(i,:);
        
end


save('Featureextallzscore.mat', 'ICA', 'XData', 'YData')





