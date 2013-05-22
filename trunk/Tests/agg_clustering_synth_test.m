%TODO
%   more robust to noise (increasing range of search for temporal merge)
%   figure out a way to evaluate
%   different temporal distance measure
%       merge temporally close segments in close clusters, remaining are left in
%       a separate cluster

clear all; clc; close all;

do_load = true;
data_file = [13 0 16];

% do_load = false;
% do_save = false;

if do_load
    load(synth_name(data_file));
else
    ncluster_mult = 5;
    ndim = 3;
    nclusters = 3;
    clength = 20;
    freq_noise = 0;
    clen_noise = 0;

    disp('Creating random sequence...');
    [seq, gt_segments, gt_clusters] = senthesize_data(ndim, ncluster_mult, nclusters, clength, freq_noise, clen_noise);
    
    if do_save
        c = clock;
        save(synth_name(c(3:5)), 'seq', 'gt_segments', 'gt_clusters', 'ndim', 'ncluster_mult', 'nclusters', 'clength', 'freq_noise', 'clen_noise');
    end
end

% threshold = compute_threshold(seq);

props.minmax_idx = [int32(0.5*clength), int32(1.5*clength)];
props.sigma = 1;
props.max_itr = 100;
props.algo = 'agg';
props.threshold = 0.5;
props.temporal_threshold = 0.7;

global dodisp;
dodisp = true;

tic;

disp('Segmentation & Clustering...');
% segments = segment_sequence(seq, props.minmax_idx);
% [segments, clusters] = agg_clustering(seq,segments,props);
[segments, clusters] = agg_clustering_temporal(seq,props);

time_spent = toc;
disp(['Time ', num2str(time_spent), ' seconds']);

if dodisp
    disp('Displaying...');
    display_segments(segments, length(clusters), gt_segments, length(gt_clusters));
end

disp('Aligning Clusters...');
[segments, clusters] = align_clusters(gt_segments, gt_clusters, segments, clusters);

disp('Evaluation...');
[conf_matrix, accuracy] = evaluate_clustering(gt_segments, length(gt_clusters), segments, length(clusters));

if dodisp
    disp('Displaying...');
    display_segments(segments, length(clusters), gt_segments, length(gt_clusters));
end
