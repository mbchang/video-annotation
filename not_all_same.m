function result = not_all_same(bbox_points)
    result = size(unique(bbox_points, 'rows'), 1) > 1; 
end