function multiViewAdjuster(seqID, start_frm, end_frm, carID)

numFrames = end_frm - start_frm + 1;
seq = seqID .* ones(1, numFrames);
frm = start_frm:1:end_frm;
id = carID .* ones(1, numFrames);
numObs = 36;
numPts = 36;
numVecs = 42;
K = [721.53,0,609.55;0,721.53,172.85;0,0,1];
avgCarLength = 3.8600;
avgCarWidth = 1.6362;
avgCarHeight = 1.5208;
[~, ~, new_seq_frm_id] = keypointLocalizations(seq, frm, id);
seq = new_seq_frm_id(:,1)';
frm = new_seq_frm_id(:,2)';
id = new_seq_frm_id(:,3)';
numViews = length(frm);
B = mobili(seq, frm, id);
carCenters = B(:,4:6);
[wireframe, ~] = approxAlignWireframe(seq, frm, id);
[~, def_vectors, rotation_collection, translation_collection, lambdas_collection] = shapeOptimizer(seq, frm, id);
observation_wts = keypointWeightsShape(seq, frm, id);
[~, keypoints_collection] = keypointLocalizations(seq, frm, id);

fileID = fopen("ceres/ceres_input_multiViewAdjuster.txt","w");
fprintf(fileID, "%d %d %d %d\n", [numViews, numPts, numObs, numVecs]);
fprintf(fileID, "%f %f %f\n", [avgCarHeight, avgCarWidth, avgCarLength]);
fprintf(fileID, "%f %f %f %f %f %f %f %f %f\n", reshape(K',[1 9]));
for i=1:numViews
    fprintf(fileID, "%f %f %f\n", [carCenters(i,1), carCenters(i,2), carCenters(i,3)]);
end
for i=1:numViews
    fprintf(fileID, "%f %f\n", keypoints_collection(2*i-1:2*i,:));
end
for i=1:numViews
    fprintf(fileID, "%f\n", observation_wts(:,i));
end
for i=1:numViews
    fprintf(fileID, "%f %f %f\n", wireframe(3*i-2:3*i,:));
end
for i=1:numViews
    for j=1:42
        for k=1:3:108
            fprintf(fileID, "%f %f %f ", def_vectors(42*(i-1) + j, k : k+2)); 
        end
        fprintf(fileID, "\n");
    end
end
% for i=1:numViews
%     fprintf(fileID, "%f ", lambdas_collection(i,:));
%     fprintf(fileID, "\n");
% end
lambdas = mean(lambdas_collection);
fprintf(fileID, "%f ", lambdas);
fprintf(fileID, "\n");
for i=1:numViews
    fprintf(fileID, "%f\n", rotation_collection(:,i));
end
for i=1:numViews
    fprintf(fileID, "%f\n", translation_collection(:,i));
end
fclose(fileID);
system("cd ceres; ./multiViewAdjuster; cd ..");
multi_opt_wireframe = importdata("ceres/ceres_output_multiViewAdjuster.txt");
for i=1:length(frm)
    image = "left_colour_imgs/" + string(seq(i)) + "_" + string(frm(i)) + ".png";
    wireframe = multi_opt_wireframe(36*i-35:36*i,:)';
    proj_wf = K * wireframe;
    wf_img = proj_wf(1:2,:) ./ proj_wf(3,:);
    img = figure;
    visualizeWireframe2D(image, wf_img);
    saveas(img, sprintf("multiViewResult/%d_%d_%d.png", seq(i), frm(i), id(i)));
    close(img);
    pause(1);
end

system("ffmpeg -framerate 5 -start_number 35 -i 'multiViewResult/3_%d_1.png' -c:v libx264 -r 30  -vf 'pad=ceil(iw/2)*2:ceil(ih/2)*2' -pix_fmt yuv420p car1.mp4");
system("ffmpeg -framerate 5 -start_number 10 -i 'multiViewResult/3_%d_0.png' -c:v libx264 -r 30  -vf 'pad=ceil(iw/2)*2:ceil(ih/2)*2' -pix_fmt yuv420p car0.mp4");

end