function newL =  mergeRegion(mat,L)


%% find out the zeros index
[row,col] = find(L == 0);
% revise the row and column
temp = row == 1 | col == 1 | row == size(L,1) | col == size(L,2);
row(temp) = [];
col(temp) = [];
% index matrix
indexRowM = [row-1 row row+1 row-1 row+1 row-1 row row+1];
indexColM = [col-1 col-1 col col col col+1 col+1 col+1];
% extract the elements around zero elements
idx = sub2ind(size(L), indexRowM(:)', indexColM(:)');
elemMatrix = reshape(L(idx),[],8);
zone = [];
% extract the adjacent area information
for i = 1:size(elemMatrix,1)
    temp = elemMatrix(i,:);
    temp = temp(temp ~= 0);
    temp = unique(temp);
    if length(temp) < 3
        if length(temp) < 2
            temp = [0,temp];
        end
    else
        temp = [0,0];
    end
    zone = [zone;temp];
end
adjacent = unique(zone,'rows');

%% get the local minimum
s = regionprops(L, 'Centroid');
hold on
for k = 1:numel(s)
    c = s(k).Centroid;
    meanArea(k) = mean(mat(L == k));
end

%% Step 1: Obtain the merge pairs
index = adjacent(:,1) ~= 0 & adjacent(:,2) ~= 0;
adjacent = adjacent(index,:);
% if the barrier is less than both of two adjacent areas, then we will
% merger those two adjacent areas.
mergePair = [];
for i = 1:size(adjacent,1)
    temp = adjacent(i,:);
    index = find(ismember(zone,temp,'rows'));
    tempRow = row(index);
    tempCol = col(index);
    idx = sub2ind(size(L), tempRow, tempCol);
    [minV,~] = min(mat(idx));
    tmp = 0;
    % mean value of each area and minimum values of barriers
    if minV < meanArea(temp(1)) &&  minV < meanArea(temp(2))
        if meanArea(temp(1)) - minV > 1|| meanArea(temp(2)) - minV > 1
            mergePair = [mergePair;temp];
            tmp = 1;
        end
    end
    % minimum value of each area and minimum values of barriers
%     if minV - minArea(temp(1)) <= 1e-1 ||  minV - minArea(temp(2)) <= 1e-1
%         if tmp < 1
%             mergePair = [mergePair;temp];
%         end
%     end
end
mergePair1 = mergePair;

%% merge the area based on the merged pairs
mergePair = mergePair1;
newL = L;
mapL = 1:max(max(L));
common = intersect(mergePair(:,1),mergePair(:,2));
mapL(setxor(mergePair(:,2),common)) = [];
K = max(max(L));
zeroRemove = zeros(K,1);
while ~isempty(mergePair)
    temp = mergePair(1,2);
    if sum(zeroRemove(mergePair(1,:))) > 0
        temp1 = unique(zeroRemove(mergePair(1,:)));
        temp1 = temp1(temp1 > 0);
        name = temp1(1);
        newL(L == temp) = name;
        newL(L == mergePair(1,1)) = name;
        zeroRemove(mergePair(1,1)) = name;
        zeroRemove(mergePair(1,2)) = name;
    else
        newL(L == temp) = K + 1;
        newL(L == mergePair(1,1)) = K + 1;
        zeroRemove(mergePair(1,1)) = K + 1;
        zeroRemove(mergePair(1,2)) = K + 1;
    end
    mergePair(1,:) = [];
    while ~isempty(intersect(mergePair,temp))
        index = [];
        for i = 1:length(temp)
            index = [index;find(mergePair(:,1) == temp(i))];
        end
        temp = mergePair(index,:);
        temp = temp(:);
        mergePair(index,:) = [];
        if sum(zeroRemove(temp)) > 1
            temp1 = unique(zeroRemove(temp));
            nonZero = (temp1 > 0);
            temp1 = temp1(nonZero);
            name = temp1(1);
            for i = 1:(length(temp1) - 1)
                newL(newL == temp1(i+1)) = name;
                zeroRemove(zeroRemove == temp1(i+1)) = name;
            end
            for i = 1:length(temp)
                newL(L == temp(i)) = name;
            end
            zeroRemove(temp) = name;
        else
            for i = 1:length(temp)
                newL(L == temp(i)) = K + 1;
            end
            zeroRemove(temp) = K + 1;
        end
    end
    K = K + 1;
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
L = newL;
% find out the zeros index
[row,col] = find(L == 0);
% revise the row and column
temp = row == 1 | col == 1 | row == size(L,1) | col == size(L,2);
row(temp) = [];
col(temp) = [];
% index matrix
indexRowM = [row-1 row row+1 row-1 row+1 row-1 row row+1];
indexColM = [col-1 col-1 col col col col+1 col+1 col+1];
% extract the elements around zero elements
idx = sub2ind(size(L), indexRowM(:)', indexColM(:)');
elemMatrix = reshape(L(idx),[],8);
zone = [];
% extract the adjacent area information
for i = 1:size(elemMatrix,1)
    temp = elemMatrix(i,:);
    temp = temp(temp ~= 0);
    temp = unique(temp);
    if length(temp) == 1
        L(row(i),col(i)) = temp;
    end
end
newL = L;