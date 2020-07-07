function w = keypointWeightsShape(seq, frm, id)

[w, wkps, wkpl] = keypointWeights(seq, frm, id);
w = 0.2 * wkps + 0.8 * wkpl;
min = 0.1;
[r,c] = find(w < 0.05 * min);
for i=1:length(r)
    w(r(i), c(i)) = 0.05 * min;
end

end