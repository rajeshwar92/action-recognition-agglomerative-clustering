function [c_near] = get_nearest_cluster_temporal(clusters, c_idx, thresh)
%%
%

min_d = inf;
min_idx = -1;

ds = zeros(1,length(clusters));

for i = 1:length(clusters)
    if i == c_idx || isempty(clusters{i})
        ds(i) = inf;
        continue;
    end
    
    d = get_distance_temporal(clusters{i}, clusters{c_idx});
    ds(i) = d;
    if d < min_d
        min_d = d;
        min_idx = i;
    end
end

c_near = [];
% c_near = -1;
if min_d <= thresh
    for i = 1:length(ds)
        if ds(i) == min_d
            c_near = [c_near i];
        end
    end
%     c_near = min_idx;
end



