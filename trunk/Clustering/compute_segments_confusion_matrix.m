function [ conf_matrix ] = compute_segments_confusion_matrix( c1_segments, c1_nclusters, c2_segments, c2_nclusters )
%% COMPUTE_SEGMENTS_CONFUSION_MATRIX confusion matrix based on frames
%

conf_matrix = zeros(c1_nclusters, c2_nclusters);
for i = 1:size(conf_matrix, 1)
    for j = 1:size(conf_matrix, 2)
        conf_matrix(i,j) = get_overlap_clusters(c1_segments, i, c2_segments, j);
    end
end


function n_frames = get_overlap_clusters(c1_seg, c1_idx, c2_seg, c2_idx)
%% GET_OVERLAP computes the number of frames that overlap between two clusters
%

n_frames = 0;
for i = 1:length(c1_seg)
    if c1_seg{i}.cluster_idx ~= c1_idx
        continue;
    end
    
    for j = 1:length(c2_seg)
        if c2_seg{j}.cluster_idx ~= c2_idx
            continue;
        end
        
        n_frames = n_frames + get_overlap_segments(c1_seg{i}, c2_seg{j});
    end
end


function n_frames = get_overlap_segments(seg1, seg2)
%% GET_OVERLAP computes the number of frames that overlap between two segments
%

n_frames = 0;
for i = seg1.start_idx:seg1.end_idx
    if i >= seg2.start_idx && i <= seg2.end_idx
        n_frames = n_frames + 1;
    end
end
