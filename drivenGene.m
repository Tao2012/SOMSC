function drivenGene(cellIdentity,lineage,sData,dataName)

driverGene = zeros(size(sData.data,2),length(lineage));
% assign the datasets
for j = 1:size(sData.data,2)
    data1 = {};
    % plot boxplot
    for i = 1:length(lineage)
        temp = cellIdentity(:,1) == i;
        if sum(temp) == 1
            data1{i} = [sData.data(temp,j) sData.data(temp,j)];
        else
        data1{i} = sData.data(temp,j);
        end
    end
    for i = 1:length(lineage)
        if lineage(i) ~= 0
            [h,~] = ttest2(data1{i},data1{lineage(i)},'Alpha',0.005);
            driverGene(j,i) = h;
        end
    end
end


for i = 1:length(lineage)
    if lineage(i) ~= 0
        temp = sData.gene_name(driverGene(:,i) == 1)';
        fileID = fopen(strcat(dataName,'_',num2str(i),'.txt'),'w');
        for j = 1:length(temp)
            fprintf(fileID,'%s\n',temp{j});
        end
        fclose(fileID);
    end
end
  
DEGname = [dataName,'/DEG'];
isFolder = exist(DEGname,'dir');
if isFolder == 7
    rmdir(DEGname,'s')
    mkdir(DEGname)
else
    mkdir(DEGname)
end
DEGname = [dataName,'/DEG/'];
files = [dataName,'_*'];
movefile(files,DEGname)
