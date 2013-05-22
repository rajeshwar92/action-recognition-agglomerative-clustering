function [ cluster_means ] = kmeanspp_initialization( seq, segments, props )

cluster_means = cell([props.nclusters, 1]);

% add first mean
s_idx = randi([1,length(segments)], [1 1]);
tmp_s = segments{s_idx};
cluster_means{1} = cell(0);
cluster_means{1}{1} = seq(tmp_s.start_idx:tmp_s.end_idx, :);

% if only one mean required, add and exit
if props.nclusters == 1
    return;
end

% add remaining means
mean_dist = inf(length(segments), props.nclusters-1);
for c = 2:props.nclusters
    % compute distance from last mean to current point
    for s = 1:length(segments)
        tmp_s = segments{s};
        mean_dist(s,c-1) = DTAK(seq(tmp_s.start_idx:tmp_s.end_idx,:), cluster_means{c-1}{1}, props.sigma);
    end
    
    % weighted random sampling
    s_idx = randsample(length(segments), 1, true, min(mean_dist,[],2));
    tmp_s = segments{s_idx};
    cluster_means{c} = cell(0);
    cluster_means{c}{1} = seq(tmp_s.start_idx:tmp_s.end_idx,:);
end

% disp('------');