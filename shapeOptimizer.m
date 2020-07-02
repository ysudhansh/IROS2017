function wireframe_collection = shapeOptimizer(seq, frm, id)

numViews = 1;
numPts = 14;
numObs = 14;
K = [721.53,0,609.55;0,721.53,172.85;0,0,1];
avgCarLength = 3.8600;
avgCarWidth = 1.6362;
avgCarHeight = 1.5208;
B = mobili(seq, frm, id);
carCenters = B(:,4:6);
[wireframe, def_vectors] = approxAlignWireframe(seq, frm, id);
[wireframe_temp, def_vectors_temp, rotation_collection, translation_collection] = poseOptimizer(seq, frm, id);
observation_wts = keypointWeightsShape(seq, frm, id);
[wkps, keypoints_collection] = keypointLocalizations(seq, frm, id);
lambda = [0.250000 0.270000 0.010000 -0.080000 -0.050000];
wireframe_collection = [];

for i=1:size(frm,2)
    fileID = fopen("ceres/ceres_input_singleViewShapeAdjuster.txt","w");
    fprintf(fileID, "%d %d %d\n", [numViews, numPts, numObs]);
    fprintf(fileID, "%f %f %f\n", [carCenters(i,1), carCenters(i,2), carCenters(i,3)]);
    fprintf(fileID, "%f %f %f\n", [avgCarHeight, avgCarWidth, avgCarLength]);
    fprintf(fileID, "%f %f %f %f %f %f %f %f %f\n", reshape(K',[1 9]));
    fprintf(fileID, "%f %f\n", keypoints_collection(2*i-1:2*i,:));
    fprintf(fileID, "%f\n", observation_wts(:,i));  
    fprintf(fileID, "%f %f %f\n", wireframe(3*i-2:3*i,:));
    for j=1:5
       fprintf(fileID, "%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n", def_vectors(5*(i-1) + j, :)); 
    end
    fprintf(fileID, "%f %f %f %f %f\n", lambda);
    fprintf(fileID, "%f\n", rotation_collection(:,i));
    fprintf(fileID, "%f\n", translation_collection(:,i));
    fclose(fileID);
    commands = "cd ceres; ./singleViewShapeAdjuster; cd -";
    system(commands);
    new_wireframe = importdata("ceres/ceres_output_singleViewShapeAdjuster.txt")';
    wireframe_collection = [wireframe_collection; new_wireframe];
end

end