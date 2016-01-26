function bbox = linear_average_bbox(positive_examples, alpha, t_before, t_after)
    % positive_examples.true_tracked_bboxes should be the same as positive_examples.true_bboxes for the indices that do indeed have true_bboxes
    bbox_before = positive_examples.true_tracked_bboxes(:, :, t_before);
    bbox_after = positive_examples.true_tracked_bboxes(:, :, t_after) ;
    assert(norm(bbox_before) ~= 0 && norm(bbox_after) ~= 0);
    bbox = alpha*bbox_before + (1-alpha)*bbox_after;
end