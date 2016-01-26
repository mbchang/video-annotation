function [videoStepper, pointTracker, frame_types, most_recent_positive_frame_num, found_first_positive_frame] = handle_first_frame(videoStepper, pointTracker, frame_types, videoFrame, old_tracking_points)   
    initialize(pointTracker, old_tracking_points, videoFrame);
    found_first_positive_frame = true;
    most_recent_positive_frame_num = videoStepper.currentFrame;
    frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} ' ipf'];
end