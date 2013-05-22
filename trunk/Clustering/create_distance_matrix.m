function [ D ] = create_distance_matrix( seq, segments, sigma )
%CREATE_DISTANCE_MATRIX 

D = zeros(length(segments), length(segments));
for i = 1:size(D,1)
    for j = i:size(D,2)
        s1 = segments{i};
        s2 = segments{j};
        
        D(i,j) = DTAK(seq(s1.start_idx:s1.end_idx,:), seq(s2.start_idx:s2.end_idx,:), sigma);
    end
end

D = triu(D) + triu(D,1)';