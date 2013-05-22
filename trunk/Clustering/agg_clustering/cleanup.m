function [ new_segments, new_clusters ] = cleanup( segments, minmax_len )
%% CLEANUP Removes small segments
%

new_segments = cell(0);
idx = 1;
i = 1;
while i <= length(segments)
    
    s = segments{i};
    
    if segment_length(s) >= minmax_len(1)
        new_segments{length(new_segments)+1} = s;
        i = i+1;
        continue;
    end
    
    merge_next = false;
    merge_last = false;
    
    if i == 1
        merge_next = true;
    elseif i == length(segments)
        merge_last = true;
    else
        if segment_length(segments{i+1}) > segment_length(segments{i-1})
            merge_last = true;
        else
            merge_next = true;
        end
    end
    
    if merge_next
        new_ns.start_idx = s.start_idx;
        new_ns.end_idx = segments{i+1}.end_idx;
        new_ns.cluster_idx = segments{i+1}.cluster_idx;
        new_segments{length(new_segments)+1} = new_ns;
        i = i+1;
    end
    
    if merge_last
        new_ls.start_idx = new_segments{length(new_segments)}.start_idx;
        new_ls.end_idx = s.end_idx;
        new_ls.cluster_idx = new_segments{length(new_segments)}.cluster_idx;
        new_segments{length(new_segments)} = new_ls;
    end
    
    i = i+1;
end

[new_segments, new_clusters] = get_clusters_from_segments(new_segments);

function [len] = segment_length(seg)
%% SEGMENT_LENGTH
%
len = (seg.end_idx-seg.start_idx)+1;