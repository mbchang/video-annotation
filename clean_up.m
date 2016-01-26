function clean_up(videoStepper, videoPlayer, pointTracker)
    releaseReader(videoStepper); % Not sure if this would have a bug if we don't release it properly
    release(videoPlayer);
    release(pointTracker);
end