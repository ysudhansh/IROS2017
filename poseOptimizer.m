function [wireframe_collection, def_vectors_collection, rotation_collection, translation_collection] = poseOptimizer(seq, frm, id)

numViews = 1;
numPts = 36;
numObs = 36;
K = [721.53,0,609.55;0,721.53,172.85;0,0,1];
avgCarLength = 3.8600;
avgCarWidth = 1.6362;
avgCarHeight = 1.5208;
B = mobili(seq, frm, id);
carCenters = B(:,4:6);
[wireframe, def_vectors] = approxAlignWireframe(seq, frm, id);
observation_wts = keypointWeights(seq, frm, id);
[wkps, keypoints_collection] = keypointLocalizations(seq, frm, id);
lambda = [0.250000 0.270000 0.010000 -0.080000 -0.050000];
wireframe_collection = [];
% def_vectors_collection = def_vectors;
def_vectors_collection = [];
rotation_collection = [];
translation_collection = [];
wf_img_collection = [];

for i=1:size(frm,2)   
    fileID = fopen("ceres/ceres_input_singleViewPoseAdjuster.txt","w");
    fprintf(fileID, "%d %d %d\n", [numViews, numPts, numObs]);
    fprintf(fileID, "%f %f %f\n", [carCenters(i,1), carCenters(i,2), carCenters(i,3)]);
    fprintf(fileID, "%f %f %f\n", [avgCarHeight, avgCarWidth, avgCarLength]);
    fprintf(fileID, "%f %f %f %f %f %f %f %f %f\n", reshape(K',[1 9]));
    fprintf(fileID, "%f %f\n", keypoints_collection(2*i-1:2*i,:));
    fprintf(fileID, "%f\n", observation_wts(:,i));  
    fprintf(fileID, "%f %f %f\n", wireframe(3*i-2:3*i,:));
    for j=1:42
        for k=1:3:108
            fprintf(fileID, "%f %f %f ", def_vectors(42*(i-1) + j, k : k+2)); 
        end
        fprintf(fileID, "\n");
    end
    fprintf(fileID, "%f %f %f %f %f\n", lambda);
    fclose(fileID);
    
    commands = "cd ceres; ./singleViewPoseAdjuster; cd -";
    system(commands);
    
    data = importdata("ceres/ceres_output_singleViewPoseAdjuster.txt");
    r = data(1:9);
    T = data(10:12);
    R = reshape(r, [3 3]);
    rotation_collection = [rotation_collection, r];
    translation_collection = [translation_collection, T];
    pose_opt_wireframe = (R * wireframe(3*i-2:3*i,:)) + T;
    wireframe_collection = [wireframe_collection; pose_opt_wireframe];
end

end