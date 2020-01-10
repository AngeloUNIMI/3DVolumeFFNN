% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 2126.062175635687700 ; 2122.782407217271200 ];

%-- Principal point:
cc = [ 676.123193085442150 ; 488.574567642684090 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.216327823346552 ; -0.246484251188196 ; -0.000450161977236 ; 0.001199492772531 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 19.154621557043331 ; 19.275833784009013 ];

%-- Principal point uncertainty:
cc_error = [ 21.018859338802052 ; 17.691529672932305 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.044868810762199 ; 0.667330359495892 ; 0.001575488170601 ; 0.001633624357324 ; 0.000000000000000 ];

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
omc_1 = [ 5.115378e-003 ; -2.794929e+000 ; 3.219811e-002 ];
Tc_1  = [ 5.335384e+002 ; -3.659970e+002 ; 3.452323e+003 ];
omc_error_1 = [ 2.277903e-003 ; 1.046122e-002 ; 1.320513e-002 ];
Tc_error_1  = [ 3.436130e+001 ; 2.890276e+001 ; 3.298461e+001 ];

%-- Image #2:
omc_2 = [ 6.555687e-002 ; -2.956310e+000 ; 7.588406e-001 ];
Tc_2  = [ 4.712870e+002 ; -4.018497e+002 ; 3.742013e+003 ];
omc_error_2 = [ 3.964665e-003 ; 1.071664e-002 ; 1.337432e-002 ];
Tc_error_2  = [ 3.708029e+001 ; 3.124439e+001 ; 3.301330e+001 ];

%-- Image #3:
omc_3 = [ -5.159536e-002 ; -2.975294e+000 ; -6.430117e-001 ];
Tc_3  = [ 4.447019e+002 ; -2.862636e+002 ; 3.442860e+003 ];
omc_error_3 = [ 3.427981e-003 ; 1.042472e-002 ; 1.385692e-002 ];
Tc_error_3  = [ 3.408498e+001 ; 2.876239e+001 ; 3.295584e+001 ];

%-- Image #4:
omc_4 = [ -3.721230e-002 ; 2.913833e+000 ; -7.436788e-003 ];
Tc_4  = [ 2.805593e+002 ; -9.587104e+001 ; 3.638801e+003 ];
omc_error_4 = [ 1.758745e-003 ; 1.169740e-002 ; 1.557811e-002 ];
Tc_error_4  = [ 3.588359e+001 ; 3.028500e+001 ; 3.160900e+001 ];

%-- Image #5:
omc_5 = [ -4.334248e-002 ; 2.852447e+000 ; -3.809621e-001 ];
Tc_5  = [ 3.443550e+002 ; -1.540228e+002 ; 3.596288e+003 ];
omc_error_5 = [ 2.505022e-003 ; 1.018820e-002 ; 1.295396e-002 ];
Tc_error_5  = [ 3.547077e+001 ; 2.989084e+001 ; 3.028453e+001 ];

%-- Image #6:
omc_6 = [ 4.154925e-001 ; -2.668511e+000 ; 8.047762e-002 ];
Tc_6  = [ 7.770715e+001 ; -3.689283e+002 ; 3.365784e+003 ];
omc_error_6 = [ 3.664919e-003 ; 1.106244e-002 ; 1.280059e-002 ];
Tc_error_6  = [ 3.338901e+001 ; 2.793863e+001 ; 3.237732e+001 ];

%-- Image #7:
omc_7 = [ -1.061973e+000 ; 2.825230e+000 ; 4.184836e-001 ];
Tc_7  = [ 5.343796e+002 ; 2.111803e+001 ; 3.510251e+003 ];
omc_error_7 = [ 2.555857e-003 ; 1.052368e-002 ; 1.507492e-002 ];
Tc_error_7  = [ 3.477284e+001 ; 2.925869e+001 ; 3.146257e+001 ];

%-- Image #8:
omc_8 = [ 1.513562e+000 ; 2.553572e+000 ; -7.577586e-001 ];
Tc_8  = [ 3.804594e+001 ; -5.909455e+002 ; 3.631174e+003 ];
omc_error_8 = [ 3.207443e-003 ; 9.405488e-003 ; 1.469493e-002 ];
Tc_error_8  = [ 3.599819e+001 ; 3.031670e+001 ; 3.092113e+001 ];

%-- Image #9:
omc_9 = [ -1.943223e+000 ; -1.905815e+000 ; -3.430547e-001 ];
Tc_9  = [ -5.296073e+002 ; -4.745457e+002 ; 3.272486e+003 ];
omc_error_9 = [ 6.397400e-003 ; 7.530798e-003 ; 1.356681e-002 ];
Tc_error_9  = [ 3.246527e+001 ; 2.746772e+001 ; 3.235253e+001 ];

%-- Image #10:
omc_10 = [ 2.121474e+000 ; 1.993840e+000 ; 2.667832e-001 ];
Tc_10  = [ -1.594884e+001 ; -5.799156e+002 ; 3.531677e+003 ];
omc_error_10 = [ 8.741074e-003 ; 7.114853e-003 ; 1.626678e-002 ];
Tc_error_10  = [ 3.513401e+001 ; 2.938336e+001 ; 3.391739e+001 ];

%-- Image #11:
omc_11 = [ -2.681414e+000 ; -4.674208e-001 ; 3.010254e-001 ];
Tc_11  = [ -8.184783e+002 ; 3.037494e+002 ; 3.849014e+003 ];
omc_error_11 = [ 9.284242e-003 ; 3.662177e-003 ; 1.470403e-002 ];
Tc_error_11  = [ 3.826710e+001 ; 3.244168e+001 ; 3.469434e+001 ];

%-- Image #12:
omc_12 = [ 3.081764e+000 ; 1.167354e-001 ; -6.768976e-002 ];
Tc_12  = [ -5.004593e+002 ; 3.535167e+002 ; 3.552145e+003 ];
omc_error_12 = [ 1.373112e-002 ; 1.359200e-003 ; 1.982089e-002 ];
Tc_error_12  = [ 3.520467e+001 ; 2.971842e+001 ; 3.329809e+001 ];

%-- Image #13:
omc_13 = [ -6.628641e-001 ; 2.926957e+000 ; -5.226540e-001 ];
Tc_13  = [ 5.815643e+002 ; -1.487485e+002 ; 3.681499e+003 ];
omc_error_13 = [ 5.073007e-003 ; 1.002210e-002 ; 1.401560e-002 ];
Tc_error_13  = [ 3.645680e+001 ; 3.071856e+001 ; 3.225972e+001 ];

%-- Image #14:
omc_14 = [ 3.687548e-001 ; -2.931544e+000 ; 4.678874e-001 ];
Tc_14  = [ 2.415851e+002 ; -1.396311e+002 ; 3.658984e+003 ];
omc_error_14 = [ 2.374665e-003 ; 1.121447e-002 ; 1.442510e-002 ];
Tc_error_14  = [ 3.620115e+001 ; 3.036870e+001 ; 3.267450e+001 ];

%-- Image #15:
omc_15 = [ 1.844529e-003 ; -3.037466e+000 ; 2.903494e-002 ];
Tc_15  = [ 3.342541e+002 ; -3.379264e+002 ; 3.794096e+003 ];
omc_error_15 = [ 1.591604e-003 ; 1.307308e-002 ; 1.927224e-002 ];
Tc_error_15  = [ 3.758166e+001 ; 3.162216e+001 ; 3.558029e+001 ];

