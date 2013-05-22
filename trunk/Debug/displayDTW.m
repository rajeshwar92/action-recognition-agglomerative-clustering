function displayDTW( cost_matrix, accum_cost_matrix, warp_path )
%DISPLAYDTW Displays the cost matrix, accumulated cost matrix and warp path


figure; imagesc(cost_matrix); title('Cost Matrix'); colormap gray;
figure; imagesc(accum_cost_matrix); title('Accum Cost Matrix'); colormap gray;

if size(warp_path,2) == 0
    return;
end

hold on;
plot(warp_path(:,2), warp_path(:,1), 'r-');
plot(warp_path(:,2), warp_path(:,1), 'go');
hold off;