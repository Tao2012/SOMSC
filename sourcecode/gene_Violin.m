function map = gene_Violin(map,path,indexGene,data)

cellIdentity = map.cellIdentity;
lineage = path.lineage;
N = length(lineage);

dataV = data(:,indexGene);
y1 = min(dataV) - 0.1*abs(min(dataV));
y2 = max(dataV) + 0.1*abs(max(dataV));
N_subplot = ceil(N/3);
for i = 1:N
    subplot(3,N_subplot,i)
                temp4 = dataV(cellIdentity(:,1) == i);
                [~,idx,~] = deleteoutliers(temp4,0.08);
                TF = true(size(temp4,1),1);
                TF(idx) = false;
                temp4 = temp4(TF);
    
    if sum(abs(temp4)) > 0
    violinplot(temp4,ones(size(temp4)),'ViolinColor',[0 1 1]);
    ylim([y1,y2]);
    % add the title to the list
    title(strcat('S',num2str(i)))
    box on
    grid on
    end
end

        
