function plotRunthrough(seq, frm, id)

% data = importdata("result_KP.txt");
tracklets_data = tracklets(seq, frm, id);
B = mobili(seq, frm, id);
carCenters = B(:,4:6);
K = [721.53,0,609.55;0,721.53,172.85;0,0,1];
[wkps, data] = keypointLocalizations(seq, frm, id);
approx_aligned_wireframe_collection = approxAlignWireframe(seq, frm, id);
pose_optimized_wireframe_collection = poseOptimizer(seq, frm, id);
shape_optimized_wireframe_collection = shapeOptimizer(seq, frm, id);
reprojection_errors = [];
viewpoint_errors = [];
rmse = [];

for i=1:size(seq,1)
%     keypoints = reshape(data(i,:), [3 14]);
%     keypoints(1,:) = keypoints(1,:) * abs(tracklets_data(i,4) - tracklets_data(i,6))/64;
%     keypoints(2,:) = keypoints(2,:) * abs(tracklets_data(i,5) - tracklets_data(i,7))/64;
%     keypoints(1:2,:) = keypoints(1:2,:) + [tracklets_data(i,4); tracklets_data(i,5)];
    keypoints = data(2*i-1:2*i,:);
    
    approx_aligned_wf = approx_aligned_wireframe_collection(3*i-2:3*i,:);
    approx_proj_wf = K * approx_aligned_wf;
    approx_wf_img = [approx_proj_wf(1,:) ./ approx_proj_wf(3,:); approx_proj_wf(2,:) ./ approx_proj_wf(3,:)];
%     length_vec = (approx_aligned_wf(:,1) + approx_aligned_wf(:,2))/2 - (approx_aligned_wf(:,3) + approx_aligned_wf(:,4))/2;
    length_vec = (approx_aligned_wf(:,18) + approx_aligned_wf(:,36))/2 - (approx_aligned_wf(:,11) + approx_aligned_wf(:,29))/2;
    approx_azimuth = rad2deg(acos(dot(length_vec, [0;0;1]) / norm(length_vec)));
    approx_rmse = sqrt(mean((mean(approx_aligned_wf') - carCenters(i,:)) .^ 2));
    
    pose_opt_wf = pose_optimized_wireframe_collection(3*i-2:3*i,:);
    pose_opt_proj_wf = K * pose_opt_wf;
    pose_opt_wf_img = [pose_opt_proj_wf(1,:) ./ pose_opt_proj_wf(3,:); pose_opt_proj_wf(2,:) ./ pose_opt_proj_wf(3,:)];
    length_vec = (pose_opt_wf(:,18) + pose_opt_wf(:,36))/2 - (pose_opt_wf(:,11) + pose_opt_wf(:,29))/2;
    pose_azimuth = rad2deg(acos(dot(length_vec, [0;0;1]) / norm(length_vec)));
    pose_rmse = sqrt(mean((mean(pose_opt_wf') - carCenters(i,:)) .^ 2));
    
    shape_opt_wf = shape_optimized_wireframe_collection(3*i-2:3*i,:);
    shape_opt_proj_wf = K * shape_opt_wf;
    shape_opt_wf_img = [shape_opt_proj_wf(1,:) ./ shape_opt_proj_wf(3,:); shape_opt_proj_wf(2,:) ./ shape_opt_proj_wf(3,:)];
    length_vec = (shape_opt_wf(:,18) + shape_opt_wf(:,36))/2 - (shape_opt_wf(:,11) + shape_opt_wf(:,29))/2;
    shape_azimuth = rad2deg(acos(dot(length_vec, [0;0;1]) / norm(length_vec)));
    shape_rmse = sqrt(mean((mean(shape_opt_wf') - carCenters(i,:)) .^ 2));

    errors = [sum(sum(abs(approx_wf_img - keypoints))); sum(sum(abs(pose_opt_wf_img - keypoints))); sum(sum(abs(shape_opt_wf_img - keypoints)))];
    reprojection_errors = [reprojection_errors, errors];
    
    if tracklets_data(i,8) + pi/2 >= 0 && tracklets_data(i,8) + pi/2 <= pi
        errors = abs([approx_azimuth; pose_azimuth; shape_azimuth] - rad2deg(tracklets_data(i,8) + pi/2));
    elseif tracklets_data(i,8) + pi/2 > pi
        errors = abs([approx_azimuth; pose_azimuth; shape_azimuth] - 360 + rad2deg(tracklets_data(i,8) + pi/2));
    else
        errors = abs([approx_azimuth; pose_azimuth; shape_azimuth] + rad2deg(tracklets_data(i,8) + pi/2));
    end
    viewpoint_errors = [viewpoint_errors, errors];
    
    errors = [approx_rmse; pose_rmse; shape_rmse];
    rmse = [rmse, errors];
    
    img = "left_colour_imgs/" + string(tracklets_data(i,1)) + "_" + string(tracklets_data(i,2)) + ".png";
    figure;
    
    subplot(2,2,1);
    imshow(img); 
    hold on;
    scatter(keypoints(1,:), keypoints(2,:), 100, "filled");
    title("Keypoints");
    
    subplot(2,2,2);
    visualizeWireframe2D(img, approx_wf_img);
    title("Approximately Aligned Wireframe");
    
    subplot(2,2,3);
    visualizeWireframe2D(img, pose_opt_wf_img);
    title("Pose Optimized Wireframe");
    
    subplot(2,2,4);
    visualizeWireframe2D(img, shape_opt_wf_img);
    title("Shape Optimized Wirerfame");
    
    pause(0.5);
    
end

figure; 
bar(reprojection_errors);
title("Reprojection Errors");
xlabel(["1 - Before Pose Opt";"2 - After Pose Opt";"3 - After Shape Opt"]);
ylabel("Error Values");

figure;
bar(viewpoint_errors);
title("Viewpoint Errors");
xlabel(["1 - Before Pose Opt";"2 - After Pose Opt";"3 - After Shape Opt"]);
ylabel("Error Values (in degrees)");

figure;
bar(rmse);
title("RMS Errors");
xlabel(["1 - Before Pose Opt";"2 - After Pose Opt";"3 - After Shape Opt"]);
ylabel("Error Values");

end