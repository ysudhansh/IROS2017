function [transformed_coords, transformed_deformation_vectors] = initialTransformations()

[wireframe, deformation_vectors] = scaleWireframe();
R = [-1 0 0; 0 0 -1; 0 -1 0]'; % World frame (world coordinate system) to camera frame (camera coordinate system)
transformed_coords = R * wireframe;

transformed_deformation_vectors = zeros(size(deformation_vectors));
for i = 1:size(deformation_vectors,1)
    in = reshape(deformation_vectors(i,:),3,14);
    out = R * in;
    transformed_deformation_vectors(i,:) = reshape(out,size(deformation_vectors(i,:)));
end

end
