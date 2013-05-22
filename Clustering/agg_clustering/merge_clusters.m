
function [new_segments, n_merges] = merge_clusters(segments, c_idc, minmax_len)
%% MERGE_CLUSTERS
% Merge segments of the two clusters
%  if some segments are too far (> 1, for now), keep them in their own
%  clusters

% disp(['** Merging: ', num2str(c_idc)]);

n_merges = 0;

i = 1;
idx = 1;
new_segments = cell(0);
while i <= length(segments)
    s = segments{i};
    
    % if not from group of clusters to merge
    [lia,~] = ismember(s.cluster_idx,c_idc);
    if lia == 0
        new_segments{idx} = s;
        idx = idx+1;
        i = i+1;
    else        
%         disp(['Found start: ', num2str(s.cluster_idx), ' @ ', num2str(i)]);
        new_s = s;
        % go through each subsequent segment
        %  if next segment is in to_merge
        %    if merge_length < max
        %       if next == current && total_len < min, merge
        %       if next ~= current && total_len < max, merge
        %  if not
        %    if no_merges occured && len < min,
        %       merge with smaller seg (last, next)
        t_idx = 0;
        while true
            if i+t_idx+1 > length(segments)
                break
            end
            
            this_s = segments{i+t_idx};
            next_s = segments{i+t_idx+1};
            
            [lia,~] = ismember(next_s.cluster_idx, c_idc);
            if  lia == 1 && ...
                next_s.cluster_idx ~= this_s.cluster_idx && ...
                next_s.end_idx-new_s.start_idx <= minmax_len(2)
            
                % if next seg is to_merge, but not current, merge
                new_s.end_idx = next_s.end_idx;
                new_s.cluster_idx = c_idc(1);
                t_idx = t_idx + 1;
            else
                break;
            end

%             [lia,~] = ismember(next_s.cluster_idx, c_idc);
%             if lia == 0 && t_idx == 0
%                 % if length last_s < length next_s
%                 %   merge with last_s
%                 % else, merge with next_s
%                 if i+t_idx-1 >= 1
%                     last_s = segments{i+t_idx-1};
%                     if last_s.end_idx-last_s.start_idx < next_s.end_idx-next_s.start_idx
%                         if this_s.end_idx-last_s.start_idx <= minmax_len(2)
%                             new_s.start_idx = last_s.start_idx;
%                             new_s.end_idx = this_s.end_idx;
%                             new_s.cluster_idx = last_s.cluster_idx;
%                             idx = idx-1;
%                             n_merges = n_merges + 1;
%                         end
%                         break;
%                     end
%                 end
%                 
%                 % if not merge with last_s, merge with next_s
%                 if next_s.end_idx-this_s.start_idx <= minmax_len(2)
%                     new_s.start_idx = this_s.start_idx;
%                     new_s.end_idx = next_s.end_idx;
%                     new_s.cluster_idx = next_s.cluster_idx;
%                     t_idx = t_idx+1;
%                 end
%                 break;
% %             elseif lia == 1 && next_s.cluster_idx == this_s.cluster_idx
% %                 % if next_s is in to_merge && next_s == this_s
% %                 %  if length < min, merge
% %                 if next_s.end_idx-new_s.start_idx < minmax_len(1)
% %                     if next_s.end_idx-new_s.start_idx < minmax_len(2)
% %                         new_s.end_idx = next_s.end_idx;
% %                         new_s.cluster_idx = c_idc(1);
% %                         t_idx = t_idx+1;
% %                     else
% %                         break;
% %                     end
% %                 else
% %                     break;
% %                 end
%             elseif lia == 1 && next_s.cluster_idx ~= this_s.cluster_idx
%                 % if next_s is in to_merge && next_s ~= this_s
%                 %  if length < max, merge
%                 if next_s.end_idx-new_s.start_idx <= minmax_len(2)
%                     new_s.end_idx = next_s.end_idx;
%                     new_s.cluster_idx = c_idc(1);
%                     t_idx = t_idx+1;
%                 else
%                     break;
%                 end
%             else
%                 break;
%             end
        end
        
        new_segments{idx} = new_s;
        idx = idx+1;
        i = i+t_idx+1;
        n_merges = n_merges + t_idx;
    end
    
    % if not from either clusters to be merged, add, continue to next segment
%     if s.cluster_idx ~= c_idc(1) && s.cluster_idx ~= c_idc(2)
%         new_segments{idx} = s;
%         idx = idx + 1;
%         i = i + 1;
%         continue;
%     else
%         % if there are no more segments, add, continue to exit
%         sidx_n = i+1;
%         if sidx_n > length(segments)
%             new_segments{idx} = s;
%             idx = idx + 1;
%             i = i + 1;
%             continue;
%         end
%         
%         ns = segments{sidx_n};
%         
%         % merge 2 segments
%         if  (((s.cluster_idx == c_idc(1) && ns.cluster_idx == c_idc(2)) ||...
%             (s.cluster_idx == c_idc(2) && ns.cluster_idx == c_idc(1))) &&...
%             ns.end_idx-s.start_idx < minmax_len(2))
%             new_s.start_idx = s.start_idx;
%             new_s.end_idx = ns.end_idx;
%             new_s.cluster_idx = c_idc(1);
%             new_segments{idx} = new_s;
%             
%             n_merges = n_merges + 1;
%             idx = idx + 1;
%             i = i + 2;
%         else
%             new_segments{idx} = s;
%             idx = idx + 1;
%             i = i + 1;
%         end
%     end
end

% close all;
% display_segments(new_segments, length(new_segments), [], 0);
% clusters = get_clusters_from_segments(new_segments);
% D = get_distance_matrix_temporal(clusters);
% figure; imagesc(D); colormap gray;
% waitforbuttonpress