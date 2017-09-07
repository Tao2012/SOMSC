clear all
clc
close all

% SOMSC_lineage(dataName,startS,pValue,nThreshold, mergeIs,metricName,DataFolder)
% dataname: the dataset calculated from SOM algorithm
% startS: the starting cell states
% pValue: the t-test pvalue to determine the merge pairs
% mergeIs: determine if we should merge
% metricName: choose the metric distance
% DataFolder: give the name of the folder where the figures are saved

% generate the folder to store the files
Folder = pwd;
DataFolder = 'Demo_olfactory_test';
dataSource = 'olfactory_2017';
Ngrid = 22;
isFolder = exist(DataFolder,'dir');
if isFolder == 7
    rmdir(DataFolder,'s')
    mkdir(DataFolder)
else
    mkdir(DataFolder)
end

somsc_chart(dataSource,Ngrid,DataFolder)
SOMSC_lineage(DataFolder,10,0.005,3)
load([DataFolder,'/PseudoTime_',DataFolder])
load('olfactory_2017full.mat')
[cell_time, cell_percent] = pseudoTime(cellIdentity,sData,lineage);
plotPseudoTime(map,path,cell_time,16920,DataFolder, 0.01,olfactory2017full,20)
