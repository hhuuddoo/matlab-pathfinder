function [path] = pathfinder(sPoint, ePoint, A)
% function [path] = pathfinder(sPoint, ePoint, A)
% Array A must be a logical array, where black is walkable area (0)
% sPoint & ePoint are the start and end points respectively
% Returns a n x 2 array which contains x and y coordinates which have the
% steps for the optimal path

% Array dimentions
[maxR, maxC] = size(A);

% If both points are the same
if (sPoint == ePoint)
    path = sPoint;
    return;
end

openNodes = []; % Nodes yet to be explored
closedNodes = []; % Nodes that have been explored

startNode = pos2node(sPoint, A);
endNode = pos2node(ePoint, A);

H = pdist([sPoint; ePoint],'cityblock'); % Estimated distance from the current node to the end node.
G = pdist([sPoint; sPoint],'cityblock'); % Distance between the current node and the start node.
F = H + G; % The total distance.

% Add the start node to open nodes
openNodes = [startNode, startNode, H, G, F];

% Counter to make sure while loop doesn't overflow
safetyCounter = 0;

% Loop until the end is found
while isempty(openNodes) == 0
    
    [~, currentNodeIndex] = min(openNodes(:, 5)); % Get smallest F value
    currentNodeInfo = openNodes(currentNodeIndex, :); % Details about current node
    currentNode = openNodes(currentNodeIndex, 1); % Set current node
    
    % End is found
    if (currentNode == endNode)
        path = node2pos(currentNode, A);  
        parent = openNodes(currentNodeIndex, 2);
        while parent ~= startNode
            path = [path; node2pos(parent, A)];
            currentNodeIndex = closedNodes(:, 1) == parent;
            parent = closedNodes(currentNodeIndex, 2);
        end
        path = flipud([path; sPoint]);
        break;
    end
    
    % Remove current node from open nodes and add into closed nodes
    openNodes(currentNodeIndex, :) = [];
    closedNodes = [closedNodes; currentNodeInfo];
    
    % Coordinates of current node
    nodeCoordinates = node2pos(currentNode, A);
    yCoord = nodeCoordinates(1);
    xCoord = nodeCoordinates(2);
    
    % Define children of currentNode
    leftChild = [yCoord,xCoord-1];
    rightChild = [yCoord,xCoord+1];
    upChild = [yCoord-1,xCoord];
    downChild = [yCoord+1,xCoord];
    
    % Group children
    children = [leftChild; rightChild; upChild; downChild];
    
    for C = 1:4
        currentChildCoordinates = [children(C, 1), children(C, 2)]; % Childs Coords
        
        % If child is out of bounds, skip to next iteration
        if (currentChildCoordinates(1) <= 0 || currentChildCoordinates(1) > maxR)
            continue;
        elseif (currentChildCoordinates(2) <= 0 || currentChildCoordinates(2) > maxC)
            continue;
        end
        
        currentChildNode = pos2node(currentChildCoordinates, A); % Childs Node
        childInClosedNodes = ismember(currentChildNode, closedNodes(:, 1));
        childInOpenNodes = ismember(currentChildNode, openNodes(:, 1));
        
        
        
          % If child is on a wall, skip to next iteration
          if (A(children(C, 1), children(C, 2)) == 1)
              continue;
          end
        
        % If child node is in the closed nodes array, skip to next iteration
        if (childInClosedNodes == 1)
            continue;
        end
        
        % Estimated distance from the current node to the end node.
        childToEnd = pdist([currentChildCoordinates; ePoint],'cityblock'); 
        % Distance between the child node and the current node.
        childToCurrent = pdist([nodeCoordinates; currentChildCoordinates],'cityblock'); 
        
        % Create childs F, G and H values
        childG = currentNodeInfo(4) + childToCurrent;
        childH = childToEnd;
        childF = childG + childH;
        
        % Child is in open list
        if (childInOpenNodes == 1)
            openNodeChildIndex = openNodes(:, 1) == currentChildNode;
            openNodeChildInfo = openNodes(openNodeChildIndex, :);
            % If current child G is higher than open node child, skip to
            % next iteration
            if (childG >= openNodeChildInfo(4))
                continue;
            end
        end
        
        % Add the child to the open nodes
        openNodes = [openNodes; [currentChildNode, currentNode, childH, childG, childF]];
        
    end
    
    safetyCounter = safetyCounter + 1;
    if (safetyCounter > 50000)
        break;
    end
end
