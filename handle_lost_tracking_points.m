function [videoStepper, frame_types, should_get_ground_truth] = handle_lost_tracking_points(videoStepper, frame_types)            
    disp('we should try to get a bbox again');
    should_get_ground_truth = true;
    frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} ' sf'];
end