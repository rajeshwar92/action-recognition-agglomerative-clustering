function [segments, new_clusters] = get_clusters_from_segments(segments)
%% GET_NEW_CLUSTERS
% Determine new clusters from the segments' cluster_idx

% infer clusters from segments
tmp_clusters = cell(0);
for i = 1:length(segments)
    c_idx = segments{i}.cluster_idx;
    if c_idx > length(tmp_clusters)
        t = [];
    else
        t = tmp_clusters{c_idx};
    end
    tmp_clusters{c_idx} = [t i];
end

% remove empty clusters
idx = 1;
new_clusters = cell(0);
for i = 1:length(tmp_clusters)
    if ~isempty(tmp_clusters)
        new_clusters{idx} = tmp_clusters{i};
        
        for s = 1:length(new_clusters{idx})
            segments{new_clusters{idx}(s)}.cluster_idx = idx;
        end
        
        idx = idx + 1;
    end
end


