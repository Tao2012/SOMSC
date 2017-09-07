function plotPseudoTime(map,path,cell_time,geneIndex,dataName,deltaD,sData,nSize)

cellIdentity = map.cellIdentity;
lineage = path.lineage;
hFig = figure(1);
set(hFig, 'Position', [800 800 1000 500])
[x1,~,~]=treelayout1(lineage);
%
% % define the distance between any dots
% plot state by states
% calculate the x-axis for each state
adj_matrix = zeros(length(lineage));
for i = 1:length(lineage)
    if lineage(i) > 0
        adj_matrix(i,lineage(i)) = 1;
        adj_matrix(lineage(i),i) = 1;
    end
end
number_statecell = zeros(length(lineage),1);
for i = 1:length(lineage)
    number_statecell(i) = size(cell_time{i},1);
end

root = find(lineage == 0);
position = {};
for i = 1:length(lineage)
    if i ~= root
        pth = pathbetweennodes(adj_matrix, i, root);
        pth = pth{1};
        pth = fliplr(pth);
        % get x-axis
        number = number_statecell(pth);
        start_x = sum(number(1:end-1))*deltaD;
        x_axis = start_x:deltaD:(start_x + deltaD*(number(end) - 1));
        y_axis = linspace(x1(pth(end-1)),x1(pth(end)),number(end));
        position{i} = [x_axis;y_axis]';
    else
        x_axis = 0:deltaD:(deltaD*(number_statecell(root)-1));
        y_axis = x1(root)*ones(size(x_axis));
        position{i} = [x_axis;y_axis]';
    end
end

% plot the bifurcation graph with pseudotime
xy = [];
z = [];
startPoint =[];
for i = 1:length(lineage)
    temp = position{i};
    temp1 = cell_time{i};
    cell_index = temp1(:,3);
    xy = [xy;temp];
    startPoint = [startPoint;temp(1,:)];
    z = [z;sData.data(cell_index,geneIndex)];
end
scatter(xy(:,1),xy(:,2),[],z,'filled');
colormap(jet)
colorbar
hold on
% label the start point for each state
scatter(startPoint(:,1),startPoint(:,2),80,'m*');
axis off
% save alll figures
printpdf(hFig,[dataName,'/psuedotime_1'])
saveas(hFig,[pwd, '/',dataName,'/psuedotime_1.fig'])
close all

% plot the violin plot for each graph
hFig = figure(1);
set(hFig, 'Position', [800 800 800 1000])
map = gene_Violin(map,path,geneIndex,sData.data);
suplabel(char(sData.gene_name(geneIndex)),'t');
% save alll figures
printpdf(hFig,[dataName,'/psuedotime_2'])
saveas(hFig,[pwd, '/',dataName,'/psuedotime_2.fig']);
close all

% find out all end states
endState = [];
for i = 1:length(lineage)
    if sum(lineage == i) < 1
        endState = [endState;i];
    end
end

hFig = figure(1);
set(hFig, 'Position', [800 800 800 400])

for i = 1:length(endState)
    pth = pathbetweennodes(adj_matrix, endState(i), root);
    pth = pth{1};
    pth = fliplr(pth);
    z = [];
    for j = 1:length(pth)
        temp = position{pth(j)};
        temp1 = cell_time{pth(j)};
        cell_index = temp1(:,3);
        z = [z;temp(:,1) sData.data(cell_index,geneIndex)];
    end
    scatter(z(:,1),z(:,2),[],'filled');
    box on
    hold on
end

signNeg = sum(sData.data(:,geneIndex) < 0);

% find out the fit curve
for i = 1:length(endState)
    pth = pathbetweennodes(adj_matrix, endState(i), root);
    pth = pth{1};
    pth = fliplr(pth);
    for j = 1:length(pth)
        temp = position{pth(j)};
        temp1 = cell_time{pth(j)};
        cell_index = temp1(:,3);
        temp2 = [temp(:,1),sData.data(cell_index,geneIndex)];
        
        NN = size(temp2,1);
        indexGroup = 1:nSize:NN;
        
        temp3 = [];
        for k = 1:length(indexGroup)
            if indexGroup(k)+nSize-1 < NN
                indexG = indexGroup(k):(indexGroup(k)+nSize-1);
            else
                indexG = indexGroup(k):NN;
            end
            if length(indexG) > 1
                temp4 = temp2(indexG,:);
                [~,idx,~] = deleteoutliers(temp4(:,2),0.08);
                TF = true(size(temp4,1),1);
                TF(idx) = false;
                temp4 = temp4(TF,:);
                temp3 = [temp3;mean(temp4)];
            else
                temp4 = temp2(indexG,:);
                temp3 = [temp3;temp4];
            end
        end
        fitting{pth(j)} = temp3;
    end
end

for i = 1:length(endState)
    pth = pathbetweennodes(adj_matrix, endState(i), root);
    pth = pth{1};
    pth = fliplr(pth);
    z = [];
    z1 = [];
    for j = 1:length(pth)
        temp = position{pth(j)};
        temp1 = fitting{pth(j)};
        z = [z; temp1];
        z1 = [z1;temp];
    end
    % interpolation the differentiation trajectory
    vq2 = interp1(z(:,1),z(:,2),z1(:,1),'pchip');
    if signNeg < 1
        vq2(vq2 < 0) = 0;
    end
    % plot the differentiation trajectory
    plot(z1(:,1),vq2);
    hold on
end
y1 = min(sData.data(:,geneIndex)) - 0.1*abs(min(sData.data(:,geneIndex)));
y2 = max(sData.data(:,geneIndex)) + 0.1*abs(max(sData.data(:,geneIndex)));
ylim([y1,y2])
suplabel(char(sData.gene_name(geneIndex)),'t');
% save alll figures
printpdf(hFig,[dataName,'/psuedotime_3'])
saveas(hFig,[pwd, '/',dataName,'/psuedotime_3.fig'])
close all
end



