clear all; clc; close all;

global datasetpath;
datasetpath = './Dataset/MSRAction3DSkeletonReal3D/';

global steps;
steps = [1 0; 0 1; 2 1; 1 2; 1 1];

global threshold;
threshold = inf;

global dodisp;
dodisp = true;

training_actions = DatasetReader(3, true);

DisplayAction(training_actions{1},5,true);