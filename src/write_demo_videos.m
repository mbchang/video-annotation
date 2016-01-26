annotation = 0;

addpath('/Users/MichaelChang/Documents/Researchlink/Michigan Research/Datasets/Extra/matfiles')
files = dir(fullfile('/Users/MichaelChang/Documents/Researchlink/Michigan Research/Datasets/Extra/matfiles/*.mat'));

for f = 1:size(files); 
    file = files(f);  % pick one file
%     disp(file.name);
    [pathstr,name,ext] = fileparts(file.name);
    if ~strcmp(name, 'v_ShavingBeard_g01_c01_Converted')
        disp(name)
        continue
    end
    
    if annotation
        AnnotationDemo(name, 1)
    else
        [videoStepper, videoPlayer, pointTracker, positive_examples, frame_types, mp] = set_up_video_annotation(1, name);

%         positive_examples = moving_average_estimate_bboxes(positive_examples, mp);

        writerObj = VideoWriter(['demo_videos/' name '_corrected_emphasized.avi']);
        open(writerObj);

        axis tight
        set(gca,'nextplot','replacechildren');
        set(gcf,'Renderer','zbuffer');

        for t = 1:mp.NUM_FRAMES
            frame = nextFrame(videoStepper);
            bbox_points = positive_examples.bboxes(:,:,t);
            bboxPolygon = reshape(bbox_points', 1, []);
            if norm(positive_examples.true_bboxes(:,:,t)) > 0
                frame = insertShape(frame, 'Polygon', bboxPolygon, 'LineWidth', 2, 'Color', 'green'); % draw bounding box
                for i=1:20
                   writeVideo(writerObj, frame);
                end
            else
                frame = insertShape(frame, 'Polygon', bboxPolygon, 'LineWidth', 2); % draw bounding box
                writeVideo(writerObj, frame);
            end
            close
        end
        releaseReader(videoStepper); 
        release(videoPlayer);
        close(writerObj);
        
        writerObj = VideoWriter(['demo_videos/' name '_corrected.avi']);
        open(writerObj);

        axis tight
        set(gca,'nextplot','replacechildren');
        set(gcf,'Renderer','zbuffer');

        for t = 1:mp.NUM_FRAMES
            frame = nextFrame(videoStepper);
            bbox_points = positive_examples.bboxes(:,:,t);
            bboxPolygon = reshape(bbox_points', 1, []);
            if norm(positive_examples.true_bboxes(:,:,t)) > 0
                frame = insertShape(frame, 'Polygon', bboxPolygon, 'LineWidth', 2, 'Color', 'green'); % draw bounding box
                writeVideo(writerObj, frame);
            else
                frame = insertShape(frame, 'Polygon', bboxPolygon, 'LineWidth', 2); % draw bounding box
                writeVideo(writerObj, frame);
            end
            close
        end
        releaseReader(videoStepper); 
        release(videoPlayer);
        close(writerObj);
    end
end
    
    
   