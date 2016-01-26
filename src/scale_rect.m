function [tracking_rect, tracking_polygon, centroid] = scale_rect(bbox_points, mp)
    % bbox_points = [left top; right top; right bottom; left bottom];
    left = bbox_points(1); top = bbox_points(5); right = bbox_points(3); bottom = bbox_points(7);
    xmin = left; ymin = top; width = right - left; height = bottom - top;
    
    % Find properties of bounding box
    centroid = [(left+right)/2 (top+bottom)/2];
    area = (right - left) * (bottom-top);
    assert(area >= 0); % When the area is equal to 0 that means the user just clicked
    
    % Shrink the size of the tracking rectangle
    shrunkxmin = centroid(1) - 0.5*mp.SCALE_FACTOR*width; 
    shrunkymin = centroid(2) - 0.5*mp.SCALE_FACTOR*height; 
    shrunkwidth = mp.SCALE_FACTOR*width; 
    shrunkheight = mp.SCALE_FACTOR*height;
    tracking_rect = [shrunkxmin, shrunkymin, shrunkwidth, shrunkheight];
    
    shrunk_left = shrunkxmin; 
    shrunk_top = shrunkymin; 
    shrunk_right = shrunkxmin+shrunkwidth; 
    shrunk_bottom = shrunkymin + shrunkheight;
    tracking_polygon = [shrunk_left shrunk_top shrunk_right shrunk_top shrunk_right shrunk_bottom shrunk_left shrunk_bottom];
end