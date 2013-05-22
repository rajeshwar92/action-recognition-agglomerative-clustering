function [ n_c2_segments, n_c2_clusters ] = align_clusters( c1_segments, c1_clusters, c2_segments, c2_clusters )
%% ALIGN_CLUSTERS 
%

% conf_matrix = compute_segments_confusion_matrix(c1_segments, length(c1_clusters), c2_segments, length(c2_clusters));
% 
% aligned_conf_matrix = conf_matrix;
% 
% corr = zeros([1,size(conf_matrix,2)]);
% 
% % re-arrange confusion matrix based maximum correspondence
% % get correspondence between old/new cluster_idc
% for i = 1:min(size(conf_matrix,2),size(conf_matrix,1))
%     [mv, mi] = max(conf_matrix(i,:));
%     
%     aligned_conf_matrix(:,mi) = conf_matrix(:,i);
%     corr(mi) = i;
% end
% 
% % re-assign false clusters
% for i = 1:size(conf_matrix,2)
%     [lia,locb] = ismember(i,corr);
%     if lia == 0
%         [clia,clocb] = ismember(0,corr);
%         if clia == 1
%             aligned_conf_matrix(:,i) = conf_matrix(:,clocb);
%             corr(clocb) = i;
%         end
%     end
% end
% 
% % re-assign segments to new clusters
% n_c2_segments = c2_segments;
% for i = 1:length(c2_segments)
%     if corr(n_c2_segments{i}.cluster_idx) ~= 0
%         n_c2_segments{i}.cluster_idx = corr(n_c2_segments{i}.cluster_idx);
%     end
% end
% 
% % compute new clusters
% [n_c2_segments, n_c2_clusters] = get_clusters_from_segments(n_c2_segments);

dsize = false;

conf_matrix = compute_segments_confusion_matrix(c1_segments, length(c1_clusters), c2_segments, length(c2_clusters));

if size(conf_matrix,1) > size(conf_matrix,2)
    dsize = true;
    conf_matrix = conf_matrix';
end

[perm_matrix,acc] = ass(conf_matrix, 'hug');

if dsize
    perm_matrix = perm_matrix';
end

% align conf_matrix
% for i = 1:size(perm_matrix,1)
%     for j = 1:size(perm_matrix,2)
%         if perm_matrix(i,j) ~= 1
%             continue;
%         end
%         
%         t = conf_matrix(:,i);
%         conf_matrix(:,i) = conf_matrix(:,j);
%         conf_matrix(:,j) = t;
%     end
% end

n_c2_segments = c2_segments;
for i = 1:length(n_c2_segments)
    s = n_c2_segments{i};
    jidx = find(perm_matrix(:,s.cluster_idx) == 1);
    if isempty(jidx)
        continue;
    end
    n_c2_segments{i}.cluster_idx = jidx(1);
end

[n_c2_segments, n_c2_clusters] = get_clusters_from_segments(n_c2_segments);