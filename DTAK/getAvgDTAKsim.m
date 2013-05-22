function avg_sim = getAvgDTAKsim(cluster, seq, sigma)
%%
% cluster  list of all sequences in cluster
% seq      sequence to search for
% sigma    used to compute the gaussian kernel of sigma

total_n = 0;
total_cost = 0;
for i = 1:length(cluster)
    total_cost = total_cost + DTAK(cluster{i}, seq, sigma);
    total_n = total_n + 1;
end

avg_sim = total_cost / total_n;