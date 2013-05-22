function [ n_segments, clusters ] = agg_clustering_temporal( seq, props )
%% AGG_CLUSTERING_TEMPORAL Dynamic segmentation and agglomerative clustering
%
% - Initial segmentation to length 2 per segment
% - while clusters_temporal_merging
%   - Perform agglomerative clustering
%   - Merge temporally close clusters < temporal_threshold


segments = segment_sequence(seq, [2 2]);

[segments, clusters] = agg_clustering(seq, segments, props);
n_segments = segments;

curr_itr = 0;
n_merges = -1;

while n_merges ~= 0 && curr_itr < 100
    [n_segments, ~, n_merges] = merge_clusters_temporal(n_segments, clusters, props);
    
    [n_segments, clusters] = agg_clustering(seq, n_segments, props);
    
    curr_itr = curr_itr + 1;
end

[n_segments, ~] = cleanup(n_segments, props.minmax_idx);
[n_segments, clusters] = agg_clustering(seq, n_segments, props);



function [n_segments, clusters, n_merges] = merge_clusters_temporal(segments, clusters, props)
%%
%

%
% to_merge = [];
% ind = 1;
% n_clusters = cell(0);
% 
% % find clusters that are close temporally
% for i = 1:length(clusters)
%     if isempty(clusters{i})
%         continue;
%     end
%     
%     % reciprocal nearest neighbour cluster
%     c1_near = get_nearest_cluster_temporal(clusters, i, props.temporal_threshold);
%     if isempty(c1_near)
%         continue;
%     end
%     
%     c2_near = get_nearest_cluster_temporal(clusters, c1_near(1), props.temporal_threshold);
%     if isempty(c2_near)
%         continue;
%     end
%     
%     if c2_near(1) == i
%         to_merge = [to_merge; i c1_near(1); c1_near(1) i];
%         n_clusters{ind} = [clusters{i} clusters{c1_near(1)}];
%         clusters{i} = [];
%         clusters{c1_near(1)} = [];
%     end
% end
% clusters = n_clusters;
% 
% nc_merge = size(to_merge,1);
% if nc_merge == 0
%     n_merges = 0;
%     n_segments = segments;
%     return;
% end
% 
% % to_merge
% 
% n_merges = 0;
% 
% % merge segments of corresponding clusters
% n_segments = cell(0);
% i = 1;
% while i <= length(segments)
%     s = segments{i};
%     [lia,locb] = ismember(s.cluster_idx, to_merge(:,1));
%     if lia == 0
%         n_segments{length(n_segments)+1} = s;
%         i = i + 1;
%         continue;
%     end
%     
%     if i < length(segments) && segments{i+1}.cluster_idx == to_merge(locb,2)
%         %TODO search and merge multiple segments ahead (instead of 1)
%         if segments{i+1}.end_idx - s.start_idx < props.minmax_idx(2)
%             n_seg.start_idx = s.start_idx;
%             n_seg.end_idx = segments{i+1}.end_idx;
%             n_seg.cluster_idx = s.cluster_idx;
%             n_segments{length(n_segments)+1} = n_seg;
%             n_merges = n_merges + 1;
%             i = i + 2;
%         else
%             n_segments{length(n_segments)+1} = s;
%             i = i + 1;
%         end
%     else
%         n_segments{length(n_segments)+1} = s;
%         i = i + 1;
%     end
% end

[to_merge] = find_clusters_to_merge(clusters, props.temporal_threshold);

n_merges = 0;
n_segments = segments;
for i = 1:length(to_merge)
    [n_segments, t_merges] = merge_clusters(n_segments, to_merge{i}, props.minmax_idx);
    n_merges = n_merges + t_merges;
end

[n_segments, clusters] = get_clusters_from_segments(n_segments);
