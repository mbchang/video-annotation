function [videoStepper, videoPlayer, pointTracker, positive_examples, frame_types, metaparameters] = set_up_video_annotation_clean(category, demo, file, is_reversed)
    %% Parse Arguments
    
    if ~exist('demo','var') || isempty(demo)
        demo = 0;
    end
    
    if ~exist('file', 'var') || isempty(file)
        file = 'v_ShavingBeard_g01_c01_Converted';  % TODO: Change this 
    end
    
    if ~exist('is_reversed', 'var') || isempty(is_reversed)
        is_reversed = 0;
    end
        
    %% Set up Paths
    ext = '.mat';
    filename = [file ext];
    
    % current working directory should be VideoAnnotationTool
        
    working_directory = '.'; % current working directory
    data_directory = 'data'; % contains videos in matfile format, where the video is saved in variable called 'video'
    
    addpath(genpath(working_directory));
    addpath(genpath(data_directory));

    %% Initialize Objects
    
    % A wrapper object for the video
    videoStepper = VideoStepper(filename, is_reversed);  
    
    % An object that plays video frames
    videoPlayer = vision.VideoPlayer();  % an object that plays video frames

    % Create a point tracker and enable the bidirectional error constraint to
    % make it more robust in the presence of noise and clutter.
    pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

    %% Initialize Metaparameters
    
    % metaparameter array to hold constants for use in other functions 
    metaparameters = [];

    % Find the total number of frames
    metaparameters.NUM_FRAMES = videoStepper.numFrames;

    % Label a ground truth every MODULUS frames. Modulus index is 1 because MATLAB starts indexing at 1;
    metaparameters.MODULUS = 10;
    metaparameters.MODULUS_INDEX = 1;  % TODO: Unnecessary I think
    
    % Shrink factor for tracking box to bounding box
    metaparameters.SCALE_FACTOR = 0.8;
    
    % Threshold for how many tracking points we need for us to be confident
    % we are still tracking the shaver
    metaparameters.TRACKING_THRESHOLD = 5;

    %% Create Files to Cache Info  
    pos_ex_file_name = [data_directory '/positive_examples/' file '_' category '.mat'];
    frame_types_file_name = [data_directory '/frame_types/' file '_' category '.mat'];
    
    if exist( pos_ex_file_name, 'file' )
        disp('existed')
        positive_examples_file = matfile(pos_ex_file_name);
        positive_examples = positive_examples_file.positive_examples;
        
        frame_types_file = matfile(frame_types_file_name);
        frame_types = frame_types_file.frame_types;
    else
        % Create new
        disp('create new')
        positive_examples = struct('filename', filename, 'bboxes', zeros(4, 2, metaparameters.NUM_FRAMES), 'corrected_bboxes', zeros(4, 2, metaparameters.NUM_FRAMES), 'before_correction_bboxes', zeros(4, 2, metaparameters.NUM_FRAMES), 'true_tracked_reverse_bboxes', zeros(4, 2, metaparameters.NUM_FRAMES), 'true_tracked_bboxes', zeros(4, 2, metaparameters.NUM_FRAMES), 'true_bboxes', zeros(4, 2, metaparameters.NUM_FRAMES)); % bboxes(:,:,frame) is the bounding box for that frame
        frame_types = cell(metaparameters.NUM_FRAMES, 2);
        for i = 1:metaparameters.NUM_FRAMES
            frame_types{i, 1} = i; 
        end
    end
end