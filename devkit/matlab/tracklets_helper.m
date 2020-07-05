function [tracklets_op, ground_truth] = tracklets_helper(seq, frm, id)

label_dir = "~/rrc/IROS2017/training/label_02";
tracklets_op = [];
ground_truth = [];
for i=1:size(seq,2)
    seq_idx = seq(i);
    frm_idx = frm(i);
    zero_base_frm_idx = frm_idx + 1;
    carID = id(i);
    global_tracklets_set = readLabels(label_dir, seq_idx);
    for j=1:size(global_tracklets_set{zero_base_frm_idx},2)
        if global_tracklets_set{zero_base_frm_idx}(j).id == carID
            bbox_x1 = global_tracklets_set{zero_base_frm_idx}(j).x1;
            bbox_y1 = global_tracklets_set{zero_base_frm_idx}(j).y1;
            bbox_x2 = global_tracklets_set{zero_base_frm_idx}(j).x2;
            bbox_y2 = global_tracklets_set{zero_base_frm_idx}(j).y2;
            ry = global_tracklets_set{zero_base_frm_idx}(j).ry;
            t = [global_tracklets_set{zero_base_frm_idx}(j).t(1) global_tracklets_set{zero_base_frm_idx}(j).t(2) global_tracklets_set{zero_base_frm_idx}(j).t(3)];
            tracklets_op = [tracklets_op; seq_idx, frm_idx, carID, bbox_x1, bbox_y1, bbox_x2, bbox_y2, ry];
            ground_truth = [ground_truth; seq_idx, frm_idx, carID, t];
            break
        end
    end
    
end

cd ~/rrc/IROS2017/;

end