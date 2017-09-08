function driverGene = search_driverGene(path,map,sData,L)

%% search the driver genes
lineageNode = path.lineageNode;
lineage = path.lineage;
indexMatrix = map.indexMatrix;

[~,ia,~] = unique(indexMatrix(:,2));
index_group = indexMatrix(ia,1);
% construct the labels
label = map.label_cell;
for i = 1:length(index_group)
    temp1 = str2double(label(L == index_group(i)));
    temp1(isnan(temp1)) = [];
    lineage_group{i} = temp1;
end
% determine the maximal number of states at each stage
N = 1;
for i = 1:length(lineageNode)
    N = max(N,length(lineageNode{i}));
end
driverGene = zeros(size(sData.data,2),length(lineage)-1);
% assign the datasets
for j = 1:size(sData.data,2)
    data1 = {};
    % plot boxplot
    for i = 1:length(lineage)
        temp = lineage_group{i};
        data1{i} = sData.data(temp,j);
    end
    for i = 1:length(lineage)-1
        [h,~] = ttest2(data1{i+1},data1{lineage(i+1)});
        driverGene(j,i) = h;
    end
end
