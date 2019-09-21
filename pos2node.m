function [nodePosition] = pos2node(coords, parentArray)

nodePosition = sub2ind(size(parentArray),coords(1),coords(2));

end

