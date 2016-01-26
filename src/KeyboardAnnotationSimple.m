%{
Note: Whatever is in < > represents a variable

Usage:
    1. Make sure <category> is correct
    2. Make sure <name> is correct (this is the name of the video without
        the extension)
    3. Run the script
    4. A window called "Figure 1" will appear. Click on the window and
        press "g." This will start the first frame of the video.
    5. Forward Tracking: Annotate the video, and press "q" when done. 
        (If it takes too long after pressing "q", press "Ctrl-c.")
    6. Visualize Annotations: Afterwards, the video will play to allow 
        you to review the annotations
    7. Correct: Same as 4 and 5, but this is the last time you will
        annotate the video before it is saved.
    8. Save Annotations: Saves positive_frames and frame_types
        - positive_frames.bboxes contains your final annotations
        - frame_types contains information about how you labeled the frames
            (this was used for debugging, and can be ignored)
%}

%% Setup
category = 'face';  % change this to the object category you are annotating
name = 'v_ShavingBeard_g01_c01_Converted';  % name of video  world1_1.mp4
    
[videoStepper, videoPlayer, pointTracker, positive_examples, frame_types, mp] = set_up_video_annotation_clean(category, 0, name);
 
%% Forward Tracking
disp('Forward Annotation');
[positive_examples, frame_types] = KeyboardAnnotation(videoStepper, videoPlayer, pointTracker, positive_examples, frame_types, 'forward', mp);
positive_examples.bboxes = positive_examples.true_tracked_bboxes;
disp('Press q to continue');

%% Visualize Annotations
disp('visualize')
visualize_positive_examples(positive_examples.bboxes, videoStepper, videoPlayer, mp, 0);

%% Correct
disp('take out mistakes')
assert(videoStepper.currentFrame == 0)
disp(videoStepper.currentFrame)
positive_examples.before_correction__bboxes = positive_examples.bboxes; %
% [positive_examples, frame_types] = correct_mistakes(videoStepper, videoPlayer, positive_examples, frame_types, mp);
[positive_examples, frame_types] = KeyboardAnnotation(videoStepper, videoPlayer, pointTracker, positive_examples, frame_types, 'correct', mp);
disp('Press q to continue');

%% Save Annotations
disp('Saving...');
save(['data/positive_examples/' name '_' category '.mat'],'positive_examples');%, '-v7.3');
save(['data/frame_types/' name '_' category '.mat'],'frame_types');%, '-v7.3');
