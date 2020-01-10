clc
close all
clear variables

%Source code for the paper:
%R. Donida Labati, A. Genovese, V. Piuri and F. Scotti, 
%"Low-cost volume estimation by two-view acquisitions: A computational intelligence approach," 
%The 2012 International Joint Conference on Neural Networks (IJCNN), Brisbane, QLD, 2012, pp. 1-8.
%doi: 10.1109/IJCNN.2012.6252515

%STEP 1: 
%Compute the 3D point cloud
fprintf(1, '----Compute the 3D point cloud----\n');
run('./steps/launch_A_computePointCloud.m');

%STEP 2: 
%Extract features from 3D data
fprintf(1, '----Extract features from 3D data----\n');
run('./steps/launch_B_extractFeatures.m');

%STEP 3: 
%Train Neural Network with N-fold validation
fprintf(1, '----Train Neural Network with N-fold validation----\n');
%a - box shaped
fprintf(1, '----a - box shaped\n');
run('./steps/launch_Ca_N_fold_boxShaped.m');
%b - cylinder shaped
fprintf(1, '----b - cylinder shaped\n');
run('./steps/launch_Cb_N_fold_cylinderShaped.m');
%c - sphere shaped
fprintf(1, '----c - sphere shaped\n');
run('./steps/launch_Cc_N_fold_sphereShaped.m');