function path = obtainLineage_early(map,startS)
% %
adjacentBarrierNew = map.adjacentBarrierNew;
barrierHeight = map.barrierHeight;
indexMatrix = map.indexMatrix;

% construct the matrix for the adjacent matrix
lineageMatrix = zeros(max(indexMatrix(:,2)));
for i = 1:size(adjacentBarrierNew,1)
    lineageMatrix(adjacentBarrierNew(i,1),adjacentBarrierNew(i,2)) = barrierHeight(i);
    lineageMatrix(adjacentBarrierNew(i,2),adjacentBarrierNew(i,1)) = barrierHeight(i);
end

% find all possible transitions between adjacent cellular states
relation = [];
for i = 1:size(lineageMatrix,1)
   [~,i2] = unique(lineageMatrix(i,:)); 
   relation = [relation; i i2(2)];
end
relation = unique(sort(relation,2),'rows');

% Add more possible transitions which make every cellular state reachable
sign = 1;
while (sign > 0)
    adj = zeros(size(lineageMatrix));
    for i = 1:length(relation)
        adj(relation(i,1),relation(i,2)) = 1;
        adj(relation(i,2),relation(i,1)) = 1;
    end
    
    Max = ceil(max(max(lineageMatrix)));
    indexReach = zeros(size(lineageMatrix,1),1);
    indexReach(startS) = 1;
    for i = 1:size(lineageMatrix,1)
        if i ~= startS
            indexReach(i) = ~isempty(pathbetweennodes(adj,startS,i));
        end
    end
    
    if sum(indexReach) < size(lineageMatrix,1)
        temp = lineageMatrix(:,indexReach == 0);
        temp(temp == 0) = Max;
        temp1 = min(temp,[],2);
        temp1(indexReach == 0) = Max;
        temp2 = min(temp1);
        [I,J] = ind2sub(size(lineageMatrix),find(lineageMatrix == temp2));
        temp3 = unique(sort([I,J],2),'rows');
        relation = [relation;temp3];
    else
        sign = 0;
    end
end

% translate those transition relationship into the adj matrix
adj = zeros(size(lineageMatrix));
for i = 1:length(relation)
    adj(relation(i,1),relation(i,2)) = 1;
    adj(relation(i,2),relation(i,1)) = 1;
end

% find out the transition path
lineagePath = {};
for j = 1:size(lineageMatrix,1)
    if j ~= startS
        pth = pathbetweennodes(adj,startS,j);
        lineagePath{j} = pth{1};
    end
end
    
% get the lineage vector
lineage = zeros(size(lineageMatrix,1),1);
for i = 1:length(lineagePath)
   temp = lineagePath{i}; 
   for j = 2:length(temp)
      lineage(temp(j)) = temp(j-1); 
   end
end

% Calculate the barrier height
adj = [];
for i = 1:length(lineage) 
    temp = [i lineage(i)];
    adj = [adj;sort(temp)];
    
end
vecWeight = zeros(size(lineage,1),1);
for i = 1:size(adj,1)
    [Lia,~] = ismember(adjacentBarrierNew,adj(i,:),'rows');
    if sum(Lia) > 0
        vecWeight(i) = barrierHeight(Lia);
    end
end
vecWeight(vecWeight == 0) = [];

% save all the variables in path
path.weight = vecWeight;
path.lineage = lineage;
path.lineageMatrix = lineageMatrix;

