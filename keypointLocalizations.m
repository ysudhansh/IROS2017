function [wkps, keypoints_collection] = keypointLocalizations(seq, frm, id)

data = importdata("result_KP.txt");
tracklets_data = tracklets(seq, frm, id);
wkps = []; % Confidence value for that keypoint from the keypoint localization network
keypoints_collection = [];
for i=1:size(data,1)
    keypoints = reshape(data(i,:), [3 14]);
    keypoints(1,:) = keypoints(1,:) * abs(tracklets_data(i,4) - tracklets_data(i,6))/64;
    keypoints(2,:) = keypoints(2,:) * abs(tracklets_data(i,5) - tracklets_data(i,7))/64;
    keypoints(1:2,:) = keypoints(1:2,:) + [tracklets_data(i,4); tracklets_data(i,5)];
    keypoints_collection = [keypoints_collection; keypoints(1:2,:)];
    wkps = [wkps, keypoints(3,:)'];
end

end