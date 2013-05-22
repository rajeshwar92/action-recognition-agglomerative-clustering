function [seq, gt_segments, gt_clusters, minmax_len] = convert_cmu_data(tag, compr)
%% CONVERT_DATA
% Converts ACA data structures for CMU MoCap Ground Truth data

global footpath;
footpath = [cd '/Dataset/CMU_MOC'];
filename = [footpath, '_Cache/MOC_', num2str(tag), '.mat'];
res = fopen(filename);
if res == -1
    % read data
    data_source = mocSegSrc(tag);
    gt_data = mocSegData(data_source);
    
    save(filename, 'data_source', 'gt_data');
else
    fclose(res);
    load(filename);
end

if compr
    seq = gt_data.X';
    tmp_seg = gt_data.segT;
else
    seq = gt_data.X0';
    tmp_seg = gt_data.segT0;
end

gt_segments = cell(0);
minmax_len = [data_source.para.nMi data_source.para.nMa];

% convert
for i = 1:length(tmp_seg.s)-1
    gt_segments{i}.start_idx = tmp_seg.s(i);
    if i == length(tmp_seg.s)
        gt_segments{i}.end_idx = size(seq,1);
    else
        gt_segments{i}.end_idx = tmp_seg.s(i+1)-1;
    end
    gt_segments{i}.cluster_idx = [1:size(tmp_seg.G,1)] * tmp_seg.G(:,i);
end

[gt_segments, gt_clusters] = get_clusters_from_segments(gt_segments);