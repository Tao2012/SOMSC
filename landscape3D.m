function [mat0,mat3] = landscape3D(mat,map)

% assign the variables
cellMatrix = map.cellMatrix;
iMatrix = map.iMatrix;
cellNo = map.cellNo;

% revise the values of the mat
minVline = map.minVline;
row = map.row;
col = map.col;
zone = map.zone;
adjacent = map.adjacent;

values = zeros(size(zone,1));
[~,idx] = ismember(zone,adjacent,'rows');
index = idx ~= 0;
values(index) = minVline(idx(index));
mat1 = zeros(size(mat));
for i = 1:length(row)
   mat1(row(i),col(i)) = values(i); 
end
mat1(mat1 == 10000) = 0;
mat = mat1;
mat0 = mat1;

% extract the size of mat 
N1 = size(mat,1)/2;
mat = mat(1:N1,1:N1);
mat = [mat mat mat;mat mat mat;mat mat mat];

label = map.label_cell;
labels = label(1:N1,1:N1);
[X,Y] = meshgrid(1:3*N1,1:3*N1);

% smooth the landscape for one map
K = 0.045*ones(3);
mat = conv2(mat,K,'same');


% put the cells on the landscape
xy = [X(:),Y(:)];
cellBall = [];
Label = [];
mat1 = mat(:);
for i = 1:size(labels,1)
    for j = 1:size(labels,2)
        if ~strcmp(labels(i,j),'')
            cellBall = [cellBall;[j,i]];
            Label = [Label;str2double(labels(i,j))];
        end
    end
end

cell1 = cellBall;
cell2 = cellBall;
cell2(:,2) = cell2(:,2) + N1;
cell3 = cellBall;
cell3(:,2) = cell3(:,2) + 2*N1;


cell4 = cellBall;
cell4(:,1) = cell4(:,1) + N1;

cell5 = cellBall;
cell5(:,1) = cell5(:,1) + N1;
cell5(:,2) = cell5(:,2) + N1;

cell6 = cellBall;
cell6(:,1) = cell6(:,1) + N1;
cell6(:,2) = cell6(:,2) + 2*N1;

cell7 = cellBall;
cell7(:,1) = cell7(:,1) + 2*N1;

cell8 = cellBall;
cell8(:,1) = cell8(:,1) + 2*N1;
cell8(:,2) = cell8(:,2) + N1;

cell9 = cellBall;
cell9(:,1) = cell9(:,1) + 2*N1;
cell9(:,2) = cell9(:,2) + 2*N1;

cellBall = [cell1;cell2;cell3;cell4;cell5;cell6;cell7;cell8;cell9];

height = [];
for i = 1:size(cellBall,1)
    temp = cellBall(i,:);
    index = ismember(xy,temp,'rows');
    temp1 = mat1(index);
    height = [height;temp1];
end

% % get the label of cells in the well
pos1 = [];
height1 = [];
for i = 1:length(cellMatrix(:,2))
    temp = cellBall(find(Label == cellMatrix(i,2)),:);
    pos1 = [pos1;temp];
    temp1 = height(find(Label == cellMatrix(i,2)));
    height1 = [height1;temp1];
end

% 
pos2 = [];
height2 = [];
for i = 1:size(iMatrix,1)
   temp = find(iMatrix(i,:) == 1);
   temp1 = pos1(temp,:);
   temp2 = mean(temp1);
   pos2 = [pos2;temp2];
   height2 = [height2;mean(height1(temp))];
end
[~,ia] = setdiff(cellNo,Label);
pos2 = pos2(ia,:);
height2 = height2(ia);


cell1 = pos2;
cell2 = pos2;
cell2(:,2) = cell2(:,2) + N1;
cell3 = pos2;
cell3(:,2) = cell3(:,2) + 2*N1;


cell4 = pos2;
cell4(:,1) = cell4(:,1) + N1;

cell5 = pos2;
cell5(:,1) = cell5(:,1) + N1;
cell5(:,2) = cell5(:,2) + N1;

cell6 = pos2;
cell6(:,1) = cell6(:,1) + N1;
cell6(:,2) = cell6(:,2) + 2*N1;

cell7 = pos2;
cell7(:,1) = cell7(:,1) + 2*N1;

cell8 = pos2;
cell8(:,1) = cell8(:,1) + 2*N1;
cell8(:,2) = cell8(:,2) + N1;

cell9 = pos2;
cell9(:,1) = cell9(:,1) + 2*N1;
cell9(:,2) = cell9(:,2) + 2*N1;

cellBall2 = [cell1;cell2;cell3;cell4;cell5;cell6;cell7;cell8;cell9];
cellHeight2 = [height2;height2;height2;height2;height2;height2;height2;height2;height2];

cellBall3 = [cellBall;cellBall2];
cellHeight3 = [height;cellHeight2];

surf(X,Y,mat,'EdgeColor','none','FaceColor','interp','FaceLighting','none')
r = 0.2;
[x,y,z] = sphere;
for i = 1:size(cellBall3,1)
    hold on
    temp = cellBall3(i,:);
    surf(x*r+temp(1), y*r+temp(2),0.3*z*r+cellHeight3(i)+r,'EdgeColor','none','FaceColor','m','FaceLighting','gouraud');
end
% xlim([11,50])
% ylim([11,50])
% zlim([-1 8])
camlight('headlight')
axis off
mat3 = mat;
% alpha(0.5)

