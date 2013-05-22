function new_sequence = DTW(seq1, seq2, steps)
% DTW warps the two sequences to align them
% 2 sequences of action seq1, seq2
%   size is 60xN where 60 is (x,y,z)*20joints, and N is the number of poses
%

% steps = [0 1; 1 0; 1 1];

cost_matrix = getCostMatrix(seq1,seq2);

% construct the accumulated cost matrix iteratively
accum_cost_matrix = zeros(size(cost_matrix));
accum_cost_matrix(1,1) = cost_matrix(1,1);
for m = 1:size(accum_cost_matrix,1)
    for n = 1:size(accum_cost_matrix,2)
        if m == 1 && n == 1
            continue;
        end
        
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

[warp_path, cost] = getMinWarpPath(accum_cost_matrix, steps, inf, false);

displayDTW(cost_matrix, accum_cost_matrix, warp_path);
if cost == inf
    disp('No optimal warp path exists');
    return;
end