function somsc_chart(dataSource,Ngrid,dataName)
% load('olfactory2017.mat')
load(dataSource)
Data.D = data;
% Data.celltype = alfactory2017.numberL;
Data.celltype = numberL;
parameter.label = 0;
parameter.Ns = Ngrid;
parameter.priorN = 0;
[sMap_cell,mat,sData] = somsc(Data,parameter);
parameter.label = 1;
[sMap_time,~,~] = somsc(Data,parameter);
save(dataName)
% set(gcf, 'Position', [0, 400, 1400, 800]);
% printpdf(gcf,'manuscript\heaCellL')
% close all
% parameter.label = 2;
% somsc(Data,parameter)
% set(gcf, 'Position', [0, 400, 1400, 800]);
% printpdf(gcf,'manuscript\heaCell')