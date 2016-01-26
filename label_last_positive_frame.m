function [videoStepper, pointTracker, positive_examples, frame_types] = label_last_positive_frame(videoStepper, pointTracker, positive_examples, frame_types, found_first_positive_frame, most_recent_positive_frame_num, mp)
    if found_first_positive_frame
        assert(most_recent_positive_frame_num ~= -1);
        % Get ground truth for last positive frame and save that as well
        % Find ground truth for last frame
        last_positive_frame = getFrame(videoStepper, most_recent_positive_frame_num);
        [bbox_points, old_tracking_points, ~] = draw_bbox(last_positive_frame, mp);
        if size(old_tracking_points,1) >= mp.TRACKING_THRESHOLD && not_all_same(bbox_points)
            disp('size(old_tracking_points,1) >= mp.TRACKING_THRESHOLD && not_all_same(bbox_points)');
            positive_examples.true_bboxes(:,:,most_recent_positive_frame_num) = bbox_points; % Record data
            positive_examples.true_tracked_bboxes(:,:,most_recent_positive_frame_num) = bbox_points;
            frame_types{most_recent_positive_frame_num, 2} = [frame_types{most_recent_positive_frame_num, 2} ' trf']; % so we should expect a ' tkf lpf trf' in this cell
        end
        release(pointTracker);
    end
end