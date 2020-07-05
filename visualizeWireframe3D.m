function [] = visualizeWireframe3D(wireframe)
% VISUALIZEWIREFRAME3D  Takes in a 3D car wireframe (3 x 14 matrix), and
% plots it in 3D while appropriately connecting vertices
% Number of keypoints for the car class
numKps = size(wireframe,2);

% Generate distinguishable colors with respect to a white background
colors = distinguishable_colors(numKps, [1, 1, 1]);

% Create a scatter plot of the wireframe vertices
scatter3(wireframe(1,:), wireframe(2,:), wireframe(3,:), repmat(2, 1, numKps), colors);
%axis([-10 10 -5 5 -5 5]);
view(60,180);
% scatter3(wireframe(1,:), wireframe(2,:), wireframe(3,:), 'filled', 'MarkerFaceColor', colors);
% Hold on, to plot the edges
hold on;

% Axis labels
xlabel('X');
ylabel('Y');
zlabel('Z');

% Generate distinguishable colors with respect to a black background
buf = 7; % Number of extra colors to generate
colors = distinguishable_colors(numKps+buf, [1, 1, 1]);
% Randomly permute colors
rng(5);
perm = randperm(numKps+buf);
colors(1:end, :) = colors(perm, :);

% Car parts (keypoints) are indexed in the following manner
% 1  ->  'L_B_WheelCenter'
% 2  ->  'L_F_WheelCenter'
% 3  ->  'L_F_WheelPt1'
% 4  ->  'L_F_WheelPt2'
% 5  ->  'L_F_WheelPt3'
% 6  ->  'L_F_WheelPt4'
% 7  ->  'L_B_WheelPt1'
% 8  ->  'L_B_WheelPt2'
% 9  ->  'L_B_WheelPt3'
% 10 ->  'L_B_WheelPt4'
% 11 ->  'L_B_Bumper'
% 12 ->  'L_TailLight'
% 13 ->  'L_BackGlass'
% 14 ->  'L_B_RoofTop'
% 15  ->  'L_F_RoofTop'
% 16  ->  'L_SideViewMirror'
% 17  ->  'L_HeadLight'
% 18  ->  'L_F_Bumper'
% 19  ->  'R_B_WheelCenter'
% 20  ->  'R_F_WheelCenter'
% 21  ->  'R_F_WheelPt1'
% 22  ->  'R_F_WheelPt2'
% 23  ->  'R_F_WheelPt3'
% 24  ->  'R_F_WheelPt4'
% 25  ->  'R_B_WheelPt1'
% 26  ->  'R_B_WheelPt2'
% 27  ->  'R_B_WheelPt3'
% 28 ->  'R_B_WheelPt4'
% 29 ->  'R_B_Bumper'
% 30 ->  'R_TailLight'
% 31 ->  'R_BackGlass'
% 32 ->  'R_B_RoofTop'
% 33  ->  'R_F_RoofTop'
% 34  ->  'R_SideViewMirror'
% 35  ->  'R_HeadLight'
% 36  ->  'R_F_Bumper'

% Plot text labels for car keypoints, using distinguishable colors
% Replace the numbers in text with the corresponding keypoint from above
% bgColor = [0.9, 0.9, 0.9]; 
% text(wireframe(1,1), wireframe(2,1), wireframe(3,1), '1', 'color', colors(1,:), 'BackgroundColor', bgColor);
% text(wireframe(1,2), wireframe(2,2), wireframe(3,2), '2', 'color', colors(2,:), 'BackgroundColor', bgColor);
% text(wireframe(1,3), wireframe(2,3), wireframe(3,3), '3', 'color', colors(3,:), 'BackgroundColor', bgColor);
% text(wireframe(1,4), wireframe(2,4), wireframe(3,4), '4', 'color', colors(4,:), 'BackgroundColor', bgColor);
% text(wireframe(1,5), wireframe(2,5), wireframe(3,5), '5', 'color', colors(5,:), 'BackgroundColor', bgColor);
% text(wireframe(1,6), wireframe(2,6), wireframe(3,6), '6', 'color', colors(6,:), 'BackgroundColor', bgColor);
% text(wireframe(1,7), wireframe(2,7), wireframe(3,7), '7', 'color', colors(7,:), 'BackgroundColor', bgColor);
% text(wireframe(1,8), wireframe(2,8), wireframe(3,8), '8', 'color', colors(8,:), 'BackgroundColor', bgColor);
% text(wireframe(1,9), wireframe(2,9), wireframe(3,9), '9', 'color', colors(9,:), 'BackgroundColor', bgColor);
% text(wireframe(1,10), wireframe(2,10), wireframe(3,10), '10', 'color', colors(10,:), 'BackgroundColor', bgColor);
% text(wireframe(1,11), wireframe(2,11), wireframe(3,11), '11', 'color', colors(11,:), 'BackgroundColor', bgColor);
% text(wireframe(1,12), wireframe(2,12), wireframe(3,12), '12', 'color', colors(12,:), 'BackgroundColor', bgColor);
% text(wireframe(1,13), wireframe(2,13), wireframe(3,13), '13', 'color', colors(13,:), 'BackgroundColor', bgColor);
% text(wireframe(1,14), wireframe(2,14), wireframe(3,14), '14', 'color', colors(14,:), 'BackgroundColor', bgColor);
% text(wireframe(1,15), wireframe(2,15), wireframe(3,15), '15', 'color', colors(1,:), 'BackgroundColor', bgColor);
% text(wireframe(1,16), wireframe(2,16), wireframe(3,16), '16', 'color', colors(2,:), 'BackgroundColor', bgColor);
% text(wireframe(1,17), wireframe(2,17), wireframe(3,17), '17', 'color', colors(3,:), 'BackgroundColor', bgColor);
% text(wireframe(1,18), wireframe(2,18), wireframe(3,18), '18', 'color', colors(4,:), 'BackgroundColor', bgColor);
% text(wireframe(1,19), wireframe(2,19), wireframe(3,19), '19', 'color', colors(5,:), 'BackgroundColor', bgColor);
% text(wireframe(1,20), wireframe(2,20), wireframe(3,20), '20', 'color', colors(6,:), 'BackgroundColor', bgColor);
% text(wireframe(1,21), wireframe(2,21), wireframe(3,21), '21', 'color', colors(7,:), 'BackgroundColor', bgColor);
% text(wireframe(1,22), wireframe(2,22), wireframe(3,22), '22', 'color', colors(8,:), 'BackgroundColor', bgColor);
% text(wireframe(1,23), wireframe(2,23), wireframe(3,23), '23', 'color', colors(9,:), 'BackgroundColor', bgColor);
% text(wireframe(1,24), wireframe(2,24), wireframe(3,24), '24', 'color', colors(10,:), 'BackgroundColor', bgColor);
% text(wireframe(1,25), wireframe(2,25), wireframe(3,25), '25', 'color', colors(11,:), 'BackgroundColor', bgColor);
% text(wireframe(1,26), wireframe(2,26), wireframe(3,26), '26', 'color', colors(12,:), 'BackgroundColor', bgColor);
% text(wireframe(1,27), wireframe(2,27), wireframe(3,27), '27', 'color', colors(13,:), 'BackgroundColor', bgColor);
% text(wireframe(1,28), wireframe(2,28), wireframe(3,28), '28', 'color', colors(14,:), 'BackgroundColor', bgColor);
% text(wireframe(1,29), wireframe(2,29), wireframe(3,29), '29', 'color', colors(11,:), 'BackgroundColor', bgColor);
% text(wireframe(1,30), wireframe(2,30), wireframe(3,30), '30', 'color', colors(12,:), 'BackgroundColor', bgColor);
% text(wireframe(1,31), wireframe(2,31), wireframe(3,31), '31', 'color', colors(13,:), 'BackgroundColor', bgColor);
% text(wireframe(1,32), wireframe(2,32), wireframe(3,32), '32', 'color', colors(14,:), 'BackgroundColor', bgColor);
% text(wireframe(1,33), wireframe(2,33), wireframe(3,33), '33', 'color', colors(13,:), 'BackgroundColor', bgColor);
% text(wireframe(1,34), wireframe(2,34), wireframe(3,34), '34', 'color', colors(14,:), 'BackgroundColor', bgColor);
% text(wireframe(1,35), wireframe(2,35), wireframe(3,35), '35', 'color', colors(13,:), 'BackgroundColor', bgColor);
% text(wireframe(1,36), wireframe(2,36), wireframe(3,36), '36', 'color', colors(14,:), 'BackgroundColor', bgColor);

 % Car Base
 edges = [11,10; 10,9; 9,8; 8,7; 7,6; 6,5; 5,4; 4,3; 3,18; 18,36; 36,21; 21,22; 22,23; 23,24; 24,25; 25,26; 26,27; 27,28; 28,29; 29,11];
 % Roof
 edges = [edges; 15,14; 14,32; 32,33; 33,15];
 % Windows and Windshields
 edges = [edges; 13,31; 34,16];
 % Connections between roof and windows level
 edges = [edges; 16,15; 13,14; 31,32; 34,33];
 % Connections between windows level and hood level
 edges = [edges; 13,12; 31,30; 34,35; 16,17];
 % Hood level
 edges = [edges; 12,30; 35,17];
 % Connections between hood level to car base
 edges = [edges; 12,11; 30,29; 17,18; 35,36];

% Generate distinguishable colors (equal to the number of edges). The
% second parameter to the function is the background color.
colors = distinguishable_colors(size(edges,1), [1, 1, 1]);

% Draw each edge in the plot
for i = 1:size(edges, 1)
    plot3(wireframe(1,[edges(i,1), edges(i,2)]), wireframe(2, [edges(i,1), edges(i,2)]), wireframe(3, [edges(i,1), edges(i,2)]), ...
        'LineWidth', 2, 'Color', colors(i,:));
end

% Plot title
title('3D Wireframe of the car');

hold off;

end
