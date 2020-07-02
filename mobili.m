function B = mobili(seq, frm, id)

K = [721.53,0,609.55;0,721.53,172.85;0,0,1];
avgCarLength = 3.8600;
avgCarWidth = 1.6362;
avgCarHeight = 1.5208;
h = avgCarHeight;
n = [0; -1; 0];
[tracklets_data, ground_truth] = tracklets(seq, frm, id);
B = [];
for i=1:size(tracklets_data,1)
    b = [(tracklets_data(i,4) + tracklets_data(i,6))/2; tracklets_data(i,7); 1];
    op = (-h * inv(K) * b) ./ (n' * inv(K) * b);
    op = op + [0; -avgCarHeight/2; avgCarLength/2];
    B = [B; tracklets_data(i,1) tracklets_data(i,2) tracklets_data(i,3) op'];
end

error = abs(ground_truth - B); % Ignore 1st three columns, last three columns are all that matter.

end

