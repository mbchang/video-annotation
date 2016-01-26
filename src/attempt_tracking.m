function [videoStepper, pointTracker, positive_examples, frame_types, bbox_points, old_tracking_points, videoFrame, videoFrame_overlayed, go_to_next_frame] = attempt_tracking(videoStepper, pointTracker, positive_examples, frame_types, videoFrame, bbox_points, old_tracking_points, go_to_next_frame, mp) 
    [bbox_points, old_tracking_points, videoFrame, videoFrame_overlayed] = track_bbox(videoFrame, pointTracker, old_tracking_points, bbox_points, mp); % Track the bounding box
    if size(old_tracking_points,1) >= mp.TRACKING_THRESHOLD
        positive_examples.true_tracked_bboxes(:,:,videoStepper.currentFrame) = bbox_points; % Record data
        frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} ' tkf'];
    else
        % This means that the tracker lost the points, so for this
        % frame we can't find any points. We cannot go to the next
        % frame. go_to_next_frame will only turn true after we
        % enter the draw_bbox block
        disp('lost points while tracking. will not move on to next frame')
        go_to_next_frame = false;
    end
end