% clc
clear all
close all
%warning('off')

showMode = 0;
savefile = 1;

addpath(genpath('../functions'));
addpath(genpath('../Kovesi'));
addpath(genpath('../vgg_multiview'));
addpath(genpath('../Camera Calibration Toolbox'));
addpath(genpath('../util'));

%DIRECTORIES
dirBase = '../Dataset/';
dirFilesBase = [dirBase 'objects\'];

%RESULTS
dirResultsBase = '../Results/';
dirSavePc = [dirResultsBase '\pc\'];
dirSaveDs = [dirResultsBase '\dataset\'];

dirs = dir(dirFilesBase);
dirs(1) = [];
dirs(1) = [];


%loop on objects
for dd = 1: numel(dirs)
    
    object = dirs(dd).name;
    fprintf(1, ['Object: ' object '\n']);
    fprintf(1, '\t');
    
    
    %DIRECTORIES
    filePc{1} = [dirSavePc object '\point_clouds_red_3d.mat'];
    fileVolume{1} = [dirFilesBase object '\volume.mat'];
    fileSaveDs{1} = [dirSaveDs object '\ds_red_3d.mat'];
    mkdir_pers([dirSaveDs object], savefile);
    
    for vvv = 1 : numel(filePc)
        
        load(filePc{vvv})
        load(fileVolume{vvv})
        
        n_pcs = numel(pcs);
        
        problem.s = [];
        problem.t = [];
        
        for gg = 1 : n_pcs
            
            close all
            
            if (mod(gg,10) == 0)
                fprintf(1, [num2str(gg) ' ']);
            end
            
            %for gg=[1]
            
            XLff = pcs{gg}.X;
            YLff = pcs{gg}.Y;
            ZLff = pcs{gg}.Z;
            XLp = pcs{gg}.Xp;
            YLp = pcs{gg}.Yp;
            ZLp = pcs{gg}.Zp;
            
            
            %feature extraction
            problem_sample = extrFeatures3d([XLff XLp], [YLff YLp], [ZLff' ZLp], numel(XLp), v, showMode);
            
            problem.s = [problem.s problem_sample.s];
            problem.t = [problem.t problem_sample.t];
            
        end %end for gg
        
        
        
        %salvataggio
        n_sample = size(problem.s,2);
        save(fileSaveDs{vvv}, 'problem', 'n_sample');
        
        
        
    end %end for vvv
    
    fprintf(1, '\n\n');
    
    
    
    
end %end for dd


