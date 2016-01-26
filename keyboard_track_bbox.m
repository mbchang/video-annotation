    function [videoStepper, pointTracker, positive_examples, frame_types, old_tracking_points, bbox_points] = keyboard_track_bbox(videoStepper, pointTracker, videoPlayer, positive_examples, frame_types, videoFrame, old_tracking_points, bbox_points, annotation_mode, reverse, mp, varargin)
        switch annotation_mode
            case 'forward'
                track_label = ' ftk';
            case 'reverse'
                track_label = ' rtk';
            case 'correct'
                track_label = ' ctk';
        end
        
        % This means that we are supposed to track. In
        % theory, old_tracking_points at the moment should
        % be trackable, at least during the first iteration
        % of the loop, because the assumption is that the
        % user would tell the computer to track if the
        % previous frame was not well annotated.
        old_tracking_points(1:min(5, size(old_tracking_points,1)), :);
        setPoints(pointTracker, old_tracking_points);
        [bbox_points, old_tracking_points, ~, videoFrame_overlayed] = track_bbox(videoFrame, pointTracker, old_tracking_points, bbox_points, mp);
        disp('after')
        old_tracking_points(1:min(5, size(old_tracking_points,1)), :);
        % record the bbox if it passes the threshold, break
        % out of the loop otherwise
        if size(old_tracking_points,1) >= mp.TRACKING_THRESHOLD
            frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} track_label]; % true bbox for reverse pass that has been recorded
            positive_examples.true_tracked_reverse_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
            
            switch annotation_mode
                case 'forward'
                    positive_examples.true_tracked_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
                case 'reverse'
                    positive_examples.true_tracked_reverse_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
                case 'correct'
                    % This tracking goes into the final bbox_points, so it
                    % had better be perfect. You can go back and correct
                    % them if you want.
                    positive_examples.bboxes(:,:,videoStepper.currentFrame) = bbox_points;
            end
            
            setPoints(pointTracker, old_tracking_points);
        else
            % This will be what executes before the loop
            % breaks, because the loop will break if the
            % threshold is not met
            videoFrame_overlayed = previousFrame(videoStepper, reverse); % Go back to the frame that you couldn't annotate. In this case videoFrame_overlayed is a misnomer
        end
        step(videoPlayer, videoFrame_overlayed);
    end