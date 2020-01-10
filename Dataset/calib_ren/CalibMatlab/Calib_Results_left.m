% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 2132.866473889825600 ; 2129.223495026952600 ];

%-- Principal point:
cc = [ 665.568572155987000 ; 497.305707963324490 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.243865721706285 ; 0.348705875204772 ; -0.000327460434237 ; -0.001614333070929 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 19.606798770778784 ; 19.754403140862390 ];

%-- Principal point uncertainty:
cc_error = [ 21.300968525749393 ; 17.937419667474693 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.049584491836020 ; 0.815359873710177 ; 0.001662195745493 ; 0.001690160865944 ; 0.000000000000000 ];

%-- Image size:
nx = 1280;
ny = 960;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 15;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 1.361626e-002 ; -2.929108e+000 ; 3.019539e-002 ];
Tc_1  = [ 6.774075e+002 ; -3.860070e+002 ; 3.503693e+003 ];
omc_error_1 = [ 1.718127e-003 ; 1.194774e-002 ; 1.605315e-002 ];
Tc_error_1  = [ 3.525523e+001 ; 2.981824e+001 ; 3.430916e+001 ];

%-- Image #2:
omc_2 = [ -2.314225e-002 ; 3.002255e+000 ; -7.621763e-001 ];
Tc_2  = [ 5.773174e+002 ; -4.243784e+002 ; 3.783076e+003 ];
omc_error_2 = [ 4.380858e-003 ; 1.041089e-002 ; 1.413492e-002 ];
Tc_error_2  = [ 3.791334e+001 ; 3.207076e+001 ; 3.441145e+001 ];

%-- Image #3:
omc_3 = [ -1.593166e-003 ; 3.033664e+000 ; 6.685380e-001 ];
Tc_3  = [ 5.911327e+002 ; -3.064786e+002 ; 3.480625e+003 ];
omc_error_3 = [ 3.586430e-003 ; 1.091151e-002 ; 1.418057e-002 ];
Tc_error_3  = [ 3.482745e+001 ; 2.951524e+001 ; 3.424086e+001 ];

%-- Image #4:
omc_4 = [ -4.144754e-002 ; 2.779862e+000 ; -2.985122e-003 ];
Tc_4  = [ 3.998310e+002 ; -1.186465e+002 ; 3.655223e+003 ];
omc_error_4 = [ 2.340627e-003 ; 1.058009e-002 ; 1.335910e-002 ];
Tc_error_4  = [ 3.640944e+001 ; 3.081563e+001 ; 3.252906e+001 ];

%-- Image #5:
omc_5 = [ -2.264528e-002 ; 2.716914e+000 ; -3.617140e-001 ];
Tc_5  = [ 4.697238e+002 ; -1.759299e+002 ; 3.622013e+003 ];
omc_error_5 = [ 3.151880e-003 ; 1.010053e-002 ; 1.232561e-002 ];
Tc_error_5  = [ 3.611215e+001 ; 3.059447e+001 ; 3.146436e+001 ];

%-- Image #6:
omc_6 = [ 4.341964e-001 ; -2.798140e+000 ; 1.072912e-001 ];
Tc_6  = [ 2.376600e+002 ; -3.906908e+002 ; 3.354522e+003 ];
omc_error_6 = [ 2.908034e-003 ; 1.157290e-002 ; 1.385069e-002 ];
Tc_error_6  = [ 3.363130e+001 ; 2.818863e+001 ; 3.310739e+001 ];

%-- Image #7:
omc_7 = [ -1.055126e+000 ; 2.701179e+000 ; 3.414424e-001 ];
Tc_7  = [ 6.685897e+002 ; 7.272417e-001 ; 3.563696e+003 ];
omc_error_7 = [ 3.451033e-003 ; 1.046074e-002 ; 1.433859e-002 ];
Tc_error_7  = [ 3.564787e+001 ; 3.017151e+001 ; 3.295667e+001 ];

%-- Image #8:
omc_8 = [ 1.503054e+000 ; 2.461086e+000 ; -6.233510e-001 ];
Tc_8  = [ 1.648419e+002 ; -6.145137e+002 ; 3.610901e+003 ];
omc_error_8 = [ 4.205835e-003 ; 9.447236e-003 ; 1.437104e-002 ];
Tc_error_8  = [ 3.621625e+001 ; 3.052061e+001 ; 3.128749e+001 ];

%-- Image #9:
omc_9 = [ -1.956495e+000 ; -1.992729e+000 ; -4.901676e-001 ];
Tc_9  = [ -3.502216e+002 ; -4.993926e+002 ; 3.184665e+003 ];
omc_error_9 = [ 5.677912e-003 ; 7.840140e-003 ; 1.442125e-002 ];
Tc_error_9  = [ 3.197980e+001 ; 2.695430e+001 ; 3.179005e+001 ];

%-- Image #10:
omc_10 = [ 2.044150e+000 ; 1.926687e+000 ; 4.051085e-001 ];
Tc_10  = [ 1.233724e+002 ; -6.034454e+002 ; 3.506794e+003 ];
omc_error_10 = [ 8.787414e-003 ; 6.792229e-003 ; 1.494789e-002 ];
Tc_error_10  = [ 3.532313e+001 ; 2.952874e+001 ; 3.454260e+001 ];

%-- Image #11:
omc_11 = [ -2.706685e+000 ; -5.157624e-001 ; 1.193452e-001 ];
Tc_11  = [ -7.194239e+002 ; 2.739686e+002 ; 3.717584e+003 ];
omc_error_11 = [ 9.289763e-003 ; 3.448170e-003 ; 1.541884e-002 ];
Tc_error_11  = [ 3.728523e+001 ; 3.153355e+001 ; 3.390886e+001 ];

%-- Image #12:
omc_12 = [ 3.085756e+000 ; 1.198649e-001 ; 1.486081e-001 ];
Tc_12  = [ -3.641963e+002 ; 3.276131e+002 ; 3.465074e+003 ];
omc_error_12 = [ 1.218630e-002 ; 1.475780e-003 ; 1.963483e-002 ];
Tc_error_12  = [ 3.472063e+001 ; 2.920603e+001 ; 3.330686e+001 ];

%-- Image #13:
omc_13 = [ -6.112727e-001 ; 2.800010e+000 ; -5.349708e-001 ];
Tc_13  = [ 6.928026e+002 ; -1.694732e+002 ; 3.740005e+003 ];
omc_error_13 = [ 5.275153e-003 ; 1.002792e-002 ; 1.342126e-002 ];
Tc_error_13  = [ 3.746791e+001 ; 3.172648e+001 ; 3.386624e+001 ];

%-- Image #14:
omc_14 = [ 3.602467e-001 ; -3.064030e+000 ; 4.978892e-001 ];
Tc_14  = [ 3.584574e+002 ; -1.627441e+002 ; 3.672572e+003 ];
omc_error_14 = [ 1.963862e-003 ; 1.112191e-002 ; 1.534308e-002 ];
Tc_error_14  = [ 3.672696e+001 ; 3.086516e+001 ; 3.370368e+001 ];

%-- Image #15:
omc_15 = [ -9.908202e-003 ; 3.106879e+000 ; -1.208466e-002 ];
Tc_15  = [ 4.333055e+002 ; -3.611073e+002 ; 3.817698e+003 ];
omc_error_15 = [ 1.364768e-003 ; 1.467375e-002 ; 2.541232e-002 ];
Tc_error_15  = [ 3.821025e+001 ; 3.222581e+001 ; 3.652438e+001 ];

