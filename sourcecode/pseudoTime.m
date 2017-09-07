function [cell_time, cell_percent] = pseudoTime(cellIdentity,sData,lineage)

% calculate the center for each state
state_index = unique(cellIdentity(:,1));
center = [];
dataDist = {};
dataCell = {};
for i = 1:length(state_index)
    index = cellIdentity(cellIdentity(:,1) == i,2);
    dataDist{i} = sData.data(index,:);
    dataCell{i} = index;
    if length(index) > 1
        dataTemp = mean(sData.data(index,:));
    else
        dataTemp =  sData.data(index,:);
    end
    center = [center;dataTemp];
end

cell_time = {};
% from the starting point
for i = 1:length(state_index)
    parent = lineage(i);
    daughter = find(lineage == i);
    N_col = length(parent(parent ~= 0)) + length(daughter(daughter ~= 0));
    dataTemp = dataDist{i};
    info_matrix = zeros(size(dataTemp,1),2*N_col + 1);
    data_current = dataDist{i} - repmat(center(i,:),size(dataTemp,1),1);
    % to parents
    if parent ~= 0 && ~isempty(daughter)
        parent_current = center(parent,:) - center(i,:); % the vector from center to parent
        length_parent_current = norm(parent_current);
        for j = 1:size(dataTemp,1)
            info_matrix(j,1) = dot(data_current(j,:),parent_current)/length_parent_current;
            info_matrix(j,2) = norm(data_current(j,:) - info_matrix(j,1)*parent_current);
        end
        % to daughters
        for j = 1:length(daughter)
            daughter_current = center(daughter(j),:) - center(i,:);
            length_daughter_current = norm(daughter_current);
            for k = 1:size(dataTemp,1)
                info_matrix(k,2*j+1) = dot(data_current(k,:),daughter_current)/length_daughter_current;
                info_matrix(k,2*j+2) = norm(data_current(k,:) - info_matrix(k,2*j+1)*daughter_current);
            end
        end
        % to current
        for j = 1:size(dataTemp,1)
            info_matrix(j,end) = norm(data_current(j,:));
        end
        cell_order = [];
        % based on the info_matrix to determine the cell order
        for j = 1:size(info_matrix,1)
            temp = determine_dist(info_matrix(j,:));
            cell_order = [cell_order; temp];
        end
        cell_order = [cell_order dataCell{i}];
        
        % divide themm into three parts
        index1 = find(cell_order(:,1) < 0);
        data1 = cell_order(index1,:);
        data1(:,2) =  -1*data1(:,2);
        [~,I] = sort(data1(:,2));
        data1 = data1(I,:);
        
        index2 = find(cell_order(:,1) == 0);
        data2 = cell_order(index2,:);
        [~,I] = sort(data2(:,2));
        data2 = data2(I,:);
        
        
        index3 = find(cell_order(:,1) > 0);
        data3 = cell_order(index3,:);
        [~,I] = sort(data3(:,2));
        data3 = data3(I,:);
        
        cell_time{i} = [data1;data2;data3];
        temp = cell_time{i};
        celltype = [0, daughter'];
        numberCell = sum(temp(:,1) >= 0);
        for j = 1:length(daughter)
            numberCell = [numberCell sum(temp(:,1) == j)];
        end
        percentCell = numberCell/sum(numberCell);
        cell_percent{i} = [celltype; numberCell; percentCell];
    end
    if parent == 0 && ~isempty(daughter)
        % to daughters
        for j = 1:length(daughter)
            daughter_current = center(daughter(j),:) - center(i,:);
            length_daughter_current = norm(daughter_current);
            for k = 1:size(dataTemp,1)
                info_matrix(k,2*(j-1)+1) = dot(data_current(k,:),daughter_current)/length_daughter_current;
                info_matrix(k,2*(j-1)+2) = norm(data_current(k,:) - info_matrix(k,2*(j-1)+1)*daughter_current);
            end
        end
        info_matrix(:,end) = [];
        
        cell_order = [];
        % based on the info_matrix to determine the cell order
        for j = 1:size(info_matrix,1)
            temp = determine_dist_noParent(info_matrix(j,:));
            cell_order = [cell_order; temp];
        end
        cell_order = [cell_order dataCell{i}];
        
        % divide themm into three parts
        data3 = cell_order;
        [~,I] = sort(data3(:,2));
        data3 = data3(I,:);
        cell_time{i} = data3;
        
        temp = cell_time{i};
        celltype = [0 daughter'];
        numberCell = sum(temp(:,2) <= 0);
        for j = 1:length(daughter)
            numberCell = [numberCell sum((temp(:,1) == j) & (temp(:,2) > 0))];
        end
        percentCell = numberCell/sum(numberCell);
        cell_percent{i} = [celltype; numberCell; percentCell];
    end
    
    % to parents
    if parent ~= 0 && isempty(daughter)
        parent_current = center(parent,:) - center(i,:); % the vector from center to parent
        length_parent_current = norm(parent_current);
        for j = 1:size(dataTemp,1)
            info_matrix(j,1) = dot(data_current(j,:),parent_current)/length_parent_current;
            info_matrix(j,2) = norm(data_current(j,:) - info_matrix(j,1)*parent_current);
        end
        info_matrix(:,end) = [];
        cell_order = [];
        % based on the info_matrix to determine the cell order
        for j = 1:size(info_matrix,1)
            temp = determine_dist_noDaughter(info_matrix(j,:));
            cell_order = [cell_order; temp];
        end
        cell_order = [cell_order dataCell{i}];
        
        % divide themm into three parts
        data1 = cell_order;
        data1(:,2) =  -1*data1(:,2);
        [~,I] = sort(data1(:,2));
        data1 = data1(I,:);
        
        cell_time{i} = data1;
        
        celltype = [0 0];
        temp = cell_time{i};
        numberCell = sum(temp(:,2) <= 0);
        numberCell = [numberCell sum((temp(:,2) > 0))];
        percentCell = numberCell/sum(numberCell);
        cell_percent{i} = [celltype; numberCell; percentCell];
        
    end
end