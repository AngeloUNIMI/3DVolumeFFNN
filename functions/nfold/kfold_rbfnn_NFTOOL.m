function [problem] = kfold_rbfnn(problem,kfoldvalidation,spread,maxneurons,DF,threshold)
%
%Function kfold_ffnn takes inputs, targets, ANN params and number of folds
%and computes mean and standard deviation of classification error
%Using Radial Basis Function Neural Network Classification
%
%Inputs: 
%problem: struct with fields: problem.s (samples)
%                             problem.t (targets)
%							  problem.classifier.max_neurons (maximum number of hidden neurons) 
%kfoldvalidation = number of folds in k-fold cross-validation
%
%Output:
%problem: struct with fields: problem.s (samples)
%                             problem.t (targets)
%                             problem.validation.name
%                             problem.validation.k
%                             problem.validation.meanError
%                             problem.validation.stdError
%							  problem.confMatrMean (Matrice di confusione media)
%							  problem.class_rawTot (Uscite raw del classificatore)
%							  problem.target_rawTot (Targets corrispondenti)
%							  problem.time (Tempo di classificazione)

if nargin == 5,
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





%------------------------------------------------------------------2,3 - CLASSIFICATION and VALIDATION
%struttura dati
problem.classifier.name = 'RBF NN';
problem.validation.name = 'k-fold validation';
problem.validation.k = kfoldvalidation;


%codice
problem.s = problem.s';
problem.t = problem.t';
errorV = [];

%NEURAL NETWORK CREATION AND INIZIALIZATION


minerror = 10000;
errV = [];
testPerfV = [];
%NEURAL NETWORK TRAINING AND K-FOLD VALIDATION
indices = crossvalind('Kfold',problem.t ,problem.validation.k);
fprintf(1,['\nRBF NN Classifier Validation\n']);
confMatrTot = zeros(2,2);
t = 0;
for i = 1:problem.validation.k
	fprintf(1,['Validation N. ' num2str(i) '\n']);
    test = (indices == i); traini = ~test;

	
	
	net = newrb(problem.s(traini,:)',problem.t(traini)',problem.classifier.goal,spread,maxneurons,DF);
	net.performFcn = 'mse';  % Mean squared error
	tic	
	%class = round(abs(net(problem.s(test,:)')'));
	class = sim(net,problem.s(test,:)')' ;
	tparz = toc;
	t = t + tparz;
	res_raw = class;
	res_raw_train = sim(net,problem.s(traini,:)')' ;
	res_rawTot{i} = res_raw;
	target_rawTot{i} = problem.t(test,:);
	

	%errore in rapporto al volume
	err = abs(res_raw - (problem.t(test,:))) ./ (problem.t(test,:));
	%pause
	
	errV = [errV; err];
	
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
	
end








%------------------------------------------------------------------4 - ERROR METRICS
%codice
meanError = mean(errV);
stdError = std(errV);
meanTestPerfV = mean(testPerfV);



%struttura dati
problem.validation.meanError = meanError;
problem.validation.stdError = stdError;
problem.validation.meanMseError = meanTestPerfV;


problem.s = problem.s';
problem.t = problem.t';


problem.res_rawTot = res_rawTot;
problem.target_rawTot = target_rawTot;
problem.time = t;
problem.object = net;










