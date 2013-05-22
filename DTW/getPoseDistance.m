function dist = getPoseDistance( p1, p2 )
% Returns the distance between the two poses
%  Distance is defined the sum of the distance between each corresponding
%  joint

if length(p1) ~= 60 || length(p2) ~= 60
    error('Invalid pose');
end

p1 = reshape(p1,20,3);
p2 = reshape(p2,20,3);

dist = sum(sqrt(sum((p1-p2)'.^2)));