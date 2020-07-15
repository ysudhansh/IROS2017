function [w, wkps, wkpl] = keypointWeights(seq, frm, id)

[wkps, ~, new_seq_frm_id] = keypointLocalizations(seq, frm, id);
seq = new_seq_frm_id(:,1)';
frm = new_seq_frm_id(:,2)';
id = new_seq_frm_id(:,3)';
tracklets_data = tracklets(seq, frm, id);
kp_lookup = importdata("kpLookup_azimuth.mat");
kp_lookup = kp_lookup';
ry = tracklets_data(:,size(tracklets_data,2));
azimuth = rad2deg(ry + pi/2) + 10*rand();
wkpl = [];
for i=1:size(azimuth,1)
    if (round(azimuth(i)) >= 1) % changing floor to round all around; just for later reference of changes because git can get irritating xD
        wkpl = [wkpl, kp_lookup(:,round(azimuth(i))) ./ sum(kp_lookup(:, round(azimuth(i))))];
    else
        wkpl = [wkpl, kp_lookup(:,360 - abs(round(azimuth(i)))) ./ sum(kp_lookup(:, 360 - abs(round(azimuth(i)))))];
    end
end
% size(wkps)
% size(wkpl)
w = 0.7 * wkps + 0.3 * wkpl;
min = 0.1;
[r,c] = find(w < min);
for i=1:length(r)
    w(r(i), c(i)) = min;
end

end