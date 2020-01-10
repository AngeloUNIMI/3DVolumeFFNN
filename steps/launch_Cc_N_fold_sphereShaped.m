% clc
close all
clear variables

addpath(genpath('../functions'));
addpath(genpath('../util'));

savefile = 1;
KFOLD = 5;

%RESULTS
dirResultsBase = '../Results/';
dirSaveDs = [dirResultsBase 'dataset\'];

%only box-shaped
objectV = {'verde', 'ruota', 'sfera1'};

%output directory
dirOutNfold = [dirResultsBase 'n_fold\'];
dirOut = [dirOutNfold 'sphereShaped\'];
mkdir_pers(dirOut, savefile);


%global structures
problemT.s = [];
problemT.t = [];

%load Data
fprintf(1, 'Loading data...\n');
for i = 1 : numel(objectV)
    
    problemVDirs = [dirSaveDs objectV{i} '\'];
    
    filesI = dir([problemVDirs 'ds_red_3d.mat']);
    
    for k = 1 : numel(filesI)
        
        tt = load([problemVDirs filesI(k).name]);
        n_sample = tt.n_sample;
        problem = tt.problem;
        
        stepf = 1;
        if (stepf == 0)
            stepf = 1;
        end
        
        problem.s = problem.s(:,1:stepf:end);
        problem.t = problem.t(:,1:stepf:end);
        
        problemT.s = [problemT.s problem.s];
        problemT.t = [problemT.t problem.t];
        
    end %end for k
    
    
end %end for i



%normalizzazione
offsetN = 1;
for k_norm = 1:size(problemT.s,1)
    [problemT.s(k_norm,:),minss(k_norm),maxss(k_norm)] = normalizzaMat(problemT.s(k_norm,:));
    problemT.s(k_norm,:) = problemT.s(k_norm,:) + offsetN;
end

if  numel(unique(problemT.t)) > 1
    [problemT.t,mintt,maxtt] = normalizzaMat(problemT.t); %altrimenti ci sono divisioni per
    problemT.t = problemT.t + offsetN;
end



inputsh = problemT.s;
targetsh = problemT.t;

[inputsh, Iss] = shuffle(inputsh,2);
targetsh = targetsh(Iss);
[inputsh, Iss] = shuffle(inputsh,2);
targetsh = targetsh(Iss);

problemT.s = inputsh;
problemT.t = targetsh;


fileOut = [dirOut num2str(KFOLD) '_fold_val.txt'];

fid = fopen(fileOut,'w');
fprintf(fid,['Number of features: ' num2str(size(problemT.s,1)) '\r\n']);
fprintf(fid,['Database size: ' num2str(size(problemT.s,2)) '\r\n']);
fprintf(fid,['\r\n\r\n\r\n']);

fprintf(1,['Number of features: ' num2str(size(problemT.s,1)) '\n']);
fprintf(1,['Database size: ' num2str(size(problemT.s,2)) '\n']);



clear problemLIN problemDIAGLIN problemQUAD ...
    problemKNN1 problemKNN3 problemKNN5 problemkNN10 problemFNN1 ...
    problemFNN3  problemFNN5 problemFNN10



minNN = 100000;


problemFNN1.s = problemT.s;
problemFNN1.t = problemT.t;
problemFNN1.classifier.nNeuroni = [1];
problemFNN1.classifier.goal = 0.0000000002;
problemFNN1.classifier.epoche = 150;
problemFNN1.classifier.transferFcns = {'tansig','purelin'};
problemFNN1 = kfold_ffnn_NFTOOL(problemFNN1,KFOLD,mintt,maxtt,offsetN);
t = problemFNN1.time;
fprintf(fid,['** -- FNN-1 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN1.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN1.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN1.validation.stdErrorP) '\r\n']);
nn1_errMeanP = problemFNN1.validation.meanErrorP;
nn1_errStdP = problemFNN1.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn1_errMeanP) '\t' num2str(nn1_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN1.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN1.validation.stdErrorM) '\r\n']);
nn1_errMeanM = problemFNN1.validation.meanErrorM;
nn1_errStdM = problemFNN1.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn1_errMeanM) '\t' num2str(nn1_errStdM) '\r\n\r\n']);

if (problemFNN1.validation.meanErrorP < minNN)
    minNN = problemFNN1.validation.meanErrorP;
    errMean = nn1_errMeanP;
    errStd = nn1_errStdP;
    chosen = 1;
    timem = t;
    netobj = problemFNN1.object;
end



problemFNN3.s = problemT.s;
problemFNN3.t = problemT.t;
problemFNN3.classifier.nNeuroni = [3];
problemFNN3.classifier.goal = 0.0000000002;
problemFNN3.classifier.epoche = 150;
problemFNN3.classifier.transferFcns = {'tansig','purelin'};
problemFNN3 = kfold_ffnn_NFTOOL(problemFNN3,KFOLD,mintt,maxtt,offsetN);
t = problemFNN3.time;
fprintf(fid,['** -- FNN-3 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN3.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN3.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN3.validation.stdErrorP) '\r\n']);
nn3_errMeanP = problemFNN3.validation.meanErrorP;
nn3_errStdP = problemFNN3.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn3_errMeanP) '\t' num2str(nn3_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN3.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN3.validation.stdErrorM) '\r\n']);
nn3_errMeanM = problemFNN3.validation.meanErrorM;
nn3_errStdM = problemFNN3.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn3_errMeanM) '\t' num2str(nn3_errStdM) '\r\n\r\n']);

if (problemFNN3.validation.meanErrorP < minNN)
    minNN = problemFNN3.validation.meanErrorP;
    errMean = nn3_errMeanP;
    errStd = nn3_errStdP;
    chosen = 3;
    timem = t;
    netobj = problemFNN3.object;
end



problemFNN5.s = problemT.s;
problemFNN5.t = problemT.t;
problemFNN5.classifier.nNeuroni = [5];
problemFNN5.classifier.goal = 0.0000000002;
problemFNN5.classifier.epoche = 150;
problemFNN5.classifier.transferFcns = {'tansig','purelin'};
problemFNN5 = kfold_ffnn_NFTOOL(problemFNN5,KFOLD,mintt,maxtt,offsetN);
t = problemFNN5.time;
fprintf(fid,['** -- FNN-5 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN5.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN5.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN5.validation.stdErrorP) '\r\n']);
nn5_errMeanP = problemFNN5.validation.meanErrorP;
nn5_errStdP = problemFNN5.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn5_errMeanP) '\t' num2str(nn5_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN5.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN5.validation.stdErrorM) '\r\n']);
nn5_errMeanM = problemFNN5.validation.meanErrorM;
nn5_errStdM = problemFNN5.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn5_errMeanM) '\t' num2str(nn5_errStdM) '\r\n\r\n']);

if (problemFNN5.validation.meanErrorP < minNN)
    minNN = problemFNN5.validation.meanErrorP;
    errMean = nn5_errMeanP;
    errStd = nn5_errStdP;
    chosen = 5;
    timem = t;
    netobj = problemFNN5.object;
end



problemFNN10.s = problemT.s;
problemFNN10.t = problemT.t;
problemFNN10.classifier.nNeuroni = [10];
problemFNN10.classifier.goal = 0.0000000002;
problemFNN10.classifier.epoche = 150;
problemFNN10.classifier.transferFcns = {'tansig','purelin'};
problemFNN10 = kfold_ffnn_NFTOOL(problemFNN10,KFOLD,mintt,maxtt,offsetN);
t = problemFNN10.time;
fprintf(fid,['** -- FNN-10 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN10.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN10.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN10.validation.stdErrorP) '\r\n']);
nn10_errMeanP = problemFNN10.validation.meanErrorP;
nn10_errStdP = problemFNN10.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn10_errMeanP) '\t' num2str(nn10_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN10.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN10.validation.stdErrorM) '\r\n']);
nn10_errMeanM = problemFNN10.validation.meanErrorM;
nn10_errStdM = problemFNN10.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn10_errMeanM) '\t' num2str(nn10_errStdM) '\r\n\r\n']);

if (problemFNN10.validation.meanErrorP < minNN)
    minNN = problemFNN10.validation.meanErrorP;
    errMean = nn10_errMeanP;
    errStd = nn10_errStdP;
    chosen = 10;
    timem = t;
    netobj = problemFNN10.object;
end




problemFNN15.s = problemT.s;
problemFNN15.t = problemT.t;
problemFNN15.classifier.nNeuroni = [15];
problemFNN15.classifier.goal = 0.0000000002;
problemFNN15.classifier.epoche = 150;
problemFNN15.classifier.transferFcns = {'tansig','purelin'};
problemFNN15 = kfold_ffnn_NFTOOL(problemFNN15,KFOLD,mintt,maxtt,offsetN);
t = problemFNN15.time;
fprintf(fid,['** -- FNN-15 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN15.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN15.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN15.validation.stdErrorP) '\r\n']);
nn15_errMeanP = problemFNN15.validation.meanErrorP;
nn15_errStdP = problemFNN15.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn15_errMeanP) '\t' num2str(nn15_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN15.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN15.validation.stdErrorM) '\r\n']);
nn15_errMeanM = problemFNN15.validation.meanErrorM;
nn15_errStdM = problemFNN15.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn15_errMeanM) '\t' num2str(nn15_errStdM) '\r\n\r\n']);

if (problemFNN15.validation.meanErrorP < minNN)
    minNN = problemFNN15.validation.meanErrorP;
    errMean = nn15_errMeanP;
    errStd = nn15_errStdP;
    chosen = 15;
    timem = t;
    netobj = problemFNN15.object;
end



problemFNN20.s = problemT.s;
problemFNN20.t = problemT.t;
problemFNN20.classifier.nNeuroni = [20];
problemFNN20.classifier.goal = 0.0000000002;
problemFNN20.classifier.epoche = 150;
problemFNN20.classifier.transferFcns = {'tansig','purelin'};
problemFNN20 = kfold_ffnn_NFTOOL(problemFNN20,KFOLD,mintt,maxtt,offsetN);
t = problemFNN20.time;
fprintf(fid,['** -- FNN-20 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN20.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN20.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN20.validation.stdErrorP) '\r\n']);
nn20_errMeanP = problemFNN20.validation.meanErrorP;
nn20_errStdP = problemFNN20.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn20_errMeanP) '\t' num2str(nn20_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN20.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN20.validation.stdErrorM) '\r\n']);
nn20_errMeanM = problemFNN20.validation.meanErrorM;
nn20_errStdM = problemFNN20.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn20_errMeanM) '\t' num2str(nn20_errStdM) '\r\n\r\n']);

if (problemFNN20.validation.meanErrorP < minNN)
    minNN = problemFNN20.validation.meanErrorP;
    errMean = nn20_errMeanP;
    errStd = nn20_errStdP;
    chosen = 20;
    timem = t;
    netobj = problemFNN20.object;
end



problemFNN25.s = problemT.s;
problemFNN25.t = problemT.t;
problemFNN25.classifier.nNeuroni = [25];
problemFNN25.classifier.goal = 0.0000000002;
problemFNN25.classifier.epoche = 150;
problemFNN25.classifier.transferFcns = {'tansig','purelin'};
problemFNN25 = kfold_ffnn_NFTOOL(problemFNN25,KFOLD,mintt,maxtt,offsetN);
t = problemFNN25.time;
fprintf(fid,['** -- FNN-25 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN25.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN25.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN25.validation.stdErrorP) '\r\n']);
nn25_errMeanP = problemFNN25.validation.meanErrorP;
nn25_errStdP = problemFNN25.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn25_errMeanP) '\t' num2str(nn25_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN25.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN25.validation.stdErrorM) '\r\n']);
nn25_errMeanM = problemFNN25.validation.meanErrorM;
nn25_errStdM = problemFNN25.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn25_errMeanM) '\t' num2str(nn25_errStdM) '\r\n\r\n']);

if (problemFNN25.validation.meanErrorP < minNN)
    minNN = problemFNN25.validation.meanErrorP;
    errMean = nn25_errMeanP;
    errStd = nn25_errStdP;
    chosen = 25;
    timem = t;
    netobj = problemFNN25.object;
end






problemFNN30.s = problemT.s;
problemFNN30.t = problemT.t;
problemFNN30.classifier.nNeuroni = [30];
problemFNN30.classifier.goal = 0.0000000002;
problemFNN30.classifier.epoche = 150;
problemFNN30.classifier.transferFcns = {'tansig','purelin'};
problemFNN30 = kfold_ffnn_NFTOOL(problemFNN30,KFOLD,mintt,maxtt,offsetN);
t = problemFNN30.time;
fprintf(fid,['** -- FNN-30 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN30.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN30.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN30.validation.stdErrorP) '\r\n']);
nn30_errMeanP = problemFNN30.validation.meanErrorP;
nn30_errStdP = problemFNN30.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn30_errMeanP) '\t' num2str(nn30_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN30.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN30.validation.stdErrorM) '\r\n']);
nn30_errMeanM = problemFNN30.validation.meanErrorM;
nn30_errStdM = problemFNN30.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn30_errMeanM) '\t' num2str(nn30_errStdM) '\r\n\r\n']);

if (problemFNN30.validation.meanErrorP < minNN)
    minNN = problemFNN30.validation.meanErrorP;
    errMean = nn30_errMeanP;
    errStd = nn30_errStdP;
    chosen = 30;
    timem = t;
    netobj = problemFNN30.object;
end




problemFNN35.s = problemT.s;
problemFNN35.t = problemT.t;
problemFNN35.classifier.nNeuroni = [35];
problemFNN35.classifier.goal = 0.0000000002;
problemFNN35.classifier.epoche = 150;
problemFNN35.classifier.transferFcns = {'tansig','purelin'};
problemFNN35 = kfold_ffnn_NFTOOL(problemFNN35,KFOLD,mintt,maxtt,offsetN);
t = problemFNN35.time;
fprintf(fid,['** -- FNN-35 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN35.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN35.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN35.validation.stdErrorP) '\r\n']);
nn35_errMeanP = problemFNN35.validation.meanErrorP;
nn35_errStdP = problemFNN35.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn35_errMeanP) '\t' num2str(nn35_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN35.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN35.validation.stdErrorM) '\r\n']);
nn35_errMeanM = problemFNN35.validation.meanErrorM;
nn35_errStdM = problemFNN35.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn35_errMeanM) '\t' num2str(nn35_errStdM) '\r\n\r\n']);

if (problemFNN35.validation.meanErrorP < minNN)
    minNN = problemFNN35.validation.meanErrorP;
    errMean = nn35_errMeanP;
    errStd = nn35_errStdP;
    chosen = 35;
    timem = t;
    netobj = problemFNN35.object;
end



problemFNN40.s = problemT.s;
problemFNN40.t = problemT.t;
problemFNN40.classifier.nNeuroni = [40];
problemFNN40.classifier.goal = 0.0000000002;
problemFNN40.classifier.epoche = 150;
problemFNN40.classifier.transferFcns = {'tansig','purelin'};
problemFNN40 = kfold_ffnn_NFTOOL(problemFNN40,KFOLD,mintt,maxtt,offsetN);
t = problemFNN40.time;
fprintf(fid,['** -- FNN-40 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN40.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN40.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN40.validation.stdErrorP) '\r\n']);
nn40_errMeanP = problemFNN40.validation.meanErrorP;
nn40_errStdP = problemFNN40.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn40_errMeanP) '\t' num2str(nn40_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN40.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN40.validation.stdErrorM) '\r\n']);
nn40_errMeanM = problemFNN40.validation.meanErrorM;
nn40_errStdM = problemFNN40.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn40_errMeanM) '\t' num2str(nn40_errStdM) '\r\n\r\n']);

if (problemFNN40.validation.meanErrorP < minNN)
    minNN = problemFNN40.validation.meanErrorP;
    errMean = nn40_errMeanP;
    errStd = nn40_errStdP;
    chosen = 40;
    timem = t;
    netobj = problemFNN40.object;
end




problemFNN45.s = problemT.s;
problemFNN45.t = problemT.t;
problemFNN45.classifier.nNeuroni = [45];
problemFNN45.classifier.goal = 0.0000000002;
problemFNN45.classifier.epoche = 150;
problemFNN45.classifier.transferFcns = {'tansig','purelin'};
problemFNN45 = kfold_ffnn_NFTOOL(problemFNN45,KFOLD,mintt,maxtt,offsetN);
t = problemFNN45.time;
fprintf(fid,['** -- FNN-45 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN45.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN45.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN45.validation.stdErrorP) '\r\n']);
nn45_errMeanP = problemFNN45.validation.meanErrorP;
nn45_errStdP = problemFNN45.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn45_errMeanP) '\t' num2str(nn45_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN45.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN45.validation.stdErrorM) '\r\n']);
nn45_errMeanM = problemFNN45.validation.meanErrorM;
nn45_errStdM = problemFNN45.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn45_errMeanM) '\t' num2str(nn45_errStdM) '\r\n\r\n']);

if (problemFNN45.validation.meanErrorP < minNN)
    minNN = problemFNN45.validation.meanErrorP;
    errMean = nn45_errMeanP;
    errStd = nn45_errStdP;
    chosen = 45;
    timem = t;
    netobj = problemFNN45.object;
end




problemFNN60.s = problemT.s;
problemFNN60.t = problemT.t;
problemFNN60.classifier.nNeuroni = [60];
problemFNN60.classifier.goal = 0.0000000002;
problemFNN60.classifier.epoche = 150;
problemFNN60.classifier.transferFcns = {'tansig','purelin'};
problemFNN60 = kfold_ffnn_NFTOOL(problemFNN60,KFOLD,mintt,maxtt,offsetN);
t = problemFNN60.time;
fprintf(fid,['** -- FNN-60 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN60.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN60.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN60.validation.stdErrorP) '\r\n']);
nn60_errMeanP = problemFNN60.validation.meanErrorP;
nn60_errStdP = problemFNN60.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn60_errMeanP) '\t' num2str(nn60_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN60.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN60.validation.stdErrorM) '\r\n']);
nn60_errMeanM = problemFNN60.validation.meanErrorM;
nn60_errStdM = problemFNN60.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn60_errMeanM) '\t' num2str(nn60_errStdM) '\r\n\r\n']);

if (problemFNN60.validation.meanErrorP < minNN)
    minNN = problemFNN60.validation.meanErrorP;
    errMean = nn60_errMeanP;
    errStd = nn60_errStdP;
    chosen = 60;
    timem = t;
    netobj = problemFNN60.object;
end



problemFNN80.s = problemT.s;
problemFNN80.t = problemT.t;
problemFNN80.classifier.nNeuroni = [80];
problemFNN80.classifier.goal = 0.0000000002;
problemFNN80.classifier.epoche = 150;
problemFNN80.classifier.transferFcns = {'tansig','purelin'};
problemFNN80 = kfold_ffnn_NFTOOL(problemFNN80,KFOLD,mintt,maxtt,offsetN);
t = problemFNN80.time;
fprintf(fid,['** -- FNN-80 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN80.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN80.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN80.validation.stdErrorP) '\r\n']);
nn80_errMeanP = problemFNN80.validation.meanErrorP;
nn80_errStdP = problemFNN80.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn80_errMeanP) '\t' num2str(nn80_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN80.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN80.validation.stdErrorM) '\r\n']);
nn80_errMeanM = problemFNN80.validation.meanErrorM;
nn80_errStdM = problemFNN80.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn80_errMeanM) '\t' num2str(nn80_errStdM) '\r\n\r\n']);

if (problemFNN80.validation.meanErrorP < minNN)
    minNN = problemFNN80.validation.meanErrorP;
    errMean = nn80_errMeanP;
    errStd = nn80_errStdP;
    chosen = 80;
    timem = t;
    netobj = problemFNN80.object;
end







problemFNN100.s = problemT.s;
problemFNN100.t = problemT.t;
problemFNN100.classifier.nNeuroni = [100];
problemFNN100.classifier.goal = 0.0000000002;
problemFNN100.classifier.epoche = 150;
problemFNN100.classifier.transferFcns = {'tansig','purelin'};
problemFNN100 = kfold_ffnn_NFTOOL(problemFNN100,KFOLD,mintt,maxtt,offsetN);
t = problemFNN100.time;
fprintf(fid,['** -- FNN-100 -- **\r\n']);
%fprintf(fid,['Mean MSE error: ' num2str(problemFNN100.validation.meanMseError) '\r\n']);
fprintf(fid,['Mean error (%%): ' num2str(problemFNN100.validation.meanErrorP) '\r\n']);
fprintf(fid,['Std error (%%): ' num2str(problemFNN100.validation.stdErrorP) '\r\n']);
nn100_errMeanP = problemFNN100.validation.meanErrorP;
nn100_errStdP = problemFNN100.validation.stdErrorP;
fprintf(fid,['\t' num2str(nn100_errMeanP) '\t' num2str(nn100_errStdP) '\r\n\r\n']);

fprintf(fid,['Mean error (mm3): ' num2str(problemFNN100.validation.meanErrorM) '\r\n']);
fprintf(fid,['Std error (mm3): ' num2str(problemFNN100.validation.stdErrorM) '\r\n']);
nn100_errMeanM = problemFNN100.validation.meanErrorM;
nn100_errStdM = problemFNN100.validation.stdErrorM;
fprintf(fid,['\t' num2str(nn100_errMeanM) '\t' num2str(nn100_errStdM) '\r\n\r\n']);

if (problemFNN100.validation.meanErrorP < minNN)
    minNN = problemFNN100.validation.meanErrorP;
    errMean = nn100_errMeanP;
    errStd = nn100_errStdP;
    chosen = 100;
    timem = t;
    netobj = problemFNN100.object;
end






%{
problemRBFNN100.s = problemT.s;
problemRBFNN100.t = problemT.t;
problemRBFNN100.classifier.nNeuroni = [300];
problemRBFNN100.classifier.goal = 0.0000000002;
problemRBFNN100.classifier.epoche = 150;
problemRBFNN100.classifier.spread = 40;
problemRBFNN100.classifier.transferFcns = {'tansig','purelin'};
problemRBFNN100 = kfold_rbfnn_NFTOOL(problemRBFNN100, ...
					10,problemRBFNN100.classifier.spread,problemRBFNN100.classifier.nNeuroni,10);
t = problemRBFNN100.time
fprintf(fid,['** -- RBFNN-100 -- **\r\n']);
fprintf(fid,['Mean error: ' num2str(problemRBFNN100.validation.meanError) '\r\n']);
fprintf(fid,['Std error: ' num2str(problemRBFNN100.validation.stdError) '\r\n']);
fprintf(fid,['Mean MSE error: ' num2str(problemRBFNN100.validation.meanMseError) '\r\n']);
rbfnn100_errMean = problemRBFNN100.validation.meanError;
rbfnn100_errStd = problemRBFNN100.validation.stdError;
fprintf(fid,['\t' num2str(rbfnn100_errMean) '\t'  num2str(rbfnn100_errStd) '\r\n\r\n']);

if (problemRBFNN100.validation.meanError < minNN);
minNN = problemRBFNN100.validation.meanError;
errMean = rbfnn100_errMean;
errStd = rbfnn100_errStd;
chosen = 'rbf100';
timem = t;
end,
%}



fprintf(fid,'\r\n\r\n');


%PRINT

fprintf(fid,'\r\n\r\n');
fprintf(fid,[num2str(errMean) ' ' num2str(errStd) '\r\n\r\n']);

fprintf(fid,['\r\nSample totali: ' num2str(size(problemT.s,2)) ...
    '\r\nChosen network topology: ' num2str(chosen) ...
    '\r\nTime for best NN validation: ' num2str(timem) ...
    '\r\nBest Mean Error:  ' num2str(errMean) ...
    '\r\nBest Std Error:  ' num2str(errStd) ...
    '\r\n\r\n']);

fprintf(1,['\r\nSample totali: ' num2str(size(problemT.s,2)) ...
    '\nChosen network topology: ' num2str(chosen) ...
    '\nTime for best NN validation: ' num2str(timem) ...
    '\nBest Mean Error:  ' num2str(errMean) ...
    '\nBest Std Error:  ' num2str(errStd) ...
    '\n\n']);

fclose(fid);

fprintf(1,'\r\n\r\n');



save([dirOut num2str(KFOLD) '_fold_DS_2012_01_10_best_NN.mat'], 'netobj', ['problemFNN' num2str(chosen)], 'minss', 'maxss', 'mintt', 'maxtt', 'offsetN');







