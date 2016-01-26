function comparison = compare_bbox_to_frame(bbox_points, videoFrame)
% comparison is 
%       1 if bbox encloses videoFrame or is the same size
%       0 if bbox is enclosed in videoFrame
% Recall:
%   bbox_points = [left top; right top; right bottom; left bottom];
    left = bbox_points(1); top = bbox_points(5); right = bbox_points(3); bottom = bbox_points(7);
    comparison = left <= 1 && top <=1 && right >= size(videoFrame,2) && bottom >= size(videoFrame,1);
end