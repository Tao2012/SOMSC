% data = D;
% label = 0; % label using the cell index
% label = 1; % label using the cell type
% Ns = 22; 
% isLabel = 1 % add the label information on the plot
% N = 60  % the total levels of contour map
% c = 0.3  % the parameter in the plot
% isPattern = 0 % no periodic map

function [sMap,mat,sData] = somsc(Data,parameter)
diary trash.out
label = parameter.label;
Ns = parameter.Ns;
% isLabel = parameter.isLabel;
% N = parameter.N;
% c = parameter.c;
priorN = parameter.priorN;
% iswell = parameter.iswell;
data = Data.D;
% numberL1 = Data.celltype1;
numberL = Data.celltype;
% isPattern = parameter.isPattern;
% showRange = parameter.showRange;
% u0 = parameter.u0;
% transform the data structure
sData = som_data_struct(data,'name','SOMSC');
% normalize the data
sData = som_normalize(sData,'var');
% add data label
if label < 1
    for i = 1:size(sData.data,1)
        sData = som_label(sData,'add',i,num2str(i + priorN));
%        sData = som_label(sData,'add',i,num2str(numberL1(i)));
    end
else
    for i = 1:size(sData.data,1)
        sData = som_label(sData,'add',i,num2str(numberL(i)));
    end
end
% run som main function
sMap = som_make(sData,'msize', [Ns Ns],'lattice', 'rect','shape','toroid');
% add label to the data structure
sMap = som_autolabel(sMap,sData,'vote');
% plot the result
U = som_umat(sMap);
mat = U(1:2:size(U,1),1:2:size(U,2));
