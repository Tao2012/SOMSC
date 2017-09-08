function map = adjacent_nodal(map,L,mat)

% find out the index of the boundary of the basins on the map
[row,col] = find(L == 0);
% remove those index on the boundary on the map
temp = row == 1 | col == 1 | row == size(L,1) | col == size(L,2);
row(temp) = [];
col(temp) = [];
% extract the adjacent elements of the element on the boundary of the
% basins
indexRowM = [row-1 row row+1 row-1 row+1 row-1 row row+1];
indexColM = [col-1 col-1 col-1 col col col+1 col+1 col+1];
% extract the adjacent elements of the element on the boundary of the
% basins
idx = sub2ind(size(L), indexRowM(:)', indexColM(:)');
elemMatrix = reshape(L(idx),[],8);
zone = [];
% extract all adjacent area information
for i = 1:size(elemMatrix,1)
    % remove all zero elements in the i-th row
    temp = elemMatrix(i,:);
    temp = temp(temp ~= 0);
    % extract the unique information
    temp = unique(temp);
    if length(temp) > 2
         text(col(i), row(i), sprintf('%0.2f',mat(row(i),col(i))), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle','FontSize',14,'Color','r');
    end

end
% adjacent is used to save all adjacent information and it is unique
% zone is one-to-one map to row and col
% all of those information is saved in the map
