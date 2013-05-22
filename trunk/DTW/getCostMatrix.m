function cost_matrix = getCostMatrix( seq1, seq2 )
%GETCOSTMATRIX
% seq1 on the y-axis (rows)
% seq2 on the x-axis (columns)

cost_matrix = zeros(size(seq1,1),size(seq2,1));

for m = 1 : size(seq1,1)
    for n = 1 : size(seq2,1)
        cost_matrix(m,n) = getPoseDistance(seq1(m,:),seq2(n,:));
    end
end