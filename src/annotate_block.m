function [videoStepper, pointTracker, videoPlayer, frame_types, positive_examples, goSlow] = annotate_block(videoStepper, pointTracker, videoPlayer, frame_types, positive_examples, found_first_positive_frame, should_get_ground_truth, go_to_next_frame, goSlow, mp)
    most_recent_positive_frame_num = -1;  % dummy impossible number
    while ~isDone(videoStepper)
        if go_to_next_frame
            videoFrame = nextFrame(videoStepper);
        end
                
        %% Attempt to get bounding box and record it if possible
        if should_get_ground_truth || mod(videoStepper.currentFrame, mp.MODULUS) == mp.MODULUS_INDEX % Note: this is the frame of the PREVIOUS iteration! Issue to address: change this to 0 and you will get 2 tracking points on frame 11.
            % Manually Input a Bounding Box
            [videoStepper, positive_examples, frame_types, bbox_points, old_tracking_points, videoFrame, videoFrame_overlayed, no_pos_ex_left_in_block, goSlow, go_to_next_frame, should_get_ground_truth] = attempt_manual_input(videoStepper, positive_examples, frame_types, videoFrame, most_recent_positive_frame_num, found_first_positive_frame, should_get_ground_truth, goSlow, mp);           
            if no_pos_ex_left_in_block, break, end
        else
            % Track an Existing Bounding Box
            [videoStepper, pointTracker, positive_examples, frame_types, bbox_points, old_tracking_points, videoFrame, videoFrame_overlayed, go_to_next_frame] = attempt_tracking(videoStepper, pointTracker, positive_examples, frame_types, videoFrame, bbox_points, old_tracking_points, go_to_next_frame, mp);
        end
        
        %% Reset and/or move on
        % If can't find tracking points, go to the next frame and try to find a bbox again
        if size(old_tracking_points,1) < mp.TRACKING_THRESHOLD 
            % manual or tracking: we lost the tracking points
            [videoStepper, frame_types, should_get_ground_truth] = handle_lost_tracking_points(videoStepper, frame_types);
        elseif ~found_first_positive_frame 
            % This is our first frame
            [videoStepper, pointTracker, frame_types, most_recent_positive_frame_num, found_first_positive_frame] = handle_first_frame(videoStepper, pointTracker, frame_types, videoFrame, old_tracking_points);
        else
            % This is from manual or tracking
            [videoStepper, pointTracker, most_recent_positive_frame_num] = handle_successful_bbox_capture(videoStepper, pointTracker, old_tracking_points);
        end
        
        % Display the annotated video frame using the video player object
        if go_to_next_frame
            step(videoPlayer, videoFrame_overlayed); 
        end
    end
    
    %% Get ground truth for last positive frame
    [videoStepper, pointTracker, positive_examples, frame_types] = label_last_positive_frame(videoStepper, pointTracker, positive_examples, frame_types, found_first_positive_frame, most_recent_positive_frame_num, mp);   
end