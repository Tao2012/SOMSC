function map = mapRest(map,L)


indexMatrix = map.indexMatrix;
[~,ia,~] = unique(indexMatrix(:,2));
index_group = indexMatrix(ia,1);
cellMatrix = [];
% construct the labels
label = map.label_cell;
for i = 1:length(index_group)
    temp1 = str2double(label(L == index_group(i)));
    temp1(isnan(temp1)) = [];
    temp2 = [i*ones(size(temp1)) temp1];
    cellMatrix = [cellMatrix;temp2];
end

cellNo = setdiff(1:size(data,1),cellMatrix(:,2))';
data1 = data(cellMatrix(:,2),:);
data2 = data(cellNo,:);
D = pdist2(data2,data1,'euclidean'); % euclidean distance

% construct the index matrix and determine the positions of the rest cells
iMatrix = zeros(size(D));
cellIdentity = zeros(size(D,1),1);
for i = 1:size(D,1)
   temp = D(i,:);
   [~,Idx] = sort(temp);
   smallestNIdx = Idx(1:3);
   cellIdentity(i) = cellMatrix(Idx(1),1);
   iMatrix(i,smallestNIdx) = 1;
end

% construct the identity of cells: the first column is the cell stage
% the second column is the cell index
cellIdentity = [cellIdentity cellNo;cellMatrix];
cellIdentity = sortrows(cellIdentity,2);

map.iMatrix = iMatrix;
map.cellIdentity = cellIdentity;