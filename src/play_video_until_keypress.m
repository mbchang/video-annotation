function play_video_until_keypress(videoStepper, videoPlayer, goSlow)
    % Keep looping until key press, which signals that a frame with a shaver is
    % about to appear. A figure will pop up, along with the videoplayer window.
    % Make sure that the figure, not the 
    finish=false;
    set(gcf,'CurrentCharacter','@'); % set to a dummy character
    while ~finish && ~isDone(videoStepper)
        if goSlow
            pause(0.05); % Slow the video down so the human can keep up and time keypress correctly
        end
        
        % do things in loop...
        step(videoPlayer, nextFrame(videoStepper));

        % check for keys
        k=get(gcf,'CurrentCharacter');
        if k~='@' % has it changed from the dummy character?
        set(gcf,'CurrentCharacter','@'); % reset the character
        % now process the key as required
        if k=='q'
            finish=true; 
            disp('q was pressed. Current Frame:');
        end
        end
    end
    disp(videoStepper.currentFrame);
end