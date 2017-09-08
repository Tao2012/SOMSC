function map = driverGene_Violin(map,path,indexGene,dataR,Dataname)

cellIdentity = map.cellIdentity;
lineage = path.lineage;
N = length(lineage);

data = dataR.data;
driverGene = zeros(size(data,2),length(lineage));
% assign the datasets
for j = 1:size(data,2)
    data1 = {};
    % plot boxplot
    for i = 1:length(lineage)
        temp = cellIdentity(:,1) == i;
        if sum(temp) == 1
            data1{i} = [data(temp,j) data(temp,j)];
        else
        data1{i} = data(temp,j);
        end
    end
    for i = 1:length(lineage)
        if lineage(i) ~= 0
            [h,~] = ttest2(data1{i},data1{lineage(i)},'Alpha',0.01);
            driverGene(j,i) = h;
        end
    end
end

map.driverGene = driverGene;
% indexGene = 3591;
dataV = data(:,indexGene);

sign = [];
dataV1 = [];
for i = 1:length(lineage)
    if lineage(i) ~= 0
        temp = cellIdentity(:,1) == lineage(i);
        temp1 = dataV(temp);
        dataV1 = [dataV1;temp1];
        sign = [sign;i*ones(size(temp1))];
        data = data;
    else
        temp = cellIdentity(:,1) == i;
        temp1 = mean(dataV(temp));
        dataV1 = [dataV1;temp1];
        sign = [sign;i*ones(size(temp1))];     
    end
end

% if sum(dataV1) > 0
% violinplot(dataV1, sign,'ViolinColor',[0.3 0.3 0.3]);
% hold on
% end
% if sum(dataV) > 0
% violinplot(dataV, cellIdentity(:,1),'ViolinColor',[0 1 1]);
% end
% plot the significantly changed one
index = find(driverGene(indexGene,:) == 1);
yl = ylim;
hold on 
plot(index, yl(2)*ones(size(index)),'rX','LineWidth',5);
% add the title to the list 
title(dataR.gene_name(indexGene))
set(gca,'XTick',1:N)
for i = 1:N
   nameX{i} = strcat('S',num2str(i)); 
end
set(gca,'XTickLabel',nameX)
box on
map.dataV = dataV;

for i = 1:length(lineage)
    if lineage(i) ~= 0
        temp = dataR.gene_name(driverGene(:,i) == 1)';
        fileID = fopen(strcat(Dataname,'_DEG',num2str(i),'.txt'),'w');
        for j = 1:length(temp)
            fprintf(fileID,'%s\n',temp{j});
        end
        fclose(fileID);
    end
end
        
