function SOMSC_lineage(dataName,startS,pValue,nThreshold)

%% load all the data for the example olfacotry data
load([dataName,'.mat'])
% get the size of the SOM map. All the SOM maps are the squares ones.
N1 = size(mat,1);
mat1 = mat(1:N1,1:N1);
% Since the map is peoriodic, 3 by 3 maps are combined together
mat = [mat1 mat1 mat1;mat1 mat1 mat1;mat1 mat1 mat1];

disp('======== Step 0 =====================')
% load the orignial data of the labels
% one of the label is to number the stage when the cells were collected
% the other one is to number the index of the collected
labels = reshape(sMap_time.labels,N1,[]);
label = [labels,labels,labels;labels,labels,labels; labels,labels, labels];
map.label = label;
labels = reshape(sMap_cell.labels,N1,[]);
label = [labels,labels,labels;labels,labels,labels; labels,labels, labels];
map.label_cell = label;

disp('======== Step 1 =====================')
%% Figure 1: the original topographical chart which consists of 3 by 3 maps
hFig = figure(1);
set(hFig, 'Position', [800 800 1000 700])
imagesc(mat)
axis off
colorbar
printpdf(gcf,[dataName,'/Figure1'])
saveas(gcf,[pwd, '/',dataName,'/Figure1.fig'])
close all

disp('======== Step 2 =====================')
%% Figure 2: the original topographic chart with barriers of adjacent basins
hFig = figure(2);
set(hFig, 'Position', [800 800 1000 700])
% calculate the boundaries of the basins which are the local minima.
L = watershed(mat);
temp1 = mat;
% replace the barriers with the maximum values of the matrix
temp1(L == 0) = max(max(mat));
% display the result with the boudary information
imagesc(temp1)
axis off
colorbar
printpdf(gcf,[dataName,'/Figure2'])
saveas(gcf,[pwd, '/',dataName,'/Figure2.fig'])
close all

disp('======== Step 3 =====================')
%% Figure 3: the original topographic chart with barrier heights of adjacent basins
hFig = figure(3);
set(hFig, 'Position', [800 800 1000 700])
temp1 = mat;
% Replace the barriers with the maximum values of the matrix
temp1(L == 0) = max(max(mat));
imagesc(temp1)
axis off
% extract all the adjacent basins
map = adjacent_zone(map,L);
% Add the time information to each cellular state
map = lableRegion1(L,map);
% Label the barrier height (minimum) between different basins
map = addTextBarrier_ttest(map,L,mat,sData,pValue);
colorbar
printpdf(gcf,[dataName,'/Figure3'])
saveas(gcf,[pwd, '/',dataName,'/Figure3.fig'])
close all

disp('======== Step 4 =====================')
%% Figure 4: the original topographic chart with new labels
hFig = figure(4);
set(hFig, 'Position', [800 800 1000 700])
temp1 = mat;
% replace the barriers with the maximum values of the matrix
temp1(L == 0) = max(max(mat));
imagesc(temp1)
map = lableRegion1(L,map);
% find out all the basins containing the same cells and label them
map = uniqueRegion(L,map);
% obtain all the merged regions
map = obtainMerge(L,map,nThreshold);
% merge all the merging pairs
L =  merge_Region_final(L,map);
% extract all the adjacent zones information
map = adjacent_zone(map,L);
axis off
colorbar
printpdf(gcf,[dataName,'/Figure4'])
saveas(gcf,[pwd, '/',dataName,'/Figure4.fig'])
close all

disp('======== Step 5 =====================')
%% Figure 5: the cellular map and each state is labeled by new information
hFig = figure(5);
set(hFig, 'Position', [800 800 1000 700])
temp1 = mat;
temp1(L == 0) = max(max(mat));
imagesc(temp1)
map = adjacent_zone(map,L);
% Label the barrier height (minimum) between different regions
metricName = 'cityblock';
map = addTextBarrier_distance_E(map,L,mat,sData,metricName);
map = lableRegion2(L,map);
axis off
colorbar
printpdf(gcf,[dataName,'/Figure5'])
saveas(gcf,[pwd, '/',dataName,'/Figure5.fig'])
close all

disp('======== Step 6 =====================')
%% Figure 6: the cellular map with 2 by 2 map
hFig = figure(6);
set(hFig, 'Position', [800 800 1000 700])
% extract the 2 by 2 maps and the corresponding barriers information
indexM = (floor(0.6*(N1))+1):(floor(0.6*(N1))+2*N1);
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
% metricName = 'cityblock';
map = addTextBarrier_distance_E(map,newL,mat2,sData,metricName);
% label the regions
map = lableRegion2(newL,map);
% make all the regions unique
map = uniqueRegion(newL,map);
% obtain the lineage information
path = obtainLineage_early(map,startS);
axis off
colorbar
printpdf(gcf,[dataName,'/Figure6'])
saveas(gcf,[pwd, '/',dataName,'/Figure6.fig'])
close all

%% Figure XX: the cellular state network
network_regions(path)

disp('======== Step 7 =====================')
%% Figure 7: plot the lineage tree
hFig = figure(7);
set(hFig, 'Position', [800 800 1000 700])
lineageTree(path.lineage',1:length(path.lineage),[])
axis off
colorbar
printpdf(gcf,[dataName,'/Figure7'])
saveas(gcf,[pwd, '/',dataName,'/Figure7.fig'])
close all

disp('======== Step 8 =====================')
%% Figure 8: the maps with 2 by 2 maps
hFig = figure(8);
set(hFig, 'Position', [800 800 1000 700])
temp1 = mat2;
temp1(newL == 0) = max(max(temp1));
imagesc(temp1)
axis off
colorbar
printpdf(gcf,[dataName,'/Figure8'])
saveas(gcf,[pwd, '/',dataName,'/Figure8.fig'])
close all

disp('======== Step 9 =====================')
%% Figure 9: the original maps with 2 by 2 maps
hFig = figure(9);
set(hFig, 'Position', [800 800 1000 700])
imagesc(mat2)
axis off
colorbar
printpdf(gcf,[dataName,'/Figure9'])
saveas(gcf,[pwd, '/',dataName,'/Figure9.fig'])
close all

disp('======== Step 10 =====================')
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
printpdf(gcf,[dataName,'/Figure10'])
saveas(gcf,[pwd, '/',dataName,'/Figure10.fig'])
close all

disp('======== Step 11 =====================')
%% Figure 11: plot the 3d landscape
hFig = figure(11);
set(hFig, 'Position', [800 800 1000 700])
map = mapRestEarly(map,newL,sData);
mat1 = landscape3D(mat2,map);
colorbar
printpdf(gcf,[dataName,'/Figure11'])
saveas(gcf,[pwd, '/',dataName,'/Figure11.fig'])
close all
save([dataName,'/',dataName])
lineage = path.lineage;
cellIdentity = map.cellIdentity;
save([dataName,'/PseudoTime_',dataName],'sData','lineage', 'cellIdentity','map','path')
