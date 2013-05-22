clear all; clc; close all;

global dodisp;
dodisp = false;

moc_tags = 1:14;

for i = 1:length(moc_tags)

    moc_tag = moc_tags(i);
    [seq, gt_segments, gt_clusters, minmax_len] = convert_cmu_data(moc_tag, true);

    props.minmax_idx = minmax_len;
    props.sigma = 1;
    props.nclusters = length(gt_clusters);
    props.max_itr = 10;

    tic;

    disp('Segmentation & Clustering...');
    [segments, clusters] = kmeans_init(seq,props);

    time_spent = toc;
    disp(['Time ', num2str(time_spent), ' seconds']);
    
    disp('Aligning Clusters...');
    [segments, clusters] = align_clusters(gt_segments, gt_clusters, segments, clusters);

    disp('Evaluation...');
    [conf_matrix, accuracy] = evaluate_clustering(gt_segments, length(gt_clusters), segments, length(clusters));
    
    save(['Dataset/CMU_MOC_Cache/MOC_',num2str(moc_tag),'_kres_',num2str(props.nclusters),'.mat'], 'segments', 'clusters', 'conf_matrix', 'accuracy', 'time_spent', 'gt_segments', 'gt_clusters', 'props');
    
%     disp('Displaying...');
%     display_segments(segments, props.nclusters, gt_segments, length(gt_clusters));
end