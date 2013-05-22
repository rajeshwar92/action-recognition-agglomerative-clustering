function display_segments( segments, nclusters, gt_segments, gt_nclusters )

if ~isempty(gt_segments) || ~isempty(segments)
    rcolors = 0.01*randi([20 80], [1,3*max(gt_nclusters,nclusters)]);
    figure;
end

if ~isempty(gt_segments)
    if ~isempty(segments)
        subplot(2,1,1);
        title('Ground Truth');
    end
    hold on;
    for i = 1:length(gt_segments)
        s = max(1,gt_segments{i}.start_idx-1);
        e = gt_segments{i}.end_idx;
        fill([s e e s], [0 0 1 1], rcolors(gt_segments{i}.cluster_idx:gt_segments{i}.cluster_idx+2));
    end
    hold off;
    axis([0 gt_segments{length(gt_segments)}.end_idx 0 1]);
end

if ~isempty(segments)
    if ~isempty(gt_segments)
        subplot(2,1,2);
        title('Recognition Results');
    end
    hold on;
    for i = 1:length(segments)
        s = max(1,segments{i}.start_idx-1);
        e = segments{i}.end_idx;
        fill([s e e s], [0 0 1 1], rcolors(segments{i}.cluster_idx:segments{i}.cluster_idx+2));
    end
    hold off;
    
    if ~isempty(gt_segments)
        axis([0 gt_segments{length(gt_segments)}.end_idx 0 1]);
    else
        axis([0 segments{length(segments)}.end_idx 0 1]);
    end
end