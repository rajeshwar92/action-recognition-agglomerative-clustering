function cost = DTAK( seq1, seq2, sigma )
%% DTAK
%   Return 0 if similar, 1 if not similar

steps = [1 0; 0 1; 1 1];
stepc = [1 1 2];

rsize = size(seq1,1);
csize = size(seq2,1);

cost_matrix = zeros(rsize, csize);

D = getSquareDistance(seq1,seq2);
K = computeKernel(D,sigma);

for i = 1:rsize
    for j = 1:csize
        mmax = 0;
        for s = 1:size(steps,1)
            ii = max(0,i-steps(s,1));
            jj = max(0,j-steps(s,2));
            v = K(i,j);
            if ii == 0 || jj == 0
                v = stepc(s) * v;
            else
                v = (stepc(s) * v) + cost_matrix(ii,jj);
            end
            
            if v > mmax
                mmax = v;
            end
        end
        
        cost_matrix(i,j) = mmax;
    end
end

cost = 1 - cost_matrix(size(cost_matrix,1), size(cost_matrix,2)) / sum(size(cost_matrix));

% global dodisp;
% if dodisp == true
%     imagesc(cost_matrix); colormap gray;
% end