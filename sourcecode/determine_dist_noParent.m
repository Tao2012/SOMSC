function cell_dist = determine_dist_noParent(info_vector)

direct_v = info_vector(1:2:end);
[minV, ind] = min(direct_v);
sign = ind;
dist = minV;
cell_dist = [sign dist];
end