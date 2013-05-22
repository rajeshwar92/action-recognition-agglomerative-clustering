clear all;clc;

segments = cell(0);

nc = 5;
clusters = cell([1,nc]);

st = 1;
for i = 1:10
    s.start_idx = st;
    s.end_idx = st+10;
    s.cluster_idx = rem(i,nc)+1;
    st = st + 11;
    segments{i} = s;
    clusters{s.cluster_idx} = [clusters{s.cluster_idx} i];
end

[nsegments, nmerges] = merge_clusters(segments, [2 3 4], [2 35]);