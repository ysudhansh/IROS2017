function computeErrors(seqID, start_frm, end_frm, carID)

seq = seqID * ones(1, end_frm - start_frm + 1);
frm = start_frm : end_frm;
id = carID * ones(1, end_frm - start_frm + 1);
[~,tracklets_data] = tracklets(seq, frm, id);
tracklets_data = tracklets_data(:,4:6);
opt_data = importdata(string(seqID) + "_" + string(start_frm) + "_" + string(end_frm) + "_" + string(carID) + ".txt");
opt_data = opt_data(:,10:12);
f = fopen("errors.txt","a");
fprintf(f, "%f\n", mean(sqrt(sum((tracklets_data - opt_data) .^ 2,2))));
fclose(f);

end