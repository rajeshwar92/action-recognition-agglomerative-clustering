
function [D] = get_distance_matrix_temporal(clusters)
%% GET_DISTANCE_MATRIX_TEMPORAL
% Returns a matrix of the temporal distances between the clusters

D = zeros(length(clusters));
for i = 1:length(clusters)
    for j = 1:length(clusters)
        if i == j
            D(i,j) = inf;
            continue;
        end
        D(i,j) = get_distance_temporal(clusters{i}, clusters{j});
    end
end
