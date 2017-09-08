function showBarrier(mat,L)

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
    minV = min(mat(L == k));
    text(c(1), c(2), sprintf('%d,%0.2f', k,minV), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle','FontSize',14,'Color','w');
end


%% Label the barrier height (minimum and mean values) between different regions
index = adjacent(:,1) ~= 0 & adjacent(:,2) ~= 0;
adjacent = adjacent(index,:);
for i = 1:size(adjacent,1)
    temp = adjacent(i,:);
    index = find(ismember(zone,temp,'rows'));
    tempRow = row(index);
    tempCol = col(index);
    idx = sub2ind(size(L), tempRow, tempCol);
    [minV,ind] = min(mat(idx));
    meanV = mean(mat(idx));
    text(tempCol(ind), tempRow(ind), sprintf('%0.2f', minV), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle','FontSize',14,'Color','w');
end
