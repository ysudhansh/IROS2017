function [wireframe_collection, def_vector_collection] = approxAlignWireframe(seq, frm, id)

K = [721.53,0,609.55;0,721.53,172.85;0,0,1];
[old_wireframe, old_def_vectors] = initialTransformations();
tracklets_data = tracklets(seq, frm, id);
ry = tracklets_data(:,8);
phi = ry + pi/2 + rand(size(ry))/10;
B = mobili(seq, frm, id);
T = B(:,4:6)';
wireframe_collection = [];
def_vector_collection = [];
for i=1:size(phi,1)
    R_y = roty(rad2deg(phi(i)) + 10 * rand());
    new_wireframe = R_y * old_wireframe;
    new_wireframe_translated = new_wireframe + T(:,i);
    new_wireframe_temp = K * new_wireframe_translated;
    new_wireframe_img = [new_wireframe_temp(1,:) ./ new_wireframe_temp(3,:); new_wireframe_temp(2,:) ./ new_wireframe_temp(3,:)];
    wireframe_collection = [wireframe_collection; new_wireframe_translated];
    new_def_vectors = zeros(size(old_def_vectors));
    for j = 1:size(old_def_vectors,1)
        in = reshape(old_def_vectors(j,:),3,14);
        out = R_y * in;
        new_def_vectors(j,:) = reshape(out,size(old_def_vectors(j,:)));
    end
    def_vector_collection = [def_vector_collection; new_def_vectors];

end

end

