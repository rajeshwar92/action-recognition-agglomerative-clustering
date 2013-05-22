function [ mincostidx, mincost ] = DTWClassifier( action_seq, action_classes )
%% ACTIONCLASSIFIER Given an action, classifies it to a given action class
%  action_classes is a cell array of cell arrays which contain action
%  instances

mincostidx = -1;
mincost = inf;

for c = 1:length(action_classes)
    cost = getAverageCost(action_seq, action_classes{c});
    if cost < mincost
        mincost = cost;
        mincostidx = c;
    end
end

% disp(['Classified as action ' num2str(mincostidx)]);

function avg_cost = getAverageCost(action_seq, action_class)
global steps
global threshold

totalcost = 0;
for i = 1:length(action_class)
    [warp_path,cost] = DTWsubsequence(action_seq, action_class{i}, steps, threshold, 0);
    totalcost = totalcost + cost;
end

avg_cost = totalcost/length(action_class);