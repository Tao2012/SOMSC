function path = obtainLineage(map)
% %
adjacentBarrierNew = map.adjacentBarrierNew;
adjacentBarrierTime = map.adjacentBarrierTime;
barrierHeight = map.barrierHeight;
indexMatrix = map.indexMatrix;

%% Layer 6
%
% initialize the graph parameters
temp = indexMatrix(indexMatrix(:,4) == 1,2);
p1 = 0;
parentNode = unique(temp);
label = parentNode;
node = 1;
k = 1;
nStage = 7;
lineageNode{1} = parentNode;
lineage = zeros(max(indexMatrix(:,2)),1);





weight = [];

% determine the adjacent nodes of parentNode
for stage = 1:nStage-1
    index_remove = [];
    parent = [];
    node1 = [];
    for i = 1:length(parentNode)
        index_1 = (adjacentBarrierNew(:,1) == parentNode(i)) + (adjacentBarrierNew(:,2) == parentNode(i));
        index_remove = [index_remove;find(index_1)];
        weight1 = barrierHeight(index_1 == 1);
        time1 = adjacentBarrierTime(index_1 == 1,:);
        temp_2 = adjacentBarrierNew(index_1 == 1,:);
        % unique the adjacent node
        temp_3 = temp_2 == parentNode(i);
        temp_2(temp_3) = 0;
        time1(temp_3) = 0;
        temp_2 = sum(temp_2,2);
        time1 = sum(time1,2);
        [temp_2,ic,~] = unique(temp_2);
        weight1 = weight1(ic);
        time1 = time1(ic);
        weight = [weight;weight1];
        p1 = [p1, node(i)*ones(1,length(temp_2))];
        label = [label;temp_2];
        
        % determine the new parent node
        index_time = find(time1 == stage + 1);
        
        if length(index_time) == 1
            temp_parent = temp_2(index_time);
            parent = [parent;temp_parent];
            node1 = [node1;k + index_time];
            k = k + length(temp_2);
        else
            temp_3 = temp_2(index_time);
            weight3 = weight1(index_time);
            while std(weight3)/mean(weight3) > 0.2
                [~,index] = max(weight3);
                temp_3(index) = [];
                weight3(index) = [];
            end
            temp_parent = temp_3;
            parent = [parent;temp_3];
            [~,idx] = ismember(parent,temp_2);
            node1 = [node1; k + idx];
            k = k + length(temp_2);
            
        end
        lineage(temp_parent) = parentNode(i);
    end
    parentNode = parent;
    node = node1;
    lineageNode{stage+1} = parentNode;
    % Prepare the next layer
    adjacentBarrierNew(index_remove,:) = [];
    barrierHeight(index_remove,:) = [];
    adjacentBarrierTime(index_remove,:) = [];
end

path.p1 = p1;
path.label = label;
path.weight = weight;
path.lineage = lineage;
path.lineageNode = lineageNode;




