function treeData = generateTree(chooseNode,treeData)

N1 = length(chooseNode);
if N1 > 1
    c = combnk(1:N1,2);
    X = chooseNode(c);
    indexMatrix = treeData.data(:,[3,4]);
    index = [];
    for i = 1:size(N1,1)
        [~,indx]=ismember(X(i,:),indexMatrix,'rows');
        index = [index;indx];
    end 
    % need to remove those nodes in the row
    treeData.data(index,:) = [];
end

for i = 1:N1
    index1 = treeData.data(:,3) == chooseNode(i) | ...
        treeData.data(:,4) == chooseNode(i);
    rows = treeData.data(index1,:);
    treeData.data(index1,:) = [];
    label = rows(:,[3,4]);
    label = label(:);
    label(label == chooseNode(i)) = [];
    weight = rows(:,[5,6]);
    N = max(treeData.label1);
    parent = treeData.label1(treeData.label2 == chooseNode(i));
    treeData.label1 = [treeData.label1, N+1:N+length(label)];
    treeData.label2 = [treeData.label2;label];
    treeData.weight1 = [treeData.weight1;weight];
    if ~isempty(parent)
        treeData.p1 = [treeData.p1, parent*ones(1,length(label))];
    else
        treeData.p1 = 0;
    end
end