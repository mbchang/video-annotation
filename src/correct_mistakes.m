function [positive_examples, frame_types] = correct_mistakes(videoStepper, videoPlayer, positive_examples, frame_types, mp)
    % If input is 0, then that gets erased from all bboxes
    % If input is a bbox, then that gets put into true bbox
    % This function can also be used to step through the video
    releaseReader(videoStepper); % Not sure if this would have a bug if we don't release it properly
    release(videoPlayer);
    running = 1;
    annotation_mode = 'correct';
    reverse = 0;
 
    h_fig = figure;
    
    set(h_fig,'KeyPressFcn',@(h_obj,evt, handles) process_key(evt.Key))
    while running
        pause(0.0001);
    end
    
    function process_key(k)
        switch k
            case 'q'
                running = 0; % quit out
            case'r'
                disp('previous')
                videoFrame = previousFrame(videoStepper, reverse);
                videoFrame = visualize_bbox(videoStepper, positive_examples, videoFrame, annotation_mode);
                step(videoPlayer, videoFrame);
            case 't'
                disp('next')
                videoFrame = nextFrame(videoStepper, reverse);
                videoFrame = visualize_bbox(videoStepper, positive_examples, videoFrame, annotation_mode);
                step(videoPlayer, videoFrame);
            case 'a'
                disp('annotate')
                videoFrame = getFrame(videoStepper, videoStepper.currentFrame);
                [bbox_points, ~, ~, ~] = draw_bbox(videoFrame, mp);
                if size(unique(bbox_points, 'rows'), 1) == 1 % This means that the bbox has only one point
                    bbox_points = zeros(4,2); % This is a correction
                    positive_examples.true_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
                    positive_examples.corrected_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
                    positive_examples.bboxes(:,:,videoStepper.currentFrame) = bbox_points;
                    frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} ' ceb']; % corrected empty box
                else % The user attempts to correct it
                    disp('new bbox');
                    positive_examples.corrected_bboxes(:,:,videoStepper.currentFrame) = bbox_points;
                    positive_examples.bboxes(:,:,videoStepper.currentFrame) = bbox_points;
                    frame_types{videoStepper.currentFrame, 2} = [frame_types{videoStepper.currentFrame, 2} ' ctb']; % corrected true box
                end
        end
    end

    releaseReader(videoStepper); % Not sure if this would have a bug if we don't release it properly
    release(videoPlayer);
    close
end
    
    
    
    
