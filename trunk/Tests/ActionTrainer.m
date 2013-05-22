clear all; clc; close all;

global datasetpath;
datasetpath = './Dataset/MSRAction3DSkeletonReal3D/';

global steps;
steps = [1 0; 0 1; 2 1; 1 2; 1 1];

global threshold;
threshold = inf;

global dodisp;
dodisp = true;

training_actions = DatasetReader(1, true);
testing_actions = DatasetReader(1,false);

% [warp_path, cost, error, slope ] = DTWsubsequence(testing_actions{25}, training_actions{1}, steps, inf, 1);

dist = DTAK(training_actions{1}, testing_actions{1}, 1);