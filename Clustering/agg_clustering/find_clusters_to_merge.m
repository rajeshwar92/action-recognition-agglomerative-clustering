function [to_merge] = find_clusters_to_merge(clusters, thresh)
%% FIND_CLUSTERS_TO_MERGE
% Finds reciprocal nearest neighbouring clusters, and returns clusters to
% be merged

% D = get_distance_matrix_temporal(clusters);

% to_merge = [];
to_merge = cell(0);
% find clusters that are close temporally
for i = 1:length(clusters)
    if isempty(clusters{i})
        continue;
    end
    
    % reciprocal nearest neighbour cluster
    c1_near = get_nearest_cluster_temporal(clusters, i, thresh);
    if isempty(c1_near)
        continue;
    end
    
    % weighted selection of nn (higher weight to nn with less nn)
    pr = zeros([1,length(c1_near)]);
    for c1_i = 1:length(c1_near)
        c1i_near = get_nearest_cluster_temporal(clusters, c1_near(c1_i), thresh);
        [lia,locb] = ismember(i, c1i_near);
        if lia == 1
            pr(c1_i) = (1/length(c1i_near));
        end
    end
    
    [mv,mi] = max(pr);
    if mv == 0
        % ignore, no matches
        continue;
    else
        % add to merge, update clusters
        to_merge{length(to_merge)+1} = [i c1_near(mi)];
        clusters{i} = [];
        clusters{c1_near(mi)} = [];
    end
    
%     c2_near = get_nearest_cluster_temporal(clusters, c1_near(1), thresh);
%     if isempty(c2_near)
%         continue;
%     end
%     
%     if c2_near(1) == i
%         to_merge{length(to_merge)+1} = [i c1_near(1)];
%         clusters{i} = [];
%         clusters{c1_near(1)} = [];
%     end
end

% figure; imagesc(D); colormap gray;
% celldisp(to_merge);
