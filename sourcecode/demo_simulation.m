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
DataFolder = 'Demo_simulation_test';
dataSource = 'simulation_2017';
Ngrid = 18;
isFolder = exist(DataFolder,'dir');
if isFolder == 7
    rmdir(DataFolder,'s')
    mkdir(DataFolder)
else
    mkdir(DataFolder)
end

somsc_chart(dataSource,Ngrid,DataFolder)
SOMSC_lineage(DataFolder,6,0.001,2)