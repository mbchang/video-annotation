function [bbox_points, tracking_points, videoFrame, videoFrame_overlayed] = draw_bbox(videoFrame, mp, positive_examples, current_frame, show, use_corrected)
    HEIGHT = size(videoFrame, 1);
    WIDTH = size(videoFrame,2);
    
    if nargin < 5
        show = 1;
    end
    
    if nargin < 6
        use_corrected = 0;
    end
    
    % Grab the next frame
    if show
        figure, imshow(videoFrame); title('Manually Label');
    end
    
    % Get user input for rectangle
    if nargin > 2
        assert(nargin >=4)
        if use_corrected
            bbox_points = positive_examples.corrected_bboxes(:,:,current_frame);
        else
            bbox_points = positive_examples.true_bboxes(:,:,current_frame);
        end
    else
        rect = getrect;
        % Clamp bounding box to window
        xmin = rect(1); ymin = rect(2); width = rect(3); height = rect(4);
        newxmin = max(1, xmin); newymin = max(1, ymin); newwidth = min(WIDTH-newxmin, width); newheight = min(HEIGHT-newymin, height);
        left = newxmin; top = newymin; right = newxmin + newwidth; bottom = newymin + newheight;
        bbox_points = [left top; right top; right bottom; left bottom]; % Coordinates of bounding box. Clockwise from top left 
    end

    bboxPolygon = reshape(bbox_points', 1, []);

    % Find a scaled-down rectangle to do tracking
    [tracking_rect, tracking_polygon, centroid] = scale_rect(bbox_points, mp);
    
    % Find points to track within the rectangle
    tracking_points = detectMinEigenFeatures(rgb2gray(videoFrame), 'ROI', tracking_rect);
    tracking_points = tracking_points.Location;
    
    bboxPolygon = [bboxPolygon; tracking_polygon];
    
    % Display overlay
    videoFrame_overlayed = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 2); % draw bounding box 
    if ~compare_bbox_to_frame(bbox_points, videoFrame)
        disp('plotted')
        videoFrame_overlayed = insertShape(videoFrame_overlayed, 'Polygon', tracking_polygon, 'LineWidth', 1); % draw tracking bounding box
        videoFrame_overlayed = insertMarker(videoFrame_overlayed, centroid, '+', 'Color', 'white'); % draw centroid (may not be necessary)
        videoFrame_overlayed = insertMarker(videoFrame_overlayed, tracking_points, '*', 'Color', 'green'); 
    end;
    if show
        disp('showing');
        figure, imshow(videoFrame_overlayed), title('Manually Labeled');
%         pause(1.5);
        close;
        close;
    end
end