function DTAKSearch_Rec(seq, segments, props)
%% DTAKSEARCH_REC Recursive DTAK search
%

% [Lv, s_i, e_i, c_i] = dp_search(1, size(seq,1), seq, clusters, props)
dp_search(seq, segments, props);


function dp_search(seq, segments, props)
%%
%
% compute L (s,e)
%   foreach i in [s+w_min, s+w_max]
%      L = compute L(i,e)
%      d = compute dist_c(s,i)
%      Li = L + d
%      if Li < L(i)
%         L(i) <-- Li, e, c
%
%
% init L(:) = inf;
% compute L(e)
%   if e <= 0
%       return;
%
%   foreach wv in [wmin,wmax]
%       s = e-wv+1;
%       [d,c] = arg min c dist(s,e);
%       L = compute L(s) + d;
%       if L(e).cost < L
%           L(e) = L;
%           L(e).s = s;
%           L(e).c = c;

function L = forward_create_L(seq, segments, props)

s = 1;
e = props.minmax_idx(1);
L = cell(size(seq,1));

while e < size(seq,1)
    
end