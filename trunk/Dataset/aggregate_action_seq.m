function [ seq, gt_segments ] = aggregate_action_seq( action_seqs, nsamples )
%% AGGREGATE_SEQUENCES
%
%

gt_segments = cell(0);
seq = [];

ind = 1;
for c = 1:length(action_seqs)
    for i = 1:min(nsamples,length(action_seqs{c}))
        
        seg = action_seqs{c}{i};
        
        gt_segments{ind}.cluster_idx = c;
        gt_segments{ind}.start_idx = size(seq,1);
        gt_segments{ind}.end_idx = gt_segments{ind}.start_idx + size(seg,1);
        
        seq = [seq; seg];
        
        ind = ind + 1;
    end
end