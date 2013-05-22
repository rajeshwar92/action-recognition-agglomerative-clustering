clear all; clc; close all;

% seq = [1 2 3 4 5 6 7 8 9 10 8 6 4 7 10 13 11 9 10 8 6 4 2 1]';
% clusters = cell(0);
% clusters{1} = cell(0);
% clusters{1}{1} = [10 8 6 4 2 1]';
% clusters{2} = cell(0);
% clusters{2}{1} = [4 7 10 13]';

disp('Creating random sequence...');
ncluster_mult = 1;
ndim = 1;
nclusters = 2;
clength = 10;
freq_noise = 0;
clen_noise = 0;
[seq, gt_segments, clusters] = senthesize_data(ndim, ncluster_mult, nclusters, clength, freq_noise, clen_noise);

props.minmax_idx = [6 12];
props.sigma = 1;

disp(['Clustering...']);
DTAKSearch_Rec(seq, clusters, props);