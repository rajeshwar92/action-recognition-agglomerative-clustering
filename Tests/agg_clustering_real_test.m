clear all;clc;close all;

% thresholds = [  0.05 0.09 0.11 0.13 0.15...
%                 0.17 0.19 0.21 0.23 0.25...
%                 0.3 0.35 0.4 0.45 0.5 0.55...
%                 0.6 0.65 0.7 0.75 0.8 0.85...
%                 0.9 0.95];
thresholds = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
moc_tags = 1:14;

ttype = 't';

global dodisp;
dodisp = false;

for ith = 1:length(thresholds)

    for i = 1:length(moc_tags)

        moc_tag = moc_tags(i);
        [seq, gt_segments, gt_clusters, minmax_len] = convert_cmu_data(moc_tag, true);
        
        props.minmax_idx = minmax_len;
        props.sigma = 1;
        props.max_itr = 100;
%         props.threshold = thresholds(ith);
        props.threshold = 0.15;
%         props.temporal_threshold = 0.3;
        props.temporal_threshold = thresholds(ith);

        tic;

        disp('Segmentation & Clustering...');
        [segments, clusters] = agg_clustering_temporal(seq,props);
        
        time_spent = toc;
        disp(['Time ', num2str(time_spent), ' seconds']);

        disp('Aligning Clusters...');
        [segments, clusters] = align_clusters(gt_segments, gt_clusters, segments, clusters);

        disp('Evaluation...');
        [conf_matrix, accuracy] = evaluate_clustering(gt_segments, length(gt_clusters), segments, length(clusters));
        
        save(['Dataset/CMU_MOC_Cache/MOC_',num2str(moc_tag),'_res_',ttype,num2str(thresholds(ith)),'.mat'], 'segments', 'clusters', 'conf_matrix', 'accuracy', 'time_spent', 'gt_segments', 'gt_clusters', 'props');
    end
end