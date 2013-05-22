function [ segments, clusters ] = kmeans_init( seq, props )
%% INITIALIZE_SEGMENTS
%   Randomly segment the sequence
%   Perform K-Means on the segments and group into clusters
%   Return cluster means and segments
%

minerr = inf;
n_itr = 1;

while true
    i_segments = segment_sequence(seq, props.minmax_idx);
    
    % perform clustering on segments
    % kmeans
    [t_segments, t_clusters, err] = kmeans_clustering(seq, i_segments, props);
    
    if err == inf
        disp('Empty cluster, re-initializing...');
    else
        % update if less error
        n_itr = n_itr + 1;
        if err < minerr
            minerr = err;
            segments = t_segments;
            clusters = t_clusters;
        end
        
        % break when max. number of iterations is reached
        if n_itr > props.max_itr
            break;
        end
    end
end