function [videoStepper, pointTracker, most_recent_positive_frame_num] = handle_successful_bbox_capture(videoStepper, pointTracker, old_tracking_points)           
    most_recent_positive_frame_num = videoStepper.currentFrame;
    disp('Setting old_tracking_points');
    setPoints(pointTracker, old_tracking_points); % Reset the pointTracker
end