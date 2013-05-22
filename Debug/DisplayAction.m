function DisplayAction( actiondata, fps, onclick )

J = [   20     1     2     1     8    10     2     9    11     3     4     7     7     5     6    14    15    16    17;
         3     3     3     8    10    12     9    11    13     4     7     5     6    14    15    16    17    18    19];

% for each pose
for i = 1 : size(actiondata,1)
    % pose, plot joints, bones
    p = reshape(actiondata(i,:)',3,20)';
    plot3(p(:,3),p(:,1),p(:,2),'r.');
    for j=1:19
        c1=J(1,j);
        c2=J(2,j);
        line([p(c1,3) p(c2,3)], [p(c1,1) p(c2,1)], [p(c1,2) p(c2,2)]);
    end
    set(gca,'DataAspectRatio',[1 1 1]);
    axis([-1 1 -1 1 -1 1]);
    xlabel('x'); ylabel('y'); zlabel('z');
    
    disp(['frame ' num2str(i)]);
    if onclick == true
        waitforbuttonpress;
    else
        pause(1/fps);
    end
end