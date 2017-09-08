clear all
clc
close all

load('Data/Moig2013Original.mat')

% Step 1
% Samples not expressing any genes (probably as a result of a 
% failure of the sorter to put a cell in the well) were excluded 
% from the analysis 

datalogic = (Moig2013.data == 40);
flag = sum(datalogic,2);
Moig2013.data = Moig2013.data(flag ~= 24,:);
Moig2013.celltype = Moig2013.celltype(flag ~= 24);


% Step 2
% cells not expressing the housekeeping genes Ubc (n?=?0) or Polr2a (n?=?17).
indexUbc = (Moig2013.data(:,end) ~= 40);
Moig2013.data = Moig2013.data(indexUbc,:);
Moig2013.celltype = Moig2013.celltype(indexUbc);

indexPolr2a = (Moig2013.data(:,19) ~= 40);
Moig2013.data = Moig2013.data(indexPolr2a,:);
Moig2013.celltype = Moig2013.celltype(indexPolr2a);

flag = (Moig2013.data == 40);
% Ct values were subtracted from the assumed no-template 
% background of the BioMark of 28 
Moig2013.data = 28 - Moig2013.data;

% by subtraction of the mean Ct value of Ubc and Polr2a for each cell.
meanVal = (Moig2013.data(:,end) + Moig2013.data(:,19))/2;
meanMat = repmat(meanVal,1,size(Moig2013.data,2));
Moig2013.data =  Moig2013.data - meanMat;

% set the label
label = zeros(size(Moig2013.celltype));
label(strcmp(Moig2013.celltype,'HSC')) = 1;
label(strcmp(Moig2013.celltype,'LMPP')) = 2;
label(strcmp(Moig2013.celltype,'PREMEGE')) = 3;
label(strcmp(Moig2013.celltype,'GMP')) = 4;
label(strcmp(Moig2013.celltype,'CLP')) = 5;

% The ?Ct value for genes that were not expressed was then set to 15,
% representative of the detection limit of the BioMark.
Moig2013.data = Moig2013.data.*(~flag) + 15*flag; 

% the first type of data
% for ii = 1:5
% temp = Moig2013.data(label == ii,:);
% aa = sum(temp);
% cc = sum(temp == 0);
% for jj = 1:20;
%     if cc(jj) > 0;
%        temp(temp(:,jj) == 0,jj) = aa(jj)/cc(jj); 
%     end
% end
% Moig2013.data(label == ii,:) = temp;
% end
% Moig2013.numberL = label;
% save('dataHeaMouse.mat','Moig2013')

