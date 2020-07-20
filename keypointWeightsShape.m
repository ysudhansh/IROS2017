function w = keypointWeightsShape(seq, frm, id)

[~, wkps, wkpl] = keypointWeights(seq, frm, id);
w = 0.8 * wkps + 0.2 * wkpl;
min = 0.01;
[r,c] = find(w < min);
for i=1:length(r)
    w(r(i), c(i)) = min;
end

end