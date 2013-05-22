function segments = DTAKSearch_Itr( seq, clusters, props )
%% DTAKSEARCH finds clusters within sequence
%  seq          sequence to search in
%  clusters     sequences to search for
%  props        properties of search
%                .sigma         to use for kernel
%                .minmax_idx    minimum and maximum length
%                .threshold     threshold to consider in cluster
%
% segments      list of found segments
%                .start_idx     start index of segment
%                .end_idx       end index of segment
%                .cluster       closest cluster
%                .sim           distance to cluster

segments = cell(1);
n_segments = 0;
start_idx = 1;
end_idx = props.minmax_idx(2);

while end_idx < size(seq,1)
    [cluster_idx, end_idx, sim] = segment_sequence(start_idx, seq, clusters, props);
    if sim == -1
        continue;
    end
    
    n_segments = n_segments + 1;
    segments{n_segments}.start_idx = start_idx;
    segments{n_segments}.end_idx = end_idx;
    segments{n_segments}.cluster_idx = cluster_idx;
    segments{n_segments}.sim = sim;
    
    start_idx = end_idx;
end

function [cluster_idx, end_idx, sim] = segment_sequence(start_idx, seq, clusters, props)
%%
%

cluster_idx = -1;
end_idx = -1;
sim = inf;

for i = min(size(seq,1),start_idx+props.minmax_idx(1)):min(size(seq,1),start_idx+props.minmax_idx(2))
    if i < 1 || i > size(seq,1)
        break;
    end
    
    [c_cidx, cluster_sim] = get_nearest_cluster(seq(start_idx:i,:), clusters, props.sigma);
    
    if cluster_sim < sim
        sim = cluster_sim;
        end_idx = i;
        cluster_idx = c_cidx;
    end
end