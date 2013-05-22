
% TODO tests
%       real data
%       same set of clusters (but vary the noise)
%       added noisy frames
%       added noise to the data
%       varying length of sequences

clear all;clc;close all;

global dodisp;
dodisp = true;

% n_tests = 10;
% total_acc = zeros(1,n_tests);
% total_time = zeros(1,n_tests);
% total_gt_segments = cell([n_tests,1]);
% total_res_segments = cell([n_tests,1]);
% for i = 1:n_tests

%     ncluster_mult = 10;
%     ndim = 16;
%     nclusters = 5;
%     clength = 20;
%     freq_noise = 0;
%     clen_noise = 0;
% 
%     disp('Creating random sequence...');
%     [seq, gt_segments, gt_clusters] = senthesize_data(ndim, ncluster_mult, nclusters, clength, freq_noise, clen_noise);
    
    load(synth_name([13 0 16]));

    props.minmax_idx = [int32(0.75*clength), int32(1.25*clength)];
    props.sigma = 1;
    props.nclusters = length(gt_clusters);
    props.max_itr = 10;
    props.init = 'pp';
  
    tic;
    
    disp('Segmentation & Clustering...');
    [ segments, clusters ] = kmeans_init(seq,props);
    
    time_spent = toc;
    disp(['Time ', num2str(time_spent), ' seconds']);
    
    disp('Aligning Clusters...');
    [segments, clusters] = align_clusters(gt_segments, gt_clusters, segments, clusters);

    disp('Evaluation...');
    [conf_matrix, accuracy] = evaluate_clustering(gt_segments, length(gt_clusters), segments, length(clusters));
    
    if dodisp
        disp('Displaying...');
        display_segments(segments, props.nclusters, gt_segments, length(gt_clusters));
    end
    
%     total_acc(i) = accuracy;
%     total_time(i) = time_spent;
%     total_gt_segments{i} = gt_segments;
%     total_res_segments{i} = segments;
% end
% 
% disp(['Average Accuracy: ' num2str(mean(total_acc))]);
% disp(['Median Accuracy: ' num2str(median(total_acc))]);
% disp(['Average Time: ' num2str(mean(total_time))]);