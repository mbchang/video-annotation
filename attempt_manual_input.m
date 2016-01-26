function [videoStepper, positive_examples, frame_types, bbox_points, old_tracking_points, videoFrame, videoFrame_overlayed, no_pos_ex_left_in_block, goSlow, go_to_next_frame, should_get_ground_truth] = attempt_manual_input(videoStepper, positive_examples, frame_types, videoFrame, most_recent_positive_frame_num, found_first_positive_frame, should_get_ground_truth, goSlow, mp)
    % Note: most_recent_positive_frame_num == -1 means it has not been
    % assigned a value yet.

    go_to_next_frame = true;
    no_pos_ex_left_in_block = false;
    
    [bbox_points, old_tracking_points, videoFrame, videoFrame_overlayed] = draw_bbox(videoFrame, mp); % Draw new ground truth bounding box
    
    if compare_bbox_to_frame(bbox_points, videoFrame) % Protocol: if the bounding box is the entire window, then we will go into videoplaying mode. This means there are no more positive examples in this block
        disp('breaking inner loop')
        disp(videoStepper.currentFrame);
        goSlow = true;                
        frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} ' qf'];
        if found_first_positive_frame
            assert(most_recent_positive_frame_num ~= -1);
            frame_types{most_recent_positive_frame_num, 2} = [frame_types{most_recent_positive_frame_num, 2} ' lpf'];
        end
        no_pos_ex_left_in_block = true;
    elseif size(old_tracking_points,1) >= mp.TRACKING_THRESHOLD % This means that the box is nonempty
        positive_examples.true_bboxes(:,:,videoStepper.currentFrame) = bbox_points; % Record data
        positive_examples.true_tracked_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
        should_get_ground_truth = false;
        frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} ' trf'];
    end
end