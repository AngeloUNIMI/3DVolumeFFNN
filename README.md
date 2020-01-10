# 3D Volume Estimation FFNN

Matlab source code for the paper:

	R. Donida Labati, A. Genovese, V. Piuri and F. Scotti, 
    "Low-cost volume estimation by two-view acquisitions: A computational intelligence approach," 
    The 2012 International Joint Conference on Neural Networks (IJCNN), Brisbane, QLD, Australia, 2012, pp. 1-8.
    doi: 10.1109/IJCNN.2012.6252515
    https://ieeexplore.ieee.org/document/6252515
	
Project page:

http://iebil.di.unimi.it/projects/volume

Outline:

<img src="http://iebil.di.unimi.it/images/volume.jpg" width="500">

Citation:

    @INPROCEEDINGS{6252515,
    author={R. {Donida Labati} and A. {Genovese} and V. {Piuri} and F. {Scotti}},
    booktitle={The 2012 International Joint Conference on Neural Networks (IJCNN)},
    title={Low-cost volume estimation by two-view acquisitions: A computational intelligence approach},
    year={2012},
    pages={1-8},
    doi={10.1109/IJCNN.2012.6252515},
    ISSN={2161-4393},
    month={June},}

Main files:

    - launch_all.m: main file

Required files:

    - ./Dataset: 
    Database of two-view images    
    The structure of the folders must be:
    "./Dataset/calib_ren/"
    "./Dataset/objects/cubo1/0001_0001_A.bmp"
    "./Dataset/objects/cubo1/0001_0001_B.bmp"
    etc.

Part of the code uses the functions by Peter Kovesi:

	Peter Kovesi, 
	"MATLAB and Octave Functions for Computer Vision and Image Processing", 
	https://www.peterkovesi.com/matlabfns/
    
The MATLAB Functions for Multiple View Geometry:

    David Capel, Andrew Fitzgibbon, Peter Kovesi, Tomas Werner, Yoni Wexler, and Andrew Zisserman
    "MATLAB Functions for Multiple View Geometry"
    https://www.robots.ox.ac.uk/~vgg/hzbook/code/
    
The Camera Calibration Toolbox for Matlab:

    Jean-Yves Bouguet,
    "Camera Calibration Toolbox for Matlab"
    http://www.vision.caltech.edu/bouguetj/calib_doc/
    
The Matlab function for despiking by Nobuhito Mori:

    Nobuhito Mori,
    "Despiking"
    https://it.mathworks.com/matlabcentral/fileexchange/15361-despiking
    
The Matlab function for Minimum Volume Enclosing Ellipsoid by Nima Moshtagh:

    Nima Moshtagh,
    "Minimum Volume Enclosing Ellipsoid"
    https://it.mathworks.com/matlabcentral/fileexchange/9542-minimum-volume-enclosing-ellipsoid
	