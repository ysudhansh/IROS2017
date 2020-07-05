function [tracklets, ground_truth] = tracklets(seq, frm, id)

parms = [seq; frm; id];
cd ~/rrc/IROS2017/devkit/matlab/;
[tracklets, ground_truth] = tracklets_helper(parms(1,:), parms(2,:), parms(3,:));

end