function L =  merge_Region_olsson(L,threshold,map)

zone = map.zone;
adjacent = map.adjacent;
row = map.row;
col = map.col;
label = map.label;
minVline = map.minVline;

mergePair = [];

temp = unique(L(:));
% extract the index of basin where only one was labeled
single = [];
for i = 2:length(temp)
   temp1 = str2double(label(L == temp(i)));
   temp1(isnan(temp1)) = [];
   if length(temp1) == 1
       single = [single;temp(i)];
   end
end
% merge the basin where only one was labled with its adjacent one 
for i = 1:length(single)
   temp = find(sum(adjacent == single(i),2) == 1);
   [~,index] = min(minVline(temp));
   mergePair = [mergePair;adjacent(temp(index),:)];   
end

mergePair = unique(mergePair,'rows');
mergePair1 = mergePair(sum(mergePair,2) ~= 0,:);

% merge the area based on the merged pairs
mergePair = mergePair1;
newL = L;
K = max(max(L));
% zeroRemove is used to store the mapping relationship between the index
% before changing and the index after changing
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
% remove the zeros between the same area
L = newL;

% the following code is used to deal with the special case
[row,col] = find(L == 0);
temp = row == 1 | col == 1 | row == size(L,1) | col == size(L,1);
row(temp) = [];
col(temp) = [];

indexRowM = [row-1 row row+1 row-1 row+1 row-1 row row+1];
indexColM = [col-1 col-1 col-1 col col col+1 col+1 col+1];
% extract the elements
idx = sub2ind(size(L), indexRowM(:)', indexColM(:)');
elemMatrix = reshape(L(idx),[],8);
% extract the adjacent area information
for i = 1:size(elemMatrix,1)
    temp = elemMatrix(i,:);
    temp1 = temp(temp ~= 0);
    temp = unique(temp1);
    if length(temp) == 1 && length(temp1) >5
        L(row(i),col(i)) = temp;
    end
end