function [cluster_idx, cluster_sim] = get_nearest_cluster(seq, clusters, sigma)
%% GET_NEAREST_CLUSTER
% 
%  Returns
%       cluster_idx     index of nearest cluster
%       cluster_sim     distance

% cluster_sim = -1;
cluster_sim = inf;
cluster_idx = -1;

for i = 1:length(clusters)
    sim = getAvgDTAKsim(clusters{i}, seq, sigma);
    if sim < cluster_sim
        cluster_sim = sim;
        cluster_idx = i;
    end
end