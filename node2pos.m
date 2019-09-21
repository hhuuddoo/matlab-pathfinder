function [position] = node2pos(node, parentArray)

[row,col] = ind2sub(size(parentArray),node);

position = [row, col];

end