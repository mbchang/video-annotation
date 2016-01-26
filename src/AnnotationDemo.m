function AnnotationDemo(name, write_video)
%% Annotation Demo
% This example shows how to let the user dynamically annotate the video and
% write the annotated images to a .mat file. It uses tracking to
% interpolate between bounding boxes. The tracking was inspired by
% MathWorks' FaceTrackingUsingKLTExample.m 

%% Set up
[videoStepper, videoPlayer, pointTracker, positive_examples, mp] = set_up_video_annotation(1, name);
tracker_initialized = 0;
could_not_track = 0;

if write_video
    writerObj = VideoWriter(['demo_videos/' name '_corrected_annotation.avi']);
    open(writerObj);
    axis tight
    set(gca,'nextplot','replacechildren');
    set(gcf,'Renderer','zbuffer');
end

%% Main Loop
while ~isDone(videoStepper)
    videoFrame = nextFrame(videoStepper);
    
    if norm(positive_examples.bboxes(:,:,videoStepper.currentFrame)) == 0 
        % This means that there was no shaver here when we had previously
        % labeled it
        videoFrame_overlayed = videoFrame;
    else
        if norm(positive_examples.true_bboxes(:,:,videoStepper.currentFrame)) > 0
            % 'draw_bbox' by drawing the true bounding box that has been
            % recorded
            [bbox_points, old_tracking_points, videoFrame, videoFrame_overlayed] = draw_bbox(videoFrame, mp, positive_examples, videoStepper.currentFrame, write_video); % Draw new ground truth bounding box
            % Initialize tracker for the first point
            if ~tracker_initialized 
                initialize(pointTracker, old_tracking_points, videoFrame);
                tracker_initialized = 1;
            end
        elseif could_not_track
            disp('Was able to track points previously but not able to now. Skip this frame.');
            videoFrame_overlayed = videoFrame;
        else
            % This means that this was not a true bounding box but a tracked
            % bounding box
            
            % TODO: if true_tracked not > 0, then maybe
            % true_tracked_reverse > 0. This would mean that because
            % norm(positive_examples.bboxes(:,:,curFrame) ~= 0, there had
            % been some trackign going on here, which could be either
            % forward or reverse tracking
            assert(norm(positive_examples.true_tracked_bboxes(:,:,videoStepper.currentFrame)) > 0 || norm(positive_examples.true_tracked_reverse_bboxes(:,:,videoStepper.currentFrame)) > 0);
            [bbox_points, old_tracking_points, ~, videoFrame_overlayed] = track_bbox(videoFrame, pointTracker, old_tracking_points, bbox_points, mp); % Track the bounding box
        end
        
        if size(old_tracking_points,1) < mp.TRACKING_THRESHOLD
            could_not_track = 1;
        else
            could_not_track = 0;
            setPoints(pointTracker, old_tracking_points); % Reset the pointTracker
        end
        pause(0.05);
    end
    
    if ~write_video
        step(videoPlayer, videoFrame_overlayed); % Display the annotated video frame using the video player object
    end
    
    if write_video
        if norm(positive_examples.true_bboxes(:,:,videoStepper.currentFrame)) > 0
            for i = 1:20
                writeVideo(writerObj, videoFrame_overlayed);
            end
        else
            writeVideo(writerObj, videoFrame_overlayed);
        end
    end
end

% Clean up
releaseReader(videoStepper); % Not sure if this would have a bug if we don't release it properly
release(videoPlayer);
release(pointTracker);
close(writerObj);

if ~write_video
    %% Use a moving average to estimate the bounding boxes
    positive_examples = moving_average_estimate_bboxes(positive_examples, mp); % modifies positive_examples.bboxes

    %% Visualize Accuracy of Estimates
    visualize_positive_examples(positive_examples.bboxes, videoStepper, videoPlayer, mp, 0.1);
end
end