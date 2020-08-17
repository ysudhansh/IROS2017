function w = keypointWeightsShape(seq, frm, id)

[~, wkps, wkpl] = keypointWeights(seq, frm, id);
w = 0.3 * wkps + 0.7 * wkpl;
min = 0.001;
[r,c] = find(w < min);
for i=1:length(r)
    w(r(i), c(i)) = min;
end

end