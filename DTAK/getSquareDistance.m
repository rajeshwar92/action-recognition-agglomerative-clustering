function dist = getSquareDistance(seq1, seq2)
%%
% seq1 sequence 1
% seq2 sequence 2

dist = zeros(size(seq1,1), size(seq2,1));
for i = 1:size(dist,1)
    for j = 1:size(dist,2)
%         dist(i,j) = abs(seq1(i,:)-seq2(j,:));
        dist(i,j) = sqMagnitude(seq1(i,:)-seq2(j,:));
    end
end
% dist = dist.^2;


function mag = sqMagnitude(vec)
%%
% vec       vector

mag = sum(vec.^2);