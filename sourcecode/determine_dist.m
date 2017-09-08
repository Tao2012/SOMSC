function cell_dist = determine_dist(info_vector)

dist = info_vector(end);
dist_vector = info_vector(1:end-1);

% get all direction
direct_vector = dist_vector(1:2:end);
dist_v = dist_vector(2:2:end);

% define the max
Max_value = ceil(max(dist_vector(2:2:end)))+1;

if isempty(find(direct_vector > 0, 1))
   sign = 0;
   order_index = dist;
else
   dist_v(direct_vector <= 0) = Max_value;
   [~,ind] = min(dist_v);
   if ind < 2
      sign = -1; 
   else
       sign = ind - 1;
   end
   order_index = direct_vector(ind);
end
cell_dist = [sign order_index];


