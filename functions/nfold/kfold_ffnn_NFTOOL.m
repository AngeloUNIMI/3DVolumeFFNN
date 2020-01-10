function [problem] = kfold_ffnn_NFTOOL(problem,kfoldvalidation,mintt,maxtt,offsetN);
%
%Function kfold_ffnn takes inputs, targets, ANN params and number of folds
%and computes mean and standard deviation of fitting error
%Using Feed-Forward Neural Network Classification
%
%Inputs:
%problem: struct with fields: problem.s (samples)
%                             problem.t (targets)
%							  problem.classifier.nNeuroni (1 x N matrix, where N is the number of layers)
%							  problem.classifier.goal
%							  problem.classifier.epoche
%							  problem.classifier.transferFcns (1 x N cells, where N is the number of layers)
%kfoldvalidation = number of folds in k-fold cross-validation
%
%Output:
%problem: struct with fields: problem.s (samples)
%                             problem.t (targets)
%                             problem.classifier.name
%							  problem.classifier.nNeuroni (1 x N matrix, where N is the number of layers)
%							  problem.classifier.goal
%							  problem.classifier.epoche
%							  problem.classifier.transferFcns (1 x N cells, where N is the number of layers)
%                             problem.validation.name
%                             problem.validation.k
%                             problem.validation.meanError
%                             problem.validation.stdError
%							  problem.res_rawTot (risultati)
%							  problem.target_rawTot (Targets corrispondenti)
%							  problem.time (Tempo di classificazione)

if nargin == 2,
    threshold = 0.5;
end,





%CLASSIFICATION
%1 - PROBLEM DEFINITION
%2 - CLASSIFICATION
%3 - VALIDATION
%4 - ERROR METRICS




%------------------------------------------------------------------1 - PROBLEM DEFINITION
% a) INPUTS (nFeatures x nSamples)
% b) TARGETS (1 x nSamples)

%struttura dati
problem.s = problem.s;
problem.t = problem.t;
problem.classifier.nNeuroni = problem.classifier.nNeuroni;
problem.classifier.nLayers = size(problem.classifier.nNeuroni,2)+1;
problem.classifier.goal = problem.classifier.goal;
problem.classifier.epoche = problem.classifier.epoche;
problem.classifier.transferFcns = problem.classifier.transferFcns;




%------------------------------------------------------------------2,3 - CLASSIFICATION and VALIDATION
%struttura dati
problem.classifier.name = 'FF NN';
problem.validation.name = 'k-fold validation';
problem.validation.k = kfoldvalidation;


%codice
problem.s = problem.s';
problem.t = problem.t';
errorV = [];
hiddenLayerSize = problem.classifier.nNeuroni;

%NEURAL NETWORK CREATION AND INIZIALIZATION
net = fitnet(hiddenLayerSize);
net = init(net);
for (i=1:problem.classifier.nLayers),
    net.layers{i}.transferFcn = problem.classifier.transferFcns{i};
end,

%net.trainParam.goal = problem.classifier.goal;
%net.trainParam.epochs = problem.classifier.epoche;

net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


net.trainFcn = 'trainlm';  % Levenberg-Marquardt
net.performFcn = 'mse';  % Mean squared error
%Divideremo manualmente i dati in fase di k-fold validation
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
%net.divideParam.trainRatio = 70/100;
%net.divideParam.valRatio = 15/100;
%net.divideParam.testRatio = 15/100;
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};



minerror = 10000;

%NEURAL NETWORK TRAINING AND K-FOLD VALIDATION
indices = crossvalind('Kfold',problem.t ,problem.validation.k);

errmV = [];
errpV = [];
testPerfV = [];
minSaveN = 1e10;
fprintf(1,['\nFFNN Classifier Validation - Hidden size = ' num2str(problem.classifier.nNeuroni) '\n']);
confMatrTot = zeros(2,2);
t = 0;
for i = 1:problem.validation.k
    fprintf(1,['Validation N. ' num2str(i) '\n']);
    test = (indices == i); traini = ~test;
    net.trainParam.showWindow = false;
    net.trainParam.showCommandLine = false;
    
    [net,tr] = train(net,problem.s(traini,:)',problem.t(traini)');
    tic
    %class = round(abs(net(problem.s(test,:)')'));
    class = net(problem.s(test,:)')' ;
    tparz = toc;
    t = t + tparz;
    res_raw = net(problem.s(test,:)')';
    res_raw_train = net(problem.s(traini,:)')';
    res_rawTot{i} = res_raw;
    target_rawTot{i} = problem.t(test,:);
    
    
    %errore in rapporto al volume
    errp = abs(res_raw - (problem.t(test,:))) ./ (problem.t(test,:));
    
    %res_rawdn = res_raw - offsetN;
    %res_rawdn = (res_rawdn * maxtt) + mintt;
    %ptdn = problem.t(test,:) - offsetN;
    %ptdn = (ptdn * maxtt) + mintt;
    %errm = abs(res_rawdn - ptdn) ;
    
    errm = abs(res_raw - (problem.t(test,:)));
    
    meanSaveN = mean(errm);
    if meanSaveN < minSaveN,
        minSaveN = meanSaveN;
        SaveN = net;
    end,
    %pause
    
    errmV = [errmV; errm];
    errpV = [errpV; errp];
    
    if(1),
        % Test the Network
        outputs = net(problem.s(test,:)');
        errors = gsubtract(problem.t(test,:)',res_raw);
        
        % Recalculate Training, Validation and Test Performance
        trainTargets = problem.t(traini,:);
        testTargets = problem.t(test,:);
        
        trainPerformance = perform(net,trainTargets,res_raw_train);
        testPerformance = perform(net,testTargets,res_raw);
        
        testPerfV = [testPerfV testPerformance];
        
    end,
    
    %if(hiddenLayerSize >= 10), pause, end,
end %end for validation





%------------------------------------------------------------------4 - ERROR METRICS
%codice

%denormalization
%errmV = errmV - offsetN;
%errmV = (errmV * maxtt) + mintt;


meanErrorP = mean(errpV);
stdErrorP = std(errpV);
meanErrorM = mean(errmV);
stdErrorM = std(errmV);
meanTestPerfV = mean(testPerfV);



%struttura dati
problem.validation.meanErrorP = meanErrorP;
problem.validation.stdErrorP = stdErrorP;
problem.validation.meanErrorM = meanErrorM;
problem.validation.stdErrorM = stdErrorM;
problem.validation.meanMseError = meanTestPerfV;


problem.s = problem.s';
problem.t = problem.t';


problem.res_rawTot = res_rawTot;
problem.target_rawTot = target_rawTot;
problem.time = t;
problem.object = SaveN;









