classdef VideoStepper < matlab.mixin.SetGet % We need this because in order to modify the object's properties, we need to pass it by reference
    properties
        currentFrame
        numFrames
        video
    end
    methods
        function this = VideoStepper(filename, is_reversed)
            [~,~,ext] = fileparts(filename);
                        
            if strcmp(ext, '.mat')
                videoObj = matfile(filename);
                this.video = videoObj.video;
                this.numFrames = size(this.video,4);
            else
                videoObj = vision.VideoFileReader(filename);
                v = vision.VideoPlayer();
                % Find the number of frames and preallocate enough space
                % for this.video
                num_frames = 0;
                while ~isDone(videoObj)
                    f = step(videoObj);
                    num_frames = num_frames + 1;
                end
                this.numFrames = num_frames;
                release(videoObj);
                
                this.video = zeros(size(f,1), size(f,2), 3, this.numFrames);
                cur_frame = 1;
                while ~isDone(videoObj)
                    this.video(:, :, :, cur_frame) = step(videoObj);
                end
                release(videoObj);
                disp(sum(sum(sum(sum(this.video)))));
            end 
            if is_reversed
                this.currentFrame = this.numFrames+1;
            else
                this.currentFrame = 0;
            end
            disp(size(this.video));
        end
        function set_reverse(this)
            this.currentFrame = this.numFrames+1;
        end
        function frame = nextFrame(this, reverse)
            if nargin < 2
                reverse = 0;
            end
            if reverse
                frame = previousFrame(this);  % not recursive because previousFrame doesn't call reverse
            else
                this.currentFrame = min(this.numFrames, this.currentFrame + 1);
                frame = this.video(:,:,:,this.currentFrame);
                disp(this.currentFrame);
            end
        end
        function frame = previousFrame(this, reverse)
            if nargin < 2
                reverse = 0;
            end
            if reverse
                frame = nextFrame(this);  % not recursive
            else
                this.currentFrame = max(1, this.currentFrame -1);
                frame = this.video(:,:,:,this.currentFrame);
                disp(this.currentFrame);
            end
        end
        function num_frames = get.numFrames(this)
            num_frames = this.numFrames;
        end
        function this = set.currentFrame(this,val)
            if ~isa(val,'numeric')
                error('Value must be numeric')
            end
            this.currentFrame = val;
        end
        function frame_num = get.currentFrame(this)
            frame_num = this.currentFrame;
        end
        function frame = getFrame(this, frame_num)
            frame = this.video(:,:,:,frame_num);
        end
        function result = isDone(this)
            result = this.currentFrame >= this.numFrames;
        end   
        function releaseReader(this)
            set(this, 'currentFrame', 0); %reset
        end
    end
end

