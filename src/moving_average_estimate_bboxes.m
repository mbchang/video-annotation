function positive_examples = moving_average_estimate_bboxes(positive_examples, mp)
    % Note that the assumption is that if a bounding box has been tracked,
    % then its value is not 0.
    
    % First, find all nonzero true bounding boxes
    true_norms = arrayfun(@(idx) norm(positive_examples.true_bboxes(:, :, idx)), 1:size(positive_examples.true_bboxes,3));
    nonzero_indices_true = find(true_norms)';

    % Second, find all the nonzero true tracked bounding boxes; these will
    % be our blocks
    norms = arrayfun(@(idx) norm(positive_examples.true_tracked_bboxes(:, :, idx)), 1:mp.NUM_FRAMES); % This should be a (1 x numFrames) vector
    edgeArray = diff([0; (norms(:) ~= 0); 0]);
    nonzero_indices_true_tracked = [find(edgeArray > 0) find(edgeArray < 0)-1]; %indices of the frames with nonzero bounding boxes. (2 x numBlobs). 1st col is startInd, 2nd col is endInd of blob (can be the same if blob is one element)
    
    % Second, find all the nonzero true tracked bounding boxes; these will
    % be our blocks
    r_norms = arrayfun(@(idx) norm(positive_examples.true_tracked_reverse_bboxes(:, :, idx)), 1:mp.NUM_FRAMES); % This should be a (1 x numFrames) vector
    r_edgeArray = diff([0; (r_norms(:) ~= 0); 0]);
    nonzero_indices_true_tracked_reverse = [find(r_edgeArray > 0) find(r_edgeArray < 0)-1]; %indices of the frames with nonzero bounding boxes. (2 x numBlobs). 1st col is startInd, 2nd col is endInd of blob (can be the same if blob is one element)
    
    % Loop through the nonzero blocks
    num_blocks = size(nonzero_indices_true_tracked_reverse,1);
    for block = 1:num_blocks % number of blocks
        [alphas, left_boundaries, right_boundaries, start, finish] = moving_avg_scaling_factor(nonzero_indices_true, nonzero_indices_true_tracked_reverse, block);
        frame_nums = (start:finish)';
        for i = 1:size(frame_nums)
            % Change the line below
            positive_examples.bboxes(:, :, frame_nums(i)) = tracking_average_bbox(positive_examples, alphas(i), frame_nums(i));
%             positive_examples.bboxes(:, :, frame_nums(i)) = mp.TRACKING_SF*tracking_average_bbox(positive_examples, alphas(i), frame_nums(i)) + (1-mp.TRACKING_SF)*linear_average_bbox(positive_examples, alphas(i), left_boundaries(i), right_boundaries(i));
%             positive_examples.bboxes(:, :, frame_nums(i)) = mp.TRACKING_SF*positive_examples.true_tracked_bboxes(:, :, frame_nums(i)) + (1-mp.TRACKING_SF)*linear_average_bbox(positive_examples, alphas(i), left_boundaries(i), right_boundaries(i));
        end
    end
    
    % Check that every frame that should have a bounding box has a non-zero
    % bounding box
    final_norms = arrayfun(@(idx) norm(positive_examples.bboxes(:, :, idx)), 1:mp.NUM_FRAMES); % This should be a (1 x numFrames) vector
    final_edgeArray = diff([0; (final_norms(:) ~= 0); 0]);
    nonzero_indices_final = [find(final_edgeArray > 0) find(final_edgeArray < 0)-1];
    if ~isequal(nonzero_indices_final, nonzero_indices_true_tracked_reverse)
        size(nonzero_indices_final)
        size(nonzero_indices_true_tracked_reverse)
        setdiff(nonzero_indices_final, nonzero_indices_true_tracked_reverse)
        setdiff(nonzero_indices_true_tracked_reverse, nonzero_indices_final)
        nonzero_indices_final
        nonzero_indices_true_tracked_reverse
    end
    
%     assert(isequal(nonzero_indices_final,
%     nonzero_indices_true_tracked_reverse)); % Not necessarily true
end