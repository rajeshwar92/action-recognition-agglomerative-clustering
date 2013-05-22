function [ i_segments ] = segment_sequence( seq, minmax_len )
%SEGMENT_SEQUENCE Segments the sequence randomly given the min and max segment
%lengths

i_segments = cell(0);
n_segments = 1;

rand('twister', sum(100 * clock));

% random segmentation of the sequence
start_idx = 1;
end_idx = randi([minmax_len(1), minmax_len(2)], [1 1]);
while true
    i_segments{n_segments}.start_idx = start_idx;
    i_segments{n_segments}.end_idx = end_idx;

    start_idx = end_idx + 1;
    end_idx = min(size(seq,1), start_idx+randi([minmax_len(1) minmax_len(2)], [1 1]));

    if end_idx - start_idx < minmax_len
        i_segments{n_segments}.end_idx = end_idx;
        break;
    else
        n_segments = n_segments + 1;
    end
end