clear all
clc
close all

% This file is used to generate all figures for each case
% Figure 1: the original cellular map
% Figure 2: the original cellular map with boundaries of each states
% Figure 3: the cellular map with merged regions and each state is labeled
% by time information
% Figure 4: the cellular map with merged regions and each state is labeled
% by new information
% Figure 5: the lineage path is constructed with necessary information
% Figure 6: the lineage path without the adajacent information
% Figure 7: gene specific figures


%% load all the data for the example. This one is for the nature published
% by Olsson
load('demo_hsc_2.mat')
% get the size of the SOM map. All the SOM maps are the squares ones.
N1 = size(mat,1)/2;
mat1 = mat(1:N1,1:N1);
% Since the map is peoriodic, 3 by 3 maps are combined together 
mat = [mat1 mat1 mat1;mat1 mat1 mat1;mat1 mat1 mat1];

% load the orignial data of the labels
% one of the label is to number the stage when the cells were collected
% the other one is to number the index of the collected

% construct the labels
labels = reshape(sMap_time.labels,N1,[]);
label = [labels,labels,labels;labels,labels,labels; labels,labels, labels];
map.label = label;
labels = reshape(sMap_cell.labels,N1,[]);
label = [labels,labels,labels;labels,labels,labels; labels,labels, labels];
map.label_cell = label;


%% Figure 1: the original cellular map which combine 3 by 3 maps
hFig = figure(1);
set(hFig, 'Position', [800 800 1000 700])
imagesc(mat)
axis off
colorbar
printpdf(gcf,'figure1')

%% Figure 2: the original cellular map with barriers of adjacent states
hFig = figure(2);
set(hFig, 'Position', [800 800 1000 700])
% show the basins where the local wells are
L = watershed(mat); 
temp1 = mat;
% replace the barriers with the maximum values of the matrix
temp1(L == 0) = max(max(mat));
% display the result with the boudary information
imagesc(temp1)
axis off
colorbar
printpdf(gcf,'figure2')

%% Figure 3: the cellular map and each state is labeled by time information
hFig = figure(3);
set(hFig, 'Position', [800 800 1000 700])
temp1 = mat;
% Replace the barriers with the maximum values of the matrix
temp1(L == 0) = max(max(mat));
imagesc(temp1)
axis off
% extract all the adjacent zones information
map = adjacent_zone(map,L);
% Add the time information to each cellular state
% timeRegion = addTextTime(L,map);
map = lableRegion2(L,map);
% Label the barrier height (minimum) between different regions
map = addTextBarrier_ttest(map,L,mat,sData);
colorbar
printpdf(gcf,'figure3')


%% Figure 4: the cellular map and each state is labeled by new information
% search the boundary regions
hFig = figure(4);
set(hFig, 'Position', [800 800 1000 700])
temp1 = mat;
% replace the barriers with the maximum values of the matrix
temp1(L == 0) = max(max(mat));
imagesc(temp1)
% label regions
map = lableRegion2(L,map);
% map the old index to the new index with the labels
map = uniqueRegion(L,map);
% obtain all the merged regions
map = obtainMerge(L,map);
% merge all the merging pairs
L =  merge_Region_final(L,map);
% extract all the adjacent zones information
map = adjacent_zone(map,L);
axis off
colorbar
printpdf(gcf,'figure4')


%% Figure 5: the cellular map and each state is labeled by new information  
hFig = figure(5);
set(hFig, 'Position', [800 800 1000 700])
temp1 = mat;
temp1(L == 0) = max(max(mat));
% hold on
imagesc(temp1)
map = adjacent_zone(map,L);
% Label the barrier height (minimum) between different regions
metricName = 'cityblock';
map = addTextBarrier_distance_E(map,L,mat,sData,metricName);
map = lableRegion2(L,map);
axis off
colorbar
printpdf(gcf,'figure5')


%% Figure 6: the cellular map with 2 by 2 map
hFig = figure(6);
set(hFig, 'Position', [800 800 1000 700])
% extract the 2 by 2 maps and the corresponding barriers information
indexM = (0.5*N1+1):(2.5*N1);
temp1 = mat(indexM,indexM);
newL = L(indexM,indexM);
mat2 = temp1;
% replace the barriers with the maximum values of the matrix
temp1(newL == 0) = max(max(temp1));
imagesc(temp1)
% extract the cell label information
map.label = map.label(indexM,indexM);
map.label_cell = map.label_cell(indexM,indexM);
% obtain the adjacent zones
map = adjacent_zone(map,newL);
% add the barriers information
metricName = 'cityblock';
map = addTextBarrier_distance_E(map,newL,mat2,sData,metricName);
% label the regions
map = lableRegion2(newL,map);
% make all the regions unique
map = uniqueRegion(newL,map);
% obtain the lineage information
startS = 4;
path = obtainLineage_early(map,startS);
axis off
colorbar
printpdf(gcf,'figure6')


%% Figure XX: the network of different cellular states
network_regions(path)

%% Figure 7: plot the lineage tree
hFig = figure(7);
set(hFig, 'Position', [800 800 1000 700])
lineageTree(path.lineage',1:length(path.lineage),[])
axis off
colorbar
printpdf(gcf,'figure7')


%% Figure 8: the maps with 2 by 2 maps
hFig = figure(8);
set(hFig, 'Position', [800 800 1000 700])
temp1 = mat2;
temp1(newL == 0) = max(max(temp1));
imagesc(temp1)
axis off
colorbar 
printpdf(gcf,'figure8')


%% Figure 9: the original maps with 2 by 2 maps
hFig = figure(9);
set(hFig, 'Position', [800 800 1000 700])
imagesc(mat2)
axis off
colorbar
printpdf(gcf,'figure9')

%% Figure 10: the original maps with 2 by 2 maps with the cell stage information
hFig = figure(10);
set(hFig, 'Position', [800 800 1000 700])
temp1 = mat2;
temp1(newL == 0) = max(max(temp1));
imagesc(temp1)
% add the stage information
for i = 1:size(map.label,1)
    for j = 1:size(map.label,2)
        text(j,i,map.label(i,j),'FontSize',16,'Color','red','HorizontalAlignment', 'center')
    end
end
axis off
colorbar
printpdf(gcf,'figure10')


%% Figure 11: plot the 3d landscape
hFig = figure(11);
set(hFig, 'Position', [800 800 1000 700])
map = mapRestEarly(map,newL,sData);
mat1 = landscape3D(mat2,map);
colorbar
printpdf(gcf,'figure11')


%% Figure 12: the plot violin plots
hFig = figure(12);
set(hFig, 'Position', [800 800 1600 400])
indexGene = 2522;
dataR = Olsson2016;
dataName = 'Olsson';
dataV = driverGene_Violin(map,path,indexGene,dataR,dataName);
colorbar
printpdf(gcf,'figure12')


%% calculate the branch probability
cellIdentity = map.cellIdentity;
lineage = path.lineage;
fr = tabulate(lineage);
index = fr(:,2) > 1;
indexNode = fr(index,1);
count = [];
for i = 1:length(indexNode)
    index1 = find(lineage == indexNode(i));
    count1 = zeros(size(index1));
    for j = 1:length(index1)
        count1(j) = sum(cellIdentity(:,1) == index1(j));
    end
    count1 = count1/sum(count1);
    count1 = [index1 count1];
    count = [count;count1];
end

