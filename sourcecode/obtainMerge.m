function map = obtainMerge(L,map,nThreshold)
% %
adjacentBarrierNew = map.adjacentBarrierNew;
adjacent = map.adjacent;
barrierHeight = map.barrierHeight;
indexMatrix = map.indexMatrix;
label = map.label;
minVline = map.minVline;
% remove the adjacent region with the boudary of the map
index = adjacentBarrierNew(:,1) ~= 0 & adjacentBarrierNew(:,2) ~= 0;
adjacentBarrierNew = adjacentBarrierNew(index,:);

% construct the matrix for the adjacent matrix
lineageMatrix = zeros(max(indexMatrix(:,2)));
merge = [];

for i = 1:size(adjacentBarrierNew,1)
    lineageMatrix(adjacentBarrierNew(i,1),adjacentBarrierNew(i,2)) = barrierHeight(i);
    lineageMatrix(adjacentBarrierNew(i,2),adjacentBarrierNew(i,1)) = barrierHeight(i);
    if barrierHeight(i) < 2
        temp = [adjacentBarrierNew(i,1),adjacentBarrierNew(i,2)];
        merge = [merge; temp];
    end
end


map.lineageMatrix1 = lineageMatrix;
matrix = lineageMatrix;



% merge those basins with small differences


% get the merged pairs which are the cycle
for s = 1:size(matrix,1);
    [~,i2,i3] = unique(matrix(:,s));
    if length(i2) < 2
        break
    end
    t1 = i2(2);
    if length(find(i3 == 2)) ==1
    [~,~,i2] = unique(matrix(:,t1));
    if max(i2) < 2
        break
    end
    t2 = find(i2 == 2);
    if length(t2) < 2 & s == t2
        temp = sort([s t1]);
        if sum(ismember(adjacentBarrierNew,temp,'rows')) > 0
            merge = [merge;temp];
        end
    end
    end
end


mergePair = [];
temp = unique(L(:));
boundary = [L(:,1)' L(1,:) L(end,:) L(:,end)'];
bdRegionIndex = unique(boundary);
temp = setdiff(temp,bdRegionIndex);

% extract the index of basin where only one was labeled
single = [];
for i = 2:length(temp)
   temp1 = str2double(label(L == temp(i)));
   temp1(isnan(temp1)) = [];
   if length(temp1) < nThreshold
       single = [single;temp(i)];
   end
end
% translate single to the new index
[~,idx] = ismember(single,indexMatrix(:,1));
idx1 = idx ~= 0;
temp_1 = indexMatrix(:,2);
singleNew = temp_1(idx(idx1,:));


% merge the basin where only one was labled with its adjacent one 
for i = 1:length(singleNew)
   temp = find(sum(adjacentBarrierNew == singleNew(i),2) == 1);
   [a,index] = min(barrierHeight(temp));
   mergePair = [mergePair;adjacentBarrierNew(temp(index),:)];   
end

mergePair = unique(mergePair,'rows');

merge = unique(merge,'rows');

map.merge = [merge;mergePair];
map.matrix = matrix;