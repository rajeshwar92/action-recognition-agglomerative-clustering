function [ warp_path, cost, error, slope ] = DTWsubsequence( seq, subseq, steps, threshold, temporal_weight )
%DTWSUBSEQUENCE aligns the given subsequence to 

cost_matrix = getCostMatrix(subseq,seq);

accum_cost_matrix = initialize_accum_cost_matrix(cost_matrix);
for m = 2:size(accum_cost_matrix,1)
    for n = 2:size(accum_cost_matrix,2)
        % get minimum distance to add to accumulated matrix
        minidx = -1;
        minval = inf;
        for i = 1:size(steps,1)
            m_idx = max(m-steps(i,1),0);
            n_idx = max(n-steps(i,2),0);
            if m_idx == 0 || n_idx == 0
                continue;
            end
            val = accum_cost_matrix(m_idx,n_idx);
            if val < minval
                minval = val;
                minidx = i;
            end
        end
        accum_cost_matrix(m,n) = cost_matrix(m,n) + minval;
    end
end

[warp_path, cost] = getMinWarpPath(accum_cost_matrix, steps, threshold, true);
error = compute_error(subseq, seq, warp_path, temporal_weight);
slope = (warp_path(size(warp_path,1),1)-warp_path(1,1)) / (warp_path(size(warp_path,1),2)-warp_path(1,2));

cost = cost * slope;

global dodisp;
if dodisp == true
    displayDTW(cost_matrix, accum_cost_matrix, warp_path);
    
    if cost == inf
        disp('No optimal warp path exists');
    else
        disp(['Cost: ', num2str(cost), '; Slope: ', num2str(slope)]);
    end
end

% initiliaze the accumulated cost matrix
% first row is same as cost matrix
% first column is sum previous elements in the column
function accum_cost_matrix = initialize_accum_cost_matrix(cost_matrix)
accum_cost_matrix = zeros(size(cost_matrix));
for i = 1:size(cost_matrix,2)
    accum_cost_matrix(1,i) = cost_matrix(1,i); %sum(cost_matrix(1,1:i));
end

for i = 1:size(cost_matrix,1)
    accum_cost_matrix(i,1) = sum(cost_matrix(1:i,1)); %cost_matrix(i,1);
end

% computes the error between the two sequences
%  taking into account the spatial and temporal shift
function error = compute_error(seq1, seq2, warp_path, temporal_weight)
error = 0;
for i = 1 : size(warp_path,1)
    error = error + (getPoseDistance(seq1(warp_path(i,1),:), seq2(warp_path(i,2),:))^2 + (temporal_weight*((warp_path(i,1)-warp_path(1,1))-(warp_path(i,2)-warp_path(1,2)))));
end
error = error / size(warp_path,1);