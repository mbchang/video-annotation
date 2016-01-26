function visualize_positive_examples(pos_ex_bboxes, videoStepper, videoPlayer, mp, delay)
    releaseReader(videoStepper); % Not sure if this would have a bug if we don't release it properly
    release(videoPlayer);
    for t = 1:mp.NUM_FRAMES
        frame = nextFrame(videoStepper);
        bbox_points = pos_ex_bboxes(:,:,t);
        bboxPolygon = reshape(bbox_points', 1, []);

        frame = insertShape(frame, 'Polygon', bboxPolygon, 'LineWidth', 2); % draw bounding box
        pause(delay);
        step(videoPlayer, frame);
        close;
    end
    releaseReader(videoStepper); % Not sure if this would have a bug if we don't release it properly
    release(videoPlayer);
end