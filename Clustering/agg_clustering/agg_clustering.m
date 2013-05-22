function [ n_segments, clusters ] = agg_clustering( seq, segments, props )
%% AGG_CLUSTERING Agglomerative clustering
%
% props.threshold   Threshold when to stop clustering

% Algorithm:
%   - initialize C with each segments as a cluster
%   - compute distance matrix between each segment
%   - while clusters_merging
%       - foreach c in C
%           - find nearest c_near in C
%           - if dist(c_near, c) < threshold
%               - merge c_near into c, remove c_near

% compute distance matrix
D = create_distance_matrix(seq, segments, props.sigma);

% imagesc(D); colormap gray;

% initialize clusters
C = cell(0);
for i = 1:length(segments)
    C{i} = [i];
end

while true
    % foreach cluster
    %   find nearest cluster < threshold
    %   merge two clusters
    %   break; when no more merging occurs
    
    n_merge = 0;
    
    for i = 1:length(C)
        % only consider non-empty clusters
        if isempty(C{i})
            continue;
        end
        
        % find nearest cluster
        [c_near] = get_nearest_cluster(C, i, D, props.threshold);
        if c_near == -1
            continue;
        end
        
        % merge
        C{i} = [C{i} C{c_near}];
        C{c_near} = [];
        n_merge = n_merge + 1;
    end
    
    if (n_merge == 0)
        break;
    end
end

% assign cluster ids to segments
n_segments = segments;
clusters = cell(0);
c_idx = 0;
for i = 1:length(C)
    if isempty(C{i})
        continue;
    end
    
    c_idx = c_idx + 1;
    for p = 1:size(C{i},2)
        n_segments{C{i}(p)}.cluster_idx = c_idx;
    end
    clusters{c_idx} = C{i};
end


function [c_near] = get_nearest_cluster(C, c_idx, D, thresh)
%% GET_NEAREST_CLUSTER
%   Params
%      C cluster cell array of row vectors with segment index
%      c_idx index of the cluster
%      D distance matrix
%      thresh threshold of distance
%   Return
%       c_near the nearest cluster if below the threshold

m_dist = inf;
m_idx = -1;
c_near = -1;

for i = 1:length(C)
    if i == c_idx || isempty(C{i})
        continue;
    end
    d = get_distance(D, C{c_idx}, C{i});
    if d < m_dist
        m_dist = d;
        m_idx = i;
    end
end

if m_dist <= thresh
    c_near = m_idx;
end


function [dist] = get_distance(D, c1_idc, c2_idc, varargin)
%% GET_DISTANCE
%   Distance between two clusters for AVERGAE-Link AGG_C

if isempty(varargin)
    dtype = 'mlink';
else
    dtype = varargin{1};
end

idx = 1;
d = zeros(1,length(c1_idc)*length(c2_idc));
for i = 1:length(c1_idc)
    for j = 1:length(c2_idc)
%         d = d + D(c1_idc(i),c2_idc(j));
        d(idx) = D(c1_idc(i),c2_idc(j));
        idx = idx + 1;
    end
end

switch(dtype)
    case 'slink',
        dist = min(d);
    case 'clink',
        dist = max(d);
    case 'mlink',
        dist = sum(d) / length(d);
    otherwise,
        dist = -1;
        error('Unknown Metric');
end