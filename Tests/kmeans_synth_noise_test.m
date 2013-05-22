%TODO
%   more robust to noise (increasing range of search for temporal merge)
%   figure out a way to evaluate
%   different temporal distance measure
%       merge temporally close segments in close clusters, remaining are left in
%       a separate cluster

clear all; clc; close all;

% fns = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
fns = [0 0.01 0.02 0.05 0.1 0.15 0.2 0.3 0.4 0.5];

global dodisp;
dodisp = false;

avg_accs = zeros(1,length(fns));

for i = 1:length(fns)
    
    accs = zeros(1,10);
    for n = 1:10
        do_load = false;
        do_save = false;

        if do_load
            load(synth_name(data_file));
        else
            ncluster_mult = 5;
            ndim = 3;
            nclusters = 3;
            clength = 20;
            freq_noise = fns(i);
            clen_noise = 0;

            disp('Creating random sequence...');
            [seq, gt_segments, gt_clusters] = senthesize_data(ndim, ncluster_mult, nclusters, clength, freq_noise, clen_noise);

            if do_save
                c = clock;
                save(synth_name(c(3:5)), 'seq', 'gt_segments', 'gt_clusters', 'ndim', 'ncluster_mult', 'nclusters', 'clength', 'freq_noise', 'clen_noise');
            end
        end

        % threshold = compute_threshold(seq);

        props.minmax_idx = [int32(0.5*clength), int32(1.5*clength)];
        props.sigma = 1;
        props.max_itr = 10;
        props.threshold = 0.5;
        props.temporal_threshold = 0.7;
        props.init = 'pp';
        props.nclusters = length(gt_clusters);

        tic;

        disp('Segmentation & Clustering...');
        [ segments, clusters ] = kmeans_init(seq,props);
        
        time_spent = toc;
        disp(['Time ', num2str(time_spent), ' seconds']);

        disp('Aligning Clusters...');
        [segments, clusters] = align_clusters(gt_segments, gt_clusters, segments, clusters);

        disp('Evaluation...');
        [conf_matrix, accuracy] = evaluate_clustering(gt_segments, length(gt_clusters), segments, length(clusters));

        if dodisp
            disp('Displaying...');
            display_segments(segments, length(clusters), gt_segments, length(gt_clusters));
        end
        
        accs(n) = accuracy;
    end
    
    avg_accs(i) = median(accs);
end

plot(fns, avg_accs, '-rs', 'MarkerFaceColor','g');
axis([0 1 0 1]);
xlabel('Frequency Noise'); ylabel('Accuracy');