function [alphas, left_boundaries, right_boundaries, start, finish] = moving_avg_scaling_factor(nonzero_indices_true, nonzero_indices_true_tracked, block)
    % Possible cases:
    %   size(differences) == 1: this means that there is one alpha
    %       special case: differences == 0, which means this was an isolated
    %       true_bbox
    %   size(differences) > 1: more than one alpha
    
    start = nonzero_indices_true_tracked(block, 1);
    finish = nonzero_indices_true_tracked(block, 2);
    true_in_block = nonzero_indices_true(nonzero_indices_true > start & nonzero_indices_true < finish); % a vector of the true indices within the range start and finish
    boundaries = [start; true_in_block; finish]; % this includes and start and finish. We do this because it could be that finish may not be a true bbox but we still want to count it as a boundary
    differences = diff(boundaries); % has size that is one less than boundaries
    
    % The if statement below is because if size(differences) == 1, then
    % repelem will perform horizontal concatenation, rather than the
    % vertical concatenation that we want.
    if size(differences) == 1
        denominators = repelem(differences, differences)'; % repeat the element differences(i), differences(i) times. size = finish-start
        left_boundaries = [repelem(boundaries(1:end-1), differences) boundaries(end-1)]'; % repeat the last left boundary for the last element
        right_boundaries = [repelem(boundaries(2:end), differences) boundaries(end)]'; % repeat the last right boundary for the right element
        assert(size(left_boundaries,1) == sum(differences)+1 && size(right_boundaries,1) == sum(differences)+1 && size(denominators,1) == sum(differences));
        if differences == 0 % Special case
            alphas = 0;
        else
            alphas = [bsxfun(@rdivide, right_boundaries(1:end-1) - (start:finish-1)', denominators); 0]; % 0 for the last element because it is assumed to be the ground truth
        end
    else
        denominators = repelem(differences, differences); % repeat the element differences(i), differences(i) times. size = finish-start
        left_boundaries = [repelem(boundaries(1:end-1), differences); boundaries(end-1)]; % repeat the last left boundary for the last element
        right_boundaries = [repelem(boundaries(2:end), differences); boundaries(end)]; % repeat the last right boundary for the right element
        assert(size(left_boundaries,1) == sum(differences)+1 && size(right_boundaries,1) == sum(differences)+1 && size(denominators,1) == sum(differences));
        alphas = [bsxfun(@rdivide, right_boundaries(1:end-1) - (start:finish-1)', denominators); 0]; % 0 for the last element because it is assumed to be the ground truth
    end
end