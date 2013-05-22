function [ corr_12, corr_21 ] = get_cluster_correspondence( c_1, c_2, sigma )
%% GET_CLUSTER_CORRESPONDENCE computes the correspondence between each cluster
%   c_1 cell array of cell arrays of length 1; contains mean vector
%   c_2 (as above)
%
% Returns
%   size(c_1,1) vector; element is matching element from other set

dist_matrix = zeros(size(c_1,1), size(c_2,1));

for i = 1:size(dist_matrix,1)
    for j = 1:size(dist_matrix,2)
        dist_matrix(i,j) = DTAK(c_1{i}{1},c_2{j}{1}, sigma);
    end
end

[~,corr_12] = min(dist_matrix, [], 2);
[~,corr_21] = sort(corr_12);

global dodisp;
if dodisp == true
    figure;
    imagesc(dist_matrix); title('Cluster Correspondence');
    colormap gray;
end
