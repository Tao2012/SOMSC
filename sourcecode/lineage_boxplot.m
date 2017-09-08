function lineage_boxplot(sData,L,map,path)

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
% assign the datasets
data1 = {};
% plot boxplot
for i = 1:length(lineage)
    temp = lineage_group{i};
    data1{i} = sData.data(temp,37);
end

colors = {'r','k','b'};
lineageNode1 = lineageNode;
for j = 1:N
    Xpos(1) = 2;
    data = [];
    group = [];
    for i = 1:length(lineageNode)
        temp = lineageNode{i};
        if length(temp) > 1
            temp1 = temp(1);
            temp(1) = [];
            lineageNode{i} = temp;
        else
            temp1 = temp(1);
        end
        group = [group;repmat(Xpos(i), length(data1{temp1}), 1)];
        data = [data;data1{temp1}];
        Xpos(i+1) = Xpos(i) + 2;
    end
    boxplot(data, group,'Notch','on','colors',colors{j})
    hold on
end
axis([0 8 -3 2])
lineageNode = lineageNode1;
for j = 1:N
    Xpos(1) = 2;
    for i = 1:length(lineageNode)
        temp = lineageNode{i};
        if j <= length(temp)
            temp1 = temp(j);
            text(i,median(data1{temp1}),num2str(temp1),'fontSize',20);
        end
    end
end
