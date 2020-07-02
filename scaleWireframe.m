function [wireframe_scaled, transformed_deformation_vectors] = scaleWireframe()

% Retrieve data from meanShape.txt, and use that to visualize the wireframe
% of the mean shape of the car.

wireframe = importdata("meanShape.txt");
wireframe = wireframe';
% visualizeWireframe3D(wireframe);

% From the visualization, we can observe the following:
% Length: Y-axis is along front to back direction of the car; best measured
% between L_HeadLight and L_TailLight
% Width: X-axis is along right to left direction of the car; best measured
% between L_F_WheelCenter and R_F_WheelCenter
% Height: Z-axis is along bottom to top direction of the car; best measured
% between L_B_RoofTop and L_B_WheelCenter

length_vec = [wireframe(1,5) - wireframe(1,7); wireframe(2,5) - wireframe(2,7); wireframe(3,5) - wireframe(3,7)];
width_vec = [wireframe(1,1) - wireframe(1,2); wireframe(2,1) - wireframe(2,2); wireframe(3,1) - wireframe(3,2)];
height_vec = [wireframe(1,3) - wireframe(1,13); wireframe(2,3) - wireframe(2,13); wireframe(3,3) - wireframe(3,13)];

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

wireframe_scaled = [wireframe(1,:) * width_scale; wireframe(2,:) * length_scale; wireframe(3,:) * height_scale];

deformation_vectors = importdata("vectors.txt");
transformed_deformation_vectors = zeros(size(deformation_vectors));
for i = 1:size(deformation_vectors,1)
    in = reshape(deformation_vectors(i,:),3,14);
    in(1,:) = in(1,:) * width_scale;
    in(2,:) = in(2,:) * length_scale;
    in(3,:) = in(3,:) * height_scale;
    transformed_deformation_vectors(i,:) = reshape(in,size(deformation_vectors(i,:)));
end

end