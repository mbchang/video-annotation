function [bbox_points, visible_points, videoFrame, videoFrame_overlayed] = track_bbox(videoFrame, pointTracker, old_tracking_points, bbox_points, mp)
%     if mp.demo == 1
%         assert(nargin == 7); % require that we have positive_examples and current_frame
%     end    
    disp('in track bbox');
    old_tracking_points(1:min(5, size(old_tracking_points,1)), :);

    HEIGHT = size(videoFrame, 1);
    WIDTH = size(videoFrame,2);
    % Track the points. Note that some points may be lost.
    [tracking_points, isFound] = step(pointTracker, videoFrame); %there could be an error here
    visible_points = tracking_points(isFound, :);
    oldInliers = old_tracking_points(isFound, :);
    
    if size(visible_points, 1) >= mp.TRACKING_THRESHOLD % need at least mp.TRACKING_THRESHOLD points

        % Estimate the geometric transformation between the old points
        % and the new points and eliminate outliers
        [xform, oldInliers, visible_points] = estimateGeometricTransform(oldInliers, visible_points, 'similarity', 'MaxDistance', 4); % xForm contains the transform information
        % Apply the transformation to the bounding box points
        bbox_points = transformPointsForward(xform, bbox_points); % So this way the bbox would also rotate with the points.
        
        xmin = mean([bbox_points(1,1), bbox_points(4,1)]);
        ymin = mean([bbox_points(1,2), bbox_points(2,2)]);
        xmax = mean([bbox_points(3,1), bbox_points(2,1)]);
        ymax = mean([bbox_points(3,2), bbox_points(4,2)]);
        
        % Clamp to window
        left = max(1, xmin); top = max(1, ymin); right = min(WIDTH, xmax); bottom = min(HEIGHT, ymax);
        bbox_points = [left top; right top; right bottom; left bottom]; % Coordinates of bounding box. Clockwise from top left   
                
        % Estimate tracking box for visualiziation
        [tracking_rect, tracking_polygon, centroid] = scale_rect(bbox_points, mp);

        % Insert a bounding box around the object being tracked
        bboxPolygon = reshape(bbox_points', 1, []);
        bboxPolygon = [bboxPolygon; tracking_polygon];
        videoFrame_overlayed = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 2);

        % Display tracked points
        videoFrame_overlayed = insertMarker(videoFrame_overlayed, visible_points, '*', 'Color', 'white');  
    else
        disp('could not find points to track in the next frame')
        videoFrame_overlayed = videoFrame;
    end

end