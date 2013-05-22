function [threshold] = compute_threshold(seq)
%% COMPUTE_THRESHOLD
%

% standard deviation (about half range)
st = sqrt(sum(std(seq).^2))
% mean & median (similar)
mn = sqrt(sum(mean(seq).^2))
med = sqrt(sum(median(seq).^2))
% mode (greater)
mod = sqrt(sum(mode(seq).^2))


if mod < st
    threshold = 0.5 + (mod / mean([mn,med]));
else
    threshold = (mod / mean([mn,med]));
end

if threshold > 0.95
    threshold = 0.95;
end

if threshold < 0.1
    threshold = 0.1;
end

threshold
