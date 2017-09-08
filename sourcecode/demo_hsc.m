clear all
clc
close all

% SOMSC_lineage(dataName,startS,pValue,nThreshold)
% dataname: the dataset calculated from SOM algorithm
% startS: the starting cell states
% pValue: the t-test pvalue to determine the merge pairs

% generate the folder to store the files
Folder = pwd;
DataFolder = 'Demo_hsc_test';
dataSource = 'hsc_2016';
Ngrid = 20;
isFolder = exist(DataFolder,'dir');
if isFolder == 7
    rmdir(DataFolder,'s')
    mkdir(DataFolder)
else
    mkdir(DataFolder)
end

somsc_chart(dataSource,Ngrid,DataFolder)
SOMSC_lineage(DataFolder,2,0.01,3)
load([DataFolder,'/PseudoTime_',DataFolder])
load('hsc_2016full.mat')
drivenGene(cellIdentity,lineage,Olsson2016,DataFolder)
[cell_time, cell_percent] = pseudoTime(cellIdentity,sData,lineage);
plotPseudoTime(map,path,cell_time,1899, DataFolder, 0.01,Olsson2016,22)
