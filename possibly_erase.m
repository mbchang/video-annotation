function [videoStepper, pointTracker, positive_examples, frame_types] = possibly_erase(videoStepper, pointTracker, positive_examples, frame_types, annotation_mode)

    % I also want it to be that this will clear any tracked bboxes
    % immediately consecutive after this
    false_pos = [];
    disp('b');

    switch annotation_mode
        case 'forward'
            cur_frame = videoStepper.currentFrame+1; %minus because reverse
            while cur_frame <= videoStepper.numFrames && norm(positive_examples.true_tracked_bboxes(:,:,cur_frame)) > 0 && norm(positive_examples.true_bboxes(:,:,cur_frame)) == 0
                % if, for the immediate consecutive frame, the
                % tracked bbox exists but the true doesn't. The
                % assumption is that we make the computer track on
                % a frame that should have trackable
                % old_tracking_points. If not, then that means we
                % are trying to correct a mistake, which means all
                % the immediate subsequent tracking annotations
                % until the next true annotation should be erased
                false_pos = [false_pos cur_frame];
                cur_frame = cur_frame + 1;
            end
            % clear all of them
            fprintf('Erasing: < '); fprintf('%d ', false_pos); fprintf('>\n');
            positive_examples.true_tracked_bboxes(:,:,false_pos) = 0;
        case 'reverse'
            cur_frame = videoStepper.currentFrame-1; %minus because reverse
            while cur_frame <= videoStepper.numFrames && norm(positive_examples.true_tracked_reverse_bboxes(:,:,cur_frame)) > 0 && norm(positive_examples.true_bboxes(:,:,cur_frame)) == 0
                % if, for the immediate consecutive frame, the
                % tracked bbox exists but the true doesn't. The
                % assumption is that we make the computer track on
                % a frame that should have trackable
                % old_tracking_points. If not, then that means we
                % are trying to correct a mistake, which means all
                % the immediate subsequent tracking annotations
                % until the next true annotation should be erased
                false_pos = [false_pos cur_frame];
                cur_frame = cur_frame - 1;
            end
            % clear all of them
            fprintf('Erasing: < '); fprintf('%d ', false_pos); fprintf('>\n');
            positive_examples.true_tracked_reverse_bboxes(:,:,false_pos) = 0;
        case 'correct'
            cur_frame = videoStepper.currentFrame+1; %minus because reverse
            while cur_frame <= videoStepper.numFrames && norm(positive_examples.bboxes(:,:,cur_frame)) > 0 && norm(positive_examples.true_bboxes(:,:,cur_frame)) == 0
                % if, for the immediate consecutive frame, the
                % tracked bbox exists but the true doesn't. The
                % assumption is that we make the computer track on
                % a frame that should have trackable
                % old_tracking_points. If not, then that means we
                % are trying to correct a mistake, which means all
                % the immediate subsequent tracking annotations
                % until the next true annotation should be erased
                false_pos = [false_pos cur_frame];
                cur_frame = cur_frame + 1;
            end
            % clear all of them
            fprintf('Erasing: < '); fprintf('%d ', false_pos); fprintf('>\n');
            positive_examples.bboxes(:,:,false_pos) = 0;
    end
    
end