function bbox = tracking_average_bbox(positive_examples, alpha, t)
    % The alpha already encodes information about t_before and t_after that
    % denote the true bboxes.
    % positive_examples.true_tracked_bboxes and positve_examples.true_tracked_reverse_bboxes should be the same as positive_examples.true_bboxes for the indices that do indeed have true_bboxes
    
    % This is so that the true_tracked_reverse_bbox always gets precedent
    if alpha == 1
        alpha = 0;
    end
    
    forward_bbox = positive_examples.true_tracked_bboxes(:, :, t);
    reverse_bbox = positive_examples.true_tracked_reverse_bboxes(:, :, t);
    
    if norm(reverse_bbox) == 0 || norm(forward_bbox) == 0% The reverse_bbox had better correct the mistake that the forward_bbox drew a bbox when the shaver wasn't there. This should be two-way though.
        % We don't have norm(forward_bbox) == 0, because we assume that the
        % reverse_bbox corrects for it
        bbox = zeros(4,2);
    else
        assert(norm(forward_bbox) ~= 0 && norm(reverse_bbox) ~= 0);
        bbox = alpha*forward_bbox + (1-alpha)*reverse_bbox;
    end
end