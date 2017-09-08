function map = uniqueRegion(L,map)

indexMatrix = map.indexMatrix;
adjacent = map.adjacent;
minVline = map.minVline;

% all adjacent barriers
A1 = ismember(adjacent(:,1),indexMatrix(:,1));
A2 = ismember(adjacent(:,2),indexMatrix(:,1));
A = A1.*A2;
barrierHeight = minVline(A == 1)';
adjacentBarrier = adjacent(A == 1,:);

% all the boundary
boundary = [L(:,1)' L(1,:) L(end,:) L(:,end)'];
bdRegionIndex = unique(boundary);
index = zeros(size(adjacentBarrier,1),1);
for i = 1:length(bdRegionIndex)
    index = index + sum(adjacentBarrier == bdRegionIndex(i),2);
end
barrierHeight = barrierHeight(index == 0);
adjacentBarrier = adjacentBarrier(index == 0,:);

% map all index to other index
[~,idx] = ismember(adjacentBarrier,indexMatrix(:,1));
temp_1 = indexMatrix(:,2);
adjacentBarrierNew = temp_1(idx);

% make the adjacent regions unique
sort_1 = sort(adjacentBarrierNew,2);
[sort_2,~,ia_1] = unique(sort_1,'rows');
temp2 = unique(ia_1);
heightNew = zeros(length(temp2),1);
for i = 1:length(temp2)
    heightNew(i) = min(barrierHeight(ia_1 == temp2(i)));
end
adjacentBarrierNew = sort_2;

adjacentBarrierNew = adjacentBarrierNew(adjacentBarrierNew(:,1) ~= 0,:);
%adjacentBarrierTime = adjacentBarrierTime(ic_1,:);
barrierHeight = heightNew;

map.adjacentBarrierNew = adjacentBarrierNew;
map.barrierHeight = barrierHeight;
