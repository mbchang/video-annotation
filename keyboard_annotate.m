function [videoStepper, pointTracker, positive_examples, frame_types, old_tracking_points, bbox_points, videoFrame_overlayed] = keyboard_annotate(videoStepper, pointTracker, positive_examples, frame_types, annotation_mode, mp)
    switch annotation_mode
        case 'forward'
            true_label = ' ftr';
            empty_label = ' feb';
        case 'reverse'
            true_label = ' rtr';
            empty_label = ' reb';
        case 'correct'
            true_label = ' ctr';
            empty_label = ' ceb';
    end

    videoFrame = getFrame(videoStepper, videoStepper.currentFrame);
    [bbox_points, old_tracking_points, videoFrame, videoFrame_overlayed] = draw_bbox(videoFrame, mp);
    frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} true_label]; % true bbox for reverse pass
    disp('just drew');
    old_tracking_points;
    release(pointTracker);
    if size(unique(bbox_points, 'rows'), 1) == 1 % This means that the bbox has only one point
        disp('empty');
        bbox_points = zeros(4,2); % This is a correction

        frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} empty_label]; % corrected empty box for reverse pass
        % note that if the bbox is empty then there is no need
        % to initialize the pointTracker
    else 
        disp('new bbox');
        old_tracking_points;
        % it seems like the following two lines are necessary to
        % avoid the tracker from remembering the tracking points of
        % the last block for some reason
        initialize(pointTracker, old_tracking_points, videoFrame);
    end
    
    positive_examples.true_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
    
    switch annotation_mode
        case 'forward'
            positive_examples.true_tracked_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
        case 'reverse'
            positive_examples.true_tracked_reverse_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
        case 'correct'
            positive_examples.corrected_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
            positive_examples.bboxes(:,:,videoStepper.currentFrame) = bbox_points;
    end
end