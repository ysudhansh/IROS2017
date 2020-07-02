function W = keypointWeightsShape(seq, frm, id)

[w, wkps, wkpl] = keypointWeights(seq, frm, id);
W = 0.8 * wkps + 0.2 * wkpl;

end