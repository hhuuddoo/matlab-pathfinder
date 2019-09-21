%% Pathfinder demonstration

A = zeros(10, 10); % Create empty 10 x 10 matrix
A(2:9, 5) = 1; % Create "wall" in center of screen

% Define coordinates to travel between
startPosition = [5, 4];
endPosition = [5, 6];

% Get best path and find the steps taken to destination
optimalPathCoordinates = pathfinder(startPosition, endPosition, A);
[steps, ~] = size(optimalPathCoordinates);

for i = 1:steps
    A(optimalPathCoordinates(i), optimalPathCoordinates(i + steps)) = 2; % Place 2 in each position of path
end

disp('0: Walkable area, 1: Walls, 2: Optimal path');
disp(' '); % New line
disp(A); % Display matrix
