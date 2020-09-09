function computeErrors(seqID, start_frm, end_frm, carID)

seq = seqID * ones(1, end_frm - start_frm + 1);
frm = start_frm : end_frm;
id = carID * ones(1, end_frm - start_frm + 1);
[tracklets_data,ground_truth] = tracklets(seq, frm, id);
ground_truth = ground_truth(:,4:6);
ry = tracklets_data(:,8);
opt_data = importdata(string(seqID) + "_" + string(start_frm) + "_" + string(end_frm) + "_" + string(carID) + ".txt");
opt_pose = opt_data(:,10:12);
camera_heading = [0;0;1];
opt_ry = opt_data(:, 1:9);
angle_errors = [];
for i=1:size(opt_ry,1)
    R = reshape(opt_ry(i,:), [3 3])';
    length_vec = R * camera_heading;
    length_vec(2) = 0;
    new_ry = rad2deg(acos(dot(length_vec, [0;0;1]) / norm(length_vec)));
    if ry(i) + pi/2 >= 0 && ry(i) + pi/2 <= pi
        error = abs(new_ry - rad2deg(ry(i) + pi/2));
    elseif ry(i) + pi/2 > pi
        error = abs(new_ry - 360 + rad2deg(ry(i) + pi/2));
    else
        error = abs(new_ry + rad2deg(ry(i) + pi/2));
    end
    angle_errors = [angle_errors; error];
end
f = fopen("errors.txt","a");
fprintf(f, "%f %f\n", mean(sqrt(sum((ground_truth - opt_pose) .^ 2,2))), mean(angle_errors));
fclose(f);
end