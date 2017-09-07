function map = addTextBarrier_distance_E(map,L,mat,sData,metricName)

% asign the values
zone = map.zone;
adjacent = map.adjacent;
row = map.row;
col = map.col;

%% Label the barrier height (minimum and mean values) between different regions
% remove the adjacent region with the boudary of the map
index = adjacent(:,1) ~= 0 & adjacent(:,2) ~= 0;
adjacent = adjacent(index,:);
%
minVline = zeros(size(adjacent,1),1);
label_L1 = L;
label_L = label_L1(:);
cell1 = str2double(map.label_cell);
% cell1 = map.label_cell;
cell = cell1(:);
% add the text of the height to boundary of the adjacent regions
for i = 1:size(adjacent,1)
    % the adjacent information
    temp = adjacent(i,:);
    index1 = cell(label_L == temp(1));
    index2 = cell(label_L == temp(2));
    % remove those NAN values
    index1(isnan(index1)) = [];
    index2(isnan(index2)) = [];
    % get the data
    if length(index1) > 1
        data1 = sData.data(index1,:);
    else
        index1 = [index1;index1];
        data1 = sData.data(index1,:);
    end
    if length(index2) > 1
        data2 = sData.data(index2,:);
    else
        index2 = [index2;index2];
        data2 = sData.data(index2,:);
    end
%     mean1 = mean(data1);
%     mean2 = mean(data2);
%     D = pdist2(mean1,mean2,metricName);
    D = pdist2(data1,data2,metricName);
%         minVline(i) = sum(sum(D))/(size(D,1)*size(D,2));
    if size(D,1) > 0 && size(D,2) > 0
        minVline(i) = min(min(D));
    else
        minVline(i) = 10000;    
    end
    % extract the elements on the barrier of the adjacent basins
    index = find(ismember(zone,temp,'rows'));
    tempRow = row(index);
    tempCol = col(index);
    idx = sub2ind(size(L), tempRow, tempCol);
    % extract the height of the barrier of the adjacent basins
    [~,ind] = min(mat(idx));
    % add the height to the barrier
    text(tempCol(ind), tempRow(ind), sprintf('%0.1f',minVline(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle','FontSize',14,'Color','r');
end

map.adjacent = adjacent;
map.minVline = minVline;