clear all;
clc;
close all;


[~,config] = wfdbloadlib;


N = 646200; %number of samples

samples = [101 106 108 109 112 115 116 118 119 122 ...
 201 203 205 207 208 209 215 223 230 105 111 113 121 200 202 210 212 213 214 219  ...
 221 222 228 231 232 233 234];

XSeq = {};
YSeq = [];


for ind=1:length(samples)

    ECGsample = strcat('mitdb/', int2str(samples(ind))); 

    display('Reading train signal and annotations (human labels)');
    display(ind);
    [ann,type,subtype,chann,num]=rdann(ECGsample,'atr',1,N);
    [RR,tms]=ann2rr(ECGsample,'atr',N);
    Y = searchLabel (ann, type, tms, RR);
    YSeq = [YSeq; Y(2:end-1)];
    for chan= 1:2

        [ecg,Fs,tm]=rdsamp(ECGsample,chan,N);

        delay=49;
        M=length(RR)-1;



        for m=2:M

            X{m-1,1}(chan,1:250) = zscore(ecg(tms(m)-delay:tms(m)+200));

        end

    end

    XSeq = [XSeq; X];

    clearvars -except XSeq YSeq samples N ind

end

YSeq = categorical(cellstr(YSeq));
save('ECGallzscore.mat', 'XSeq', 'YSeq')

    


function label = searchLabel (ann, type, tms, RR)
    Iann = 2;
    Itms = 1;
    while Itms <= length(tms)
        if (abs(ann(Iann) - tms(Itms)) < min(RR)/35)
            label(Itms,1) = type(Iann);
            Itms = Itms + 1;
        end
        Iann = Iann + 1;
    end       
end


