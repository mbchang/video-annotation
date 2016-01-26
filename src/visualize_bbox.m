function videoFrame = visualize_bbox(videoStepper, positive_examples, videoFrame, annotation_mode)
    % Draws a bbox onto the video frame and returns it
    %
    % annotation_mode
    %       'forward': for forward annotation
    %       'reverse': for reverse annotation
    %       'correct': for correction annotation
    
    switch annotation_mode
        case 'forward'
            bbox_points = positive_examples.true_tracked_bboxes(:,:,videoStepper.currentFrame);
        case 'reverse'
            bbox_points = positive_examples.true_tracked_reverse_bboxes(:,:,videoStepper.currentFrame);
        case 'correct'
            bbox_points = positive_examples.bboxes(:,:,videoStepper.currentFrame);
        otherwise 
            error( 'Unknown annotation mode' );
    end

    bboxPolygon = reshape(bbox_points', 1, []);
    videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 2); % draw bounding box
end