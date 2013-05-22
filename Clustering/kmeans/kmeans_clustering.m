function [n_segments, clusters, err] = kmeans_clustering(seq, segments, props)
%% KMEAN_CLUSTERING
% performs K-Means on the segments, and returns cluster means, and segment
% cluster assignment
%  - create initial random seeds (selected from the segments)
%  - refine mean for a number of iterations
%  - *TODO* modify end condition based on mean change
% 
%   seq         time sequence
%   segments    initial segments
%   props       holds .nclusters for the number of required cluster K

if strcmp(props.init, 'rand')

    % initial cluster means
    % uniform random sampling
    cluster_means = cell([props.nclusters, 1]);
    idc = unique(randi(length(segments), [1 2*props.nclusters]));
    idc = idc(1:props.nclusters);
    for i = 1:props.nclusters
        r_s = segments{idc(i)};
        cluster_means{i}{1} = seq(r_s.start_idx:r_s.end_idx,:);
    end
elseif strcmp(props.init, 'pp')
    % initialization using k-means-pp
    cluster_means = kmeanspp_initialization(seq, segments, props);
else
    error('Unsupported Initialization algorithm');
end

n_itr = 1;
while true
    
    % for each cluster (cell array of clusters), holds a matrix of segment
    % and its distance to the mean
    c_means_idx = cell([props.nclusters, 1]);

    % update clusters based on means
    for i = 1:length(segments)
        [cluster_idx, cluster_sim] = get_nearest_cluster(seq(segments{i}.start_idx:segments{i}.end_idx,:), cluster_means, props.sigma);
        c_means_idx{cluster_idx} = [c_means_idx{cluster_idx}; i cluster_sim];
    end
    
    % update last cluster means
    last_cmeans = cluster_means;
    
    % compute new means from clusters
    for i = 1:length(cluster_means)
        cluster_means{i}{1} = get_cluster_mean(c_means_idx{i}, segments, seq);
    end
    
    % break if means have not changed
    if ~has_means_changed(cluster_means, last_cmeans, props) || n_itr > props.max_itr
        break;
    end
    
    n_itr = n_itr + 1;
end

% assign each segment their cluster id
for i = 1:length(cluster_means)
    for idx = 1:size(c_means_idx{i},1)
        segments{c_means_idx{i}(idx,1)}.cluster_idx = i;
    end
end

n_segments = segments;

% check if there any empty cluster
if has_empty_cluster(c_means_idx) == true
    err = inf;
else
    % compute error of current cluster
    % sum of distances
    err = 0;
    for i = 1:length(c_means_idx)
        err = err + sum(c_means_idx{i}(:,2));
    end
end

clusters = cell([length(cluster_means) 1]);
for i = 1:length(n_segments)
    clusters{n_segments{i}.cluster_idx} = [clusters{n_segments{i}.cluster_idx} i];
end

function avg_segment = get_cluster_mean(c_idx, segments, seq)
%% CLUSTER_AVG returns a segment which is closest to the true mean
%

if isempty(c_idx)
    s = segments{randi([1,length(segments)], [1,1])};
    avg_segment = seq(s.start_idx:s.end_idx,:);
    return;
end

% get average distance
c_avg = 0;
for i = 1:size(c_idx,1)
%     c_sum = c_sum + seq(segments{i}.start_idx:segments{i}.end_idx,:);
    c_avg = c_avg + c_idx(i,2);
end
c_avg = c_avg / length(c_idx);

% mean is picked as the closest to average distance from the existing
% segments
min_idx = c_idx(1,1);
min_dist = c_idx(1,2);
for i = 2:size(c_idx,1)
    d = abs(c_idx(i,2)-c_avg);
    if d <= min_dist
        min_dist = d;
        min_idx = c_idx(i,1);
    end
end

avg_segment = seq(segments{min_idx}.start_idx:segments{min_idx}.end_idx, :);

function is_empty = has_empty_cluster(c_idx)
%% IS_CLUSTER_EMPTY checks whether an empty cluster exists
%

is_empty = false;
for i = 1:length(c_idx)
    if isempty(c_idx{i})
        is_empty = true;
    end
end


function mean_changed = has_means_changed(c_means, last_cmeans, props)
%% HAS_MEANS_CHANGED Returns true if the means locations have changed since last update
%

mean_changed = false;

for i = 1:length(c_means)
    cost = DTAK(c_means{i}{1}, last_cmeans{i}{1}, props.sigma);
    if cost > eps
        mean_changed = true;
    end
end