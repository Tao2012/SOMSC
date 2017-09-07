function map = lableRegion2(L,map)
newL = L;
label = map.label_cell;
% remove all the boundary
boundary = unique([newL(:,1);newL(:,end);newL(1,:)';newL(end,:)']);
allIndex = unique(newL(:));
[allIndex,~] = setdiff(allIndex,boundary);
% allIndex(1) = [];
N = length(allIndex);
simiMatrix = zeros(N);
% get the similarity matrix
for i = 1:N
    for j = i+1:N
        temp1 = str2double(label(newL == allIndex(i)));
        temp1(isnan(temp1)) = [];
        temp1 = sort(temp1);
        temp2 = str2double(label(newL == allIndex(j)));
        temp2(isnan(temp2)) = [];
        temp2 = sort(temp2);
        if ~isempty(temp2) && ~isempty(temp1)
            if ~isempty(intersect(temp1,temp2))
                simiMatrix(i,j) = 1;
            end
        end
    end
end

[row,col] = find(simiMatrix);
index = [row,col];
index1 = index;
group = zeros(N,1);
k = 1;
while ~isempty(index)
    temp = index(1,:)';
    temp_1 = group(temp);
    if sum(temp_1) == 0
        group(temp) = k;
        k = k + 1;
    else
        if temp_1(1) > 0
            group(temp(2)) = group(temp(1));
        end
        if temp_1(2) > 0
            group(temp(1)) = group(temp(2));
        end
    end
    index(1,:) = [];
end

temp_0 = find(group == 0);

group(group == 0) = k:(k+length(temp_0)-1);

indexMatrix = [allIndex group];
% outlier
s = regionprops(L, 'Centroid');
hold on
for i = 1:numel(s)
    if ~isnan(s(i).Centroid(1))
        c = s(i).Centroid;
        if ismember(i,indexMatrix(:,1))
            temp = indexMatrix(indexMatrix(:,1) == i,2);
            text(c(1), c(2), sprintf('S%d', temp), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle','FontSize',20,'Color','m');
        end
    end
end
map.indexMatrix = indexMatrix;
axis off