close all
clc
clear all

% SOMSC_lineage(dataName,startS,pValue,nThreshold,DataFolder)
% dataname: the dataset calculated from SOM algorithm
% startS: the starting cell states
% pValue: the t-test pvalue to determine the merge pairs
% DataFolder: give the name of the folder where the figures are saved

% generate the folder to store the files
DataFolder = 'Demo_embryo_test';
dataSource = 'embryo_2010';
Ngrid = 20;
isFolder = exist(DataFolder,'dir');
if isFolder == 7
    rmdir(DataFolder,'s')
    mkdir(DataFolder)
else
    mkdir(DataFolder)
end

somsc_chart(dataSource,Ngrid,DataFolder)
SOMSC_lineage(DataFolder,9,0.01,2)
load([DataFolder,'/PseudoTime_',DataFolder])
load('embryo_2010full.mat')
drivenGene(cellIdentity,lineage,Guo2010,DataFolder)
[cell_time, cell_percent] = pseudoTime(cellIdentity,sData,lineage);
plotPseudoTime(map,path,cell_time,6, DataFolder, 0.01,Guo2010,22)