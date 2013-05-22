function [ seq, gt_segments, gt_clusters ] = senthesize_data( ndim, num_cluster_occ, num_clusters, avg_length, freq_noise, clen_noise )
%% SENTHESIZE_DATA constructs a random time sequence
%   ndim                dimensionality of point
%   num_cluster_occ     number of cluster occurances in data (length of data)
%   num_cluster         number of clusters (K)
%   avg_length          average length of the cluster mean
%   freq_noise          noise to add to cluster frequency
%   clen_noise          variation in cluster instance length in the sequence
% RETURNS
%   seq                 randomly created sequence
%   gt_segments         ground truth segments
%   gt_clusters         clusters (represents the mean)

max_range = 100;

gt_clusters = cell([num_clusters,1]);
for i = 1:num_clusters
    gt_clusters{i} = cell(0);
    gt_clusters{i}{1} = rand(randi([int32(0.75*avg_length), int32(1.25*avg_length)], [1 1]),ndim) * max_range;
end

seq = [];
gt_segments = cell(0);
for i = 1:num_cluster_occ*num_clusters
    cn = randi([1,num_clusters], [1 1]);
    
    t_clenn = 1+(randi([-1 1], [1 1])*clen_noise);
    scluster = stretch_sequence_length(gt_clusters{cn}{1}, t_clenn);
    
    gt_segments{i}.cluster_idx = cn;
    gt_segments{i}.start_idx = size(seq,1);
    gt_segments{i}.end_idx = gt_segments{i}.start_idx + size(scluster,1);
    
%     seq = [seq; (rand(size(scluster,1),ndim)*freq_noise + scluster)];
    seq = [seq; (0.01*randi([-100*freq_noise 100*freq_noise], [size(scluster,1),ndim]).*scluster + scluster)];
end