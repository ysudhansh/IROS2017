function [wkps, keypoints_collection, new_seq_frm_id] = keypointLocalizations(seq, frm, id)

info = importdata("infofile.txt");
indices = [];
new_seq_frm_id = [];
for i=1:size(seq,2)
    index = find(info(:,2) == seq(i) & info(:,3) == frm(i) & info(:,4) == id(i));
    indices = [indices; index];
    new_seq_frm_id = [new_seq_frm_id; info(index,2) info(index,3) info(index,4)];
end

kp = importdata("result_KP.txt");
data = [];
for i=1:size(indices,1)
    data = [data; kp(indices(i),:)];
end
tracklets_data = tracklets(seq, frm, id);
wkps = []; % Confidence value for that keypoint from the keypoint localization network
keypoints_collection = [];
for i=1:size(data,1)
    keypoints = reshape(data(i,:), [3 36]);
    keypoints(1,:) = keypoints(1,:) * abs(tracklets_data(i,4) - tracklets_data(i,6))/64;
    keypoints(2,:) = keypoints(2,:) * abs(tracklets_data(i,5) - tracklets_data(i,7))/64;
    keypoints(1:2,:) = keypoints(1:2,:) + [tracklets_data(i,4); tracklets_data(i,5)];
    keypoints_collection = [keypoints_collection; keypoints(1:2,:)];
    wkps = [wkps, keypoints(3,:)'];
end

end