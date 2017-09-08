function indexMatrix = lableRegion(L,mat)
newL = L;
boundary = [newL(:,1)' newL(1,:) newL(end,:) newL(:,end)'];
bdRegionIndex = unique(boundary);
allIndex = unique(newL(:));
interiorIndex = setdiff(allIndex,bdRegionIndex);
N = length(interiorIndex);
simiMatrix = zeros(N);
% get the similarity matrix
for i = 1:N
    for j = i+1:N
        temp1 = sum(sum(newL == interiorIndex(i)));
        temp2 = sum(sum(newL == interiorIndex(j)));
        temp3 = mat(newL == interiorIndex(i));
        temp3 = temp3(:);
        temp4 = mat(newL == interiorIndex(j));
        temp4 = temp4(:);
        Acommon = intersect(temp3,temp4);
        temp5 = setxor(temp3,Acommon);
        ratio1 = length(temp5)/length(temp3);
        temp6 = setxor(temp4,Acommon);
        ratio2 = length(temp6)/length(temp4);
        if ratio1 < 0.3 || ratio2 < 0.3
            simiMatrix(i,j) = 1;
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

temp = find(group == 0);
group(temp) = (k:k+length(temp)-1)';
indexMatrix = [interiorIndex group];

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
axis off