function L =  merge_Region_final(L,map)

zone = map.zone;
adjacent = map.adjacent;
row = map.row;
col = map.col;
label = map.label;
minVline = map.minVline;
mergePair1 = map.merge;
indexMatrix = map.indexMatrix;
label1 = map.label_cell;
% map the boundary areas to the others
% get all boundaries elements
boundary = unique([L(:,1);L(:,end);L(1,:)';L(end,:)']);
boundaryNodes = unique(boundary);

[~,idx,~] = unique(indexMatrix(:,2));
temp = indexMatrix(idx,:);
indexMatrix2 = zeros(length(boundaryNodes),2);

for i = 1:length(boundaryNodes)
    temp1 = str2double(label1(L == boundaryNodes(i)));
    temp1(isnan(temp1)) = [];
    temp1 = sort(temp1);
    for j = 1:size(temp,1)
        temp2 = str2double(label1(L == temp(j,1)));
        temp2(isnan(temp2)) = [];
        temp2 = sort(temp2);
        if ~isempty(temp2) && ~isempty(temp1)
            if ~isempty(intersect(temp1,temp2))
                indexMatrix2(i,:) = [boundaryNodes(i),temp(j,2)];
            end
        end
    end
end


indexMatrix = [indexMatrix;indexMatrix2];




% map all index to other index
[~,idx] = ismember(adjacent,indexMatrix(:,1));
idx1 = idx(:,1).*idx(:,2) ~= 0;
temp_1 = indexMatrix(:,2);
adjacentNew = temp_1(idx(idx1,:));
adjacent1 = adjacent(idx1,:);
idx2 = ismember(sort(adjacentNew,2),mergePair1,'rows');
mergePair1 = adjacent1(idx2,:);


%% merge the area based on the merged pairs
mergePair = mergePair1;
newL = L;
K = double(max(max(L)));
zeroRemove = zeros(K,1);
while ~isempty(mergePair)
    temp = mergePair(1,2);
    if sum(zeroRemove(mergePair(1,:))) > 0
        temp1 = unique(zeroRemove(mergePair(1,:)));
        temp1 = temp1(temp1 > 0);
        if length(temp1) == 1
        name = temp1(1);
        newL(L == temp) = name;
        newL(L == mergePair(1,1)) = name;
        zeroRemove(mergePair(1,1)) = name;
        zeroRemove(mergePair(1,2)) = name;
        else
            name = min(temp1);
            name1 = max(temp1);
            zeroRemove(zeroRemove == name1) = name;
            newL(newL == name1) = name;
        end
    else
        newL(L == temp) = K + 1;
        newL(L == mergePair(1,1)) = K + 1;
        zeroRemove(mergePair(1,1)) = K + 1;
        zeroRemove(mergePair(1,2)) = K + 1;
        K = K + 1;
    end
    mergePair(1,:) = [];
end
zeroRemove(zeroRemove == 0) = find((zeroRemove == 0));

%%
% remove the zeros between two merged areas
mergePair = mergePair1;
signArea = zeroRemove(mergePair(:,1));
for i = 1:size(mergePair,1)
    index1 = find(ismember(zone,mergePair(i,:),'rows'));
    index2 = find(ismember(zone,[0,mergePair(i,1)],'rows'));
    index3 = find(ismember(zone,[0,mergePair(i,2)],'rows'));
    index = [index1;index2;index3];    
    idx = sub2ind(size(L), row(index), col(index));
    newL(idx) = signArea(i);
end
% remove the zeros between the same area
L = newL;

% %% get the local minimum
% %% find out the zeros index
% L = newL;
[row,col] = find(L == 0);
% revise the row and column
temp = row == 1 | col == 1 | row == size(L,1) | col == size(L,1);
row(temp) = [];
col(temp) = [];

indexRowM = [row-1 row row+1 row-1 row+1 row-1 row row+1];
indexColM = [col-1 col-1 col-1 col col col+1 col+1 col+1];
% extract the elements
idx = sub2ind(size(L), indexRowM(:)', indexColM(:)');
elemMatrix = reshape(L(idx),[],8);
zone = [];
% extract the adjacent area information
for i = 1:size(elemMatrix,1)
    temp = elemMatrix(i,:);
    temp1 = temp(temp ~= 0);
    temp = unique(temp1);
    if length(temp) == 1 && length(temp1) >5
        L(row(i),col(i)) = temp;
    end
end

