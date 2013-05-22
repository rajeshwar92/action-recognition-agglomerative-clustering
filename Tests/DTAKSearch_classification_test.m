% TEST  when start/end of sequence is random noise
%       when noisy frames are inserted in sequence
%       when random sequence is inserted mid-frames
% TEST  on action sequences
%       when multiple cluster entries (no mean)
% INVESTIGATE use of kernel k-means
% INVESTIGATE use of agglomerative clustering

clear all; clc; close all;

fns = [0 0.1 0.2 0.3 0.4 0.5];
accs = zeros(1,length(fns));

global dodisp;
dodisp = false;

for f = 1:length(fns)
    t_accs = zeros(1,10);
    for i = 1:10
        
        disp('Creating random sequence');
        ncluster_mult = 3;
        ndim = 16;
        clength = 10;
        nclusters = 5;
        freq_noise = 0.01;
        clen_noise = fns(f);
        [seq, gt_segments, clusters] = senthesize_data(ndim, ncluster_mult, nclusters, clength, freq_noise, clen_noise);
        
        props.minmax_idx = [int32(0.75*clength), int32(1.25*clength)];
        props.sigma = 1;
        props.nclusters = nclusters;
        
        disp('Performing search...');
        segments = DTAKSearch_Itr(seq, clusters, props);
        
        disp('Evaluation...');
        [conf_matrix, accuracy] = evaluate_clustering(gt_segments, props.nclusters, segments, props.nclusters);
        
        t_accs(i) = accuracy;
    end
    accs(f) = median(t_accs);
end

plot(fns, accs, '-rs', 'MarkerFaceColor','g');
axis([0 1 0 1]);
ylabel('Accuracy'); xlabel('Length Multiplier');

% display_segments(segments, nclusters, gt_segments, nclusters);