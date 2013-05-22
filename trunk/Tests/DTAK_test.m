clear all;close all;clc;

% v1 = [1 2 1 2]';
% v2 = [1 1 2 2]';
% 
% DTAK(v1, v2, eps);

global datasetpath;
datasetpath = './Dataset/MSRAction3DSkeletonReal3D/';

global dodisp;
dodisp = true;

tr1 = DatasetReader(2, true);
tr2 = DatasetReader(2, true);

DTAK(tr1{1}, tr2{2}, 1);