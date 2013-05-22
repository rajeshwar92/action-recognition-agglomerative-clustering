function [warp_path, cost] = getMinWarpPath( accum_cost_matrix, steps, thresh, subseq )
%GETMINWARPPATH 
% ACCUM_COST_MATRIX accumulated cost matrix of the the two sequences
% THRESH threshold of the accumulative cost to consider
% SUBSEQ whether to look for a subsequence or warp entire sequence

% steps = [1 0; 0 1; 1 1];

[srt srtidx] = sort(accum_cost_matrix(size(accum_cost_matrix,1),:));

warp_path = [];
cost = inf;

if srt(1) > thresh
    return;
end

if subseq == true
%     if srtidx(1) < steps(2,:)
%         return;
%     end
    new_point = [size(accum_cost_matrix,1) srtidx(1)];
else
    new_point = size(accum_cost_matrix);
end

warp_path = new_point;

while   (subseq == true && new_point(1) ~= 1) || ...
        (subseq == false && new_point(1) ~= 1 && new_point(2) ~= 1)
    minval = inf;
    minidx = -1;
    for s = 1:size(steps,1)
        m_idx = max(new_point(1)-steps(s,1),0);
        n_idx = max(new_point(2)-steps(s,2),0);
        if m_idx == 0 || n_idx == 0
            continue;
        end
        val = accum_cost_matrix(m_idx,n_idx);
        if val < minval
            minval = val;
            minidx = s;
        end
    end
    new_point = new_point-steps(minidx,:);
    warp_path = [new_point; warp_path];
end

% normalize path
cost = srt(1) / size(warp_path,1);