clear all; clc; close all;

global datasetpath;
datasetpath = './Dataset/MSRAction3DSkeletonReal3D/';

global steps;
steps = [1 0; 0 1; 1 1; 2 1; 1 2; 2 2];

global threshold;
threshold = inf;

global dodisp;
dodisp = false;

actionid = 1:4;
trained_seq = cell(actionid(length(actionid)),1);
testing_seq = cell(actionid(length(actionid)),1);
for i = 1 : length(actionid)
    trained_seq{i} = DatasetReader(actionid(i), true);
    testing_seq{i} = DatasetReader(actionid(i), false);
end

total_n = 0;
% rows for true class, columns for resulting class
conf_matrix = zeros(actionid(length(actionid)),actionid(length(actionid)));
for c = 1 : length(actionid)
    for i = 1 : length(testing_seq{c})
        [mincostidx, mincost] = DTWClassifier(testing_seq{c}{i},trained_seq);
        conf_matrix(actionid(c),mincostidx) = conf_matrix(actionid(c),mincostidx) + 1;
        disp(['Classified action [', num2str(c), ',', num2str(i), '] as ', num2str(mincostidx)]);
        total_n = total_n + 1;
    end
    conf_matrix(actionid(c),:) = conf_matrix(actionid(c),:) / sum(conf_matrix(actionid(c),:));
end

imagesc(conf_matrix);
colormap gray;

disp(['Accuracy ' num2str(sum(diag(conf_matrix))/(sum(conf_matrix(:))))]);