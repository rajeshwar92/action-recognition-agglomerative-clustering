function [dist] = get_distance_temporal(c1_idc, c2_idc)
%% GET_DISTANCE_TEMPORAL
%
% define cluster_1 smaller cluster, cluster_2 larger cluster
% for each segment in cluster_1
%   find closest segments in cluster_2 [-2 2]
%   if found
%       add normalized difference (abs(diff)/2)
%       add total_found
% normalize difference/total_found
%

% c1_idc = sort(c1_idc);
% c2_idc = sort(c2_idc);
% 
% dist = DTAK(c1_idc', c2_idc', 1);

total_d = 0;
total_n = 0;

d_thresh = 2;

% smaller cluster is used
if length(c1_idc) > length(c2_idc)
    t = c1_idc;
    c1_idc = c2_idc;
    c2_idc = t;
end

for i1 = 1:length(c1_idc)
    c1_v = c1_idc(i1);
    
    min_d = inf;
    for i2 = 1:length(c2_idc)
        c2_v = c2_idc(i2);
        
        d = abs(c1_v-c2_v)-1;
        if d < min_d
            min_d = d;
        end
    end
    
    if min_d <= d_thresh
        total_d = total_d + (min_d / d_thresh);
        total_n = total_n + 1;
    end
end

if total_n == 0
    dist = inf;
else
    dist = total_d / total_n;
end
