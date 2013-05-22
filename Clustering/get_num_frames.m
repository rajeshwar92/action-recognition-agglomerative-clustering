function [num_frames] = get_num_frames(segments, c_idx)
%% GET_NUM_FRAMES
% Returns the number of frames belonging to a cluster

num_frames = 0;
for i = 1:length(segments)
    if segments{i}.cluster_idx ~= c_idx
        continue;
    end
    num_frames = num_frames + (segments{i}.end_idx-segments{i}.start_idx) + 1;
end