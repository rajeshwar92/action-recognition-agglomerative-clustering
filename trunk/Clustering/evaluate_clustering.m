function [conf_matrix, accuracy] = evaluate_clustering( gt_segments, gt_nclusters, c_segments, c_nclusters )
%% EVALUATE
%
%   Computes the correspondence between the two resulting clusters
%   Computes the number of frames of overlap between the two cluster

% compute set of cluster correspondence

conf_matrix = compute_segments_confusion_matrix(gt_segments, gt_nclusters, c_segments, c_nclusters);

accuracy = sum(diag(conf_matrix)) / sum(conf_matrix(:));

global dodisp;
if dodisp == true
    figure;
    imagesc(conf_matrix); title('Confusion Matrix');
    colormap gray;
end
