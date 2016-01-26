function [videoStepper, pointTracker, positive_examples, frame_types, old_tracking_points, bbox_points] = display_recorded_GT_box(videoStepper, pointTracker, videoPlayer, positive_examples, frame_types, videoFrame, mp)
    disp('use initial manual labeled box');
    % This means that there is already a true
    % annotation for this frame. Draw it and set
    % pointsTracker to these old_tracking_points. The
    % assumption is that the user has not mistakenly
    % labeled a bbox in a frame where there is not
    % supposed to be a bbox. This block will be entered
    % whenever the current frame has a true_bbox, which
    % includes cases when the frame has had a labeling 
    % during the forward pass, as well as during the case 
    % that the user had just annotated the currentFrame
    [bbox_points, old_tracking_points, videoFrame, videoFrame_overlayed] = draw_bbox(videoFrame, mp, positive_examples, videoStepper.currentFrame, 0);

    % Record
    frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} ' rtr_r']; % true bbox for reverse pass that has been recorded
    positive_examples.true_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
    positive_examples.true_tracked_reverse_bboxes(:,:,videoStepper.currentFrame) = bbox_points;

    % Step the video
    step(videoPlayer, videoFrame_overlayed);

    % Reset the pointTracker to track these manually
    % annotated points
    release(pointTracker);
    initialize(pointTracker, old_tracking_points, videoFrame);
    old_tracking_points(1:min(5, size(old_tracking_points,1)), :)
end