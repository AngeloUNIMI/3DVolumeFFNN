% clc
close all
clear variables

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
dirCalib = [dirBase 'calib_ren\'];
homof = [dirCalib 'Homos\Homos.mat'];

%RESULTS
dirResultsBase = '../Results/';
dirSaveDs = [dirResultsBase '\dataset\'];
dirSavePc = [dirResultsBase '\pc\'];

%params
thEp = 5;
thCorr = 0.8;

nPunti = 300;
stepP = 10;
thCanny = 0.1;

%load calibration
load(homof);
run([dirCalib 'infoDataset.m']);
load([dirCalib 'CalibMatlab\Calib_Results_left.mat']);
load([dirCalib 'CalibMatlab\Calib_Results_right.mat']);
load([dirCalib 'CalibMatlab\Calib_Results_stereo.mat']);
load([dirCalib 'CalibMatlab\Calib_data_left.mat']);
load([dirCalib 'CalibMatlab\Calib_data_right.mat']);
load([dirCalib 'CalibMatlab\puntiL.mat']);
load([dirCalib 'CalibMatlab\puntiR.mat']);

%loop on dirs
dirs = dir(dirFilesBase);
dirs(1) = [];
dirs(1) = [];

%loop on objects
for dd = 1 : numel(dirs)
    
    dirFiles = [dirFilesBase dirs(dd).name '\'];
    object = dirs(dd).name;
    mkdir_pers([dirSavePc object], savefile);
    mkdir_pers([dirSaveDs object], savefile);
    
    %object
    fprintf(1, ['Object: ' object '\n']);
    
    filesAB = dir([dirFiles '*.bmp']);
    
    puntiLtot = [];
    puntiRtot = [];
    
    for gg2 = 1 : size(puntiL, 3)
        puntiLtot = [puntiLtot; puntiL(:,:,gg2)];
        puntiRtot = [puntiRtot; puntiR(:,:,gg2)];
    end %for gg2
    
    [F, inliers] = ransacfitfundmatrix(puntiLtot', puntiRtot', 0.08);
    %homografia del piano
    Hp = vgg_H_from_x_lin(puntiL(:,:,15)',puntiR(:,:,15)');
    %Hp = H3;
    
    %data initialization
    pcs = [];
    
    n_img = 0;
    gg_pc = 1;
    %loop on files
    %for gg = 1 : 2 : numel(filesAB)
    for gg = 1
        
        n_img = n_img + 1;
        
        if showMode
            close all
            clc
            pause(2)
        end %if show
        
        fileA = [dirFiles filesAB(gg).name]; %'
        fileB = [dirFiles filesAB(gg+1).name]; %'
        fprintf(1, ['\tFile A: ' filesAB(gg).name '\n']);
        fprintf(1, ['\tFile B: ' filesAB(gg+1).name '\n']);
        
        %A e B
        imA = imread(fileA);
        imB = imread(fileB);
        
        
        %-------------------------------------------------------------------IMMAGINE A
        imAgray = im2uint8(rgb2gray( normalizzaMat(imA)));
        imA = im2uint8(normalizzaMat(imA));
        
        
        %segmentation
        [maskA,maskAe] = segOggetti2(imA,imAgray);
        
        %edge
        edgeA = edge(imAgray,'canny',thCanny);
        
        
        
        
        %-----------------------------------
        %estr punti
        CCCL = pointExtract(maskA, edgeA, stepP, nPunti);
        
        
        
        
        %-------------------------------------------------------------------IMMAGINE B
        imBgray = im2uint8(rgb2gray( normalizzaMat(imB)));
        imB = im2uint8(normalizzaMat(imB));
        
        
        
        %segmentation
        [maskB,maskBe] = segOggetti2(imB,imBgray);
        
        %edge
        edgeB = edge(imBgray,'canny',thCanny);
        
        
        if showMode
            hm1 = figure; imshow(maskA),
            hm2 = figure; imshow(imA),
            hold on, scatter(CCCL(:,1),CCCL(:,2)), hold off
            hm3 = figure; imshow(maskB),
            hm4 = figure; imshow(imB),
            pause
            close(hm1),
            close(hm2),
            close(hm3),
            close(hm4)
            pause(1)
        end
        
        
        
        
        %---------------------------------------------------------PREFILTERING
        [I1r, I1g, I1b, I1gray, I2r, I2g, I2b, I2gray] = preFilter(imA, imB);
        
        
        
        %------------------------------------------------------------------MATCH CORNERS
        [CCCLr, CCCLm] = matchCorners(CCCL, I1r, I1g, I1b, I1gray, I2r, I2g, I2b, I2gray, maskA, maskB, edgeA, edgeB, H3, F, thEp, thCorr);
        
         
        if showMode
            figure,
            imshow(imAgray), hold on, plot(CCCLr(:,1),CCCLr(:,2),'xr','MarkerSize',8,'LineWidth',2);
            title('A')
            figure,
            imshow(imBgray), hold on, plot(CCCLm(:,1),CCCLm(:,2),'xr','MarkerSize',8,'LineWidth',2);
            title('B')
            pause(2)
        end
        
        
        %whos CCCLr CCCLm
        %pause(2)
        
        
        %CCCLrf = CCCLr;
        %CCCLmf = CCCLm;
        
        
        %-----------------------------------
        %Spike filtering
        [CCCLrf, CCCLmf, CCCL3r, CCCL3m, errorS] = spikefilter2d(CCCLr, CCCLm, maskAe, maskBe, Hp);
        
        %check
        if errorS == -1
            continue
        end %if errorS
        
        
           
        %-----------------------------------
        %3d volume
        [XLff, YLff, ZLff, XLp, YLp, ZLp, XLp2, YLp2, ZLp2, XL, YL, ZL] = D_3d_L(imA, CCCLr, CCCLm, CCCLrf, CCCLmf, CCCL3r, CCCL3m, dx, ...
            om,T,fc_left, cc_left, kc_left, alpha_c_left, fc_right, cc_right, kc_right, alpha_c_right, ...
            fileA, [dirSaveDs object], showMode, savefile);
        %pause
        
        
        %Conv hull and volume
        %[K,v] = convhull_fun(XLff,YLff,ZLff);
        
        %triangulation and volume
        [tri,v,area] = delaunay_fun([XLff XLp]',[YLff YLp]',[ZLff ZLp]', showMode);
        
        %point cloud save
        pcs{gg_pc}.X = XL;
        pcs{gg_pc}.Xp = XLp2;
        pcs{gg_pc}.Y = YL;
        pcs{gg_pc}.Yp = YLp2;
        pcs{gg_pc}.Z = ZL;
        pcs{gg_pc}.Zp = ZLp2;
        gg_pc = gg_pc + 1;
        
        %pause
        pause(1)
        close all
        pause(0.1);
        
        
    end %end for gg
    
    %display
    fprintf(1, '\n');
    
    
    
    %salvataggio
    n_sample = numel(pcs);
    save([dirSavePc '\' object '\point_clouds_red_3d.mat'], 'pcs', 'n_sample');
    
       
end %end for dd





