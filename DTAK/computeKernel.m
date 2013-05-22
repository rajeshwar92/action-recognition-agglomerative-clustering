function kern = computeKernel(D, sigma)
%%
%  D        distance matrix
%  sigma	sigma for gaussian kernel

kern = zeros(size(D,1),size(D,2));
for i = 1:size(kern,1)
    for j = 1:size(kern,2)
        kern(i,j) = exp((-1/(2*sigma^2)) * D(i,j));
    end
end