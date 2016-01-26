function [positive_examples, frame_types] = KeyboardAnnotation(videoStepper, videoPlayer, pointTracker, positive_examples, frame_types, annotation_mode, mp)
    % If input is 0, then that gets erased from all bboxes
    % If input is a bbox, then that gets put into true bbox
    % This function can also be used to step through the video
    
    
    releaseReader(videoStepper); % Not sure if this would have a bug if we don't release it properly
    release(videoPlayer);
    release(pointTracker);
    
    
    % Control Variables
    running = 1
    reverse = 0
%     annotation_mode = 'forward';
    
    
    % Initial values
    bbox_points = 0
    old_tracking_points = 0
    
 
    % Main
    h_fig = figure;
    set(h_fig,'KeyPressFcn',@(h_obj,evt, handles) process_key(evt.Key, reverse))
    while running
        pause(0.000001);
    end
    close;
    
    
    function process_key(k, reverse)
        switch k
            
            case 'q'
                running = 0; % quit out
                
            case'f'
                disp('previous')
                videoFrame = previousFrame(videoStepper);
                videoFrame = visualize_bbox(videoStepper, positive_examples, videoFrame, annotation_mode);
                step(videoPlayer, videoFrame);
                
            case 'g'
                disp('next')
                videoFrame = nextFrame(videoStepper);
                videoFrame = visualize_bbox(videoStepper, positive_examples, videoFrame, annotation_mode);
                step(videoPlayer, videoFrame);
                
            case 'a'
                disp('annotate')
                [videoStepper, pointTracker, positive_examples, frame_types, old_tracking_points, bbox_points, videoFrame_overlayed] = keyboard_annotate(videoStepper, pointTracker, positive_examples, frame_types, annotation_mode, mp);
                step(videoPlayer, videoFrame_overlayed);         
            case 't'
                disp('track')
                videoFrame = getFrame(videoStepper, videoStepper.currentFrame);

                % It's because of this if statement here that we don't need
                % global variables old_tracking_points and bbox_points!
                if norm(positive_examples.true_bboxes(:,:,videoStepper.currentFrame)) > 0
                    % TODO is this unnecessary?
                    [videoStepper, pointTracker, positive_examples, frame_types, old_tracking_points, bbox_points] = display_recorded_GT_box(videoStepper, pointTracker, videoPlayer, positive_examples, frame_types, videoFrame, mp);
                else
                    [videoStepper, pointTracker, positive_examples, frame_types] = possibly_erase(videoStepper, pointTracker, positive_examples, frame_types, annotation_mode);
                end
                
                iters = 0;
                while ~isDone(videoStepper) && size(old_tracking_points,1) >= mp.TRACKING_THRESHOLD && iters < mp.MODULUS 
                    videoFrame = nextFrame(videoStepper, reverse);
                    disp('before tracking');
                    [videoStepper, pointTracker, positive_examples, frame_types, old_tracking_points, bbox_points] = keyboard_track_bbox(videoStepper, pointTracker, videoPlayer, positive_examples, frame_types, videoFrame, old_tracking_points, bbox_points, annotation_mode, reverse, mp);
                    iters = iters + 1;
                end
            case '1'
                mp.MODULUS = 10
            case '2'
                mp.MODULUS = 20
            case '3'
                mp.MODULUS = 30
            case '4'
                mp.MODULUS = 40
            case '5'
                mp.MODULUS = 50
            case '6'
                mp.MODULUS = 60
            case '7'
                mp.MODULUS = 70
            case '8'
                mp.MODULUS = 80
            case '9'
                mp.MODULUS = 90
        end
    end

    releaseReader(videoStepper); % Not sure if this would have a bug if we don't release it properly
    release(videoPlayer);
    close
end
  