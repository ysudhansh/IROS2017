function [wireframe_scaled, transformed_deformation_vectors] = scaleWireframe()

% Retrieve data from meanShape.txt, and use that to visualize the wireframe
% of the mean shape of the car.

wireframe = importdata("meanShape.txt")';

% From the visualization, we can observe the following:
% Length: Y-axis is along front to back direction of the car; best measured
% between L_HeadLight and L_TailLight
% Width: X-axis is along right to left direction of the car; best measured
% between L_F_WheelCenter and R_F_WheelCenter
% Height: Z-axis is along bottom to top direction of the car; best measured
% between L_B_RoofTop and L_B_WheelCenter

length_vec = (wireframe(:,18) + wireframe(:,36))/2 - (wireframe(:,11) + wireframe(:,29))/2;
width_vec = wireframe(:,7) - wireframe(:,25);
height_vec = (wireframe(:,15) + wireframe(:,14) + wireframe(:,33) + wireframe(:,32))/4 - (wireframe(:,6) + wireframe(:,7) + wireframe(:,25) + wireframe(:,24))/4;

length = norm(length_vec);
width = norm(width_vec);
height = norm(height_vec);

% Given: Average car length, width and height.
% Need: Scale the mean car shape to its average respective values.
% Scaling can be done by multiplying the scale factor to the 3D coordinates
% of each of the 14 keypoints. This can be done since the camera is located
% at the origin, which is also the center of the car.

avgCarLength = 3.8600;
avgCarWidth = 1.6362;
avgCarHeight = 1.5208;

length_scale = avgCarLength / length;
width_scale = avgCarWidth / width;
height_scale = avgCarHeight / height;

wireframe_scaled = [wireframe(1,:) * length_scale; wireframe(2,:) * height_scale; wireframe(3,:) * width_scale];

deformation_vectors = importdata("vectors.txt");
transformed_deformation_vectors = zeros(size(deformation_vectors));
for i = 1:size(deformation_vectors,1)
    in = reshape(deformation_vectors(i,:),3,36);
    in(1,:) = in(1,:) * length_scale;
    in(2,:) = in(2,:) * height_scale;
    in(3,:) = in(3,:) * width_scale;
    transformed_deformation_vectors(i,:) = reshape(in,size(deformation_vectors(i,:)));
end

end