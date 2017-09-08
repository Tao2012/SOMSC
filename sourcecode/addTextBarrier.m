function map = addTextBarrier(map,L,mat)

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
% add the text of the height to boundary of the adjacent regions
for i = 1:size(adjacent,1)
    % the adjacent information
    temp = adjacent(i,:);
    % extract the elements on the barrier of the adjacent basins
    index = find(ismember(zone,temp,'rows'));
    tempRow = row(index);
    tempCol = col(index);
    idx = sub2ind(size(L), tempRow, tempCol);
    % extract the height of the barrier of the adjacent basins
    [minVline(i),ind] = min(mat(idx));
    % add the height to the barrier
    text(tempCol(ind), tempRow(ind), sprintf('%0.2f',minVline(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle','FontSize',14,'Color','r');
end



% the following is used to discuss the special case where four basins are
% adjacent with each other
[row,col] = find(L == 0);
% remove the lower boundary and left boudary
temp = row == size(L,1) | col == size(L,2);
row(temp) = [];
col(temp) = [];
% index matrix
indexRowM = [row row row+1 row+1];
indexColM = [col+1 col col col+1];
% extract the elements around zero elements
idx = sub2ind(size(L), indexRowM(:)', indexColM(:)');
elemMatrix = reshape(L(idx),[],4);

temp = find(sum(elemMatrix,2) == 0);
row = row(temp);
col = col(temp);

indexRowM = [row row row+1 row+1];
indexColM = [col+1 col col col+1];
% extract the elements around zero elements
idx = sub2ind(size(L), indexRowM(:)', indexColM(:)');
elemMatrix = reshape(L(idx),[],4);
valueMatrix = reshape(mat(idx),[],4);
[valueVec, ind]= min(valueMatrix,[],2);
coord = zeros(length(ind),2);
for i = 1:length(ind)
   temp1 = [row(i) row(i) row(i)+1 row(i)+1];
   temp2 = [col(i)+1 col(i) col(i) col(i)+1];
   coord(i,:) = [temp1(ind(i)) temp2(ind(i))]; 
end

% index matrix
indexRowM = [row-1 row-1 row-1 row-1 row row row+1 row+1 row+2 row+2 row+2 row+2];
indexColM = [col-1 col col+1 col+2 col-1 col+2 col-1 col+2 col-1 col col+1 col+2];

idx = sub2ind(size(L), indexRowM(:)', indexColM(:)');
elemMatrix = reshape(L(idx),[],12);

adjacent1 = [];
for i = 1:size(elemMatrix,1)
   temp = elemMatrix(i,:);
   temp = temp(temp ~= 0);
   temp = unique(temp);
   temp = nchoosek(temp,2);
   index = find(ismember(temp,adjacent,'rows') == 0);
   adjacent1 = [adjacent1; temp(index,:)];   
   text(coord(i,2), coord(i,1), sprintf('%0.2f',valueVec(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle','FontSize',14,'Color','r');
end    

map.adjacent1 = adjacent1;
map.valueVec = valueVec;
map.adjacent = adjacent;
map.minVline = minVline;