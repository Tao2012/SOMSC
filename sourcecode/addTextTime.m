function timeRegion = addTextTime(L,map)
label = map.label;
% get the local minimum
timeRegion = [];
s = regionprops(L, 'Centroid');
hold on
for k = 1:numel(s)
    if ~isnan(s(k).Centroid(1))
        c = s(k).Centroid;
        % calculate the mean of the first cluster
        temp1 = str2double(label(L == k));
        temp1(isnan(temp1)) = [];
        if ~isempty(temp1)
            temp1 = time_select(temp1);
            timeRegion = [timeRegion; k temp1];
            if ~isnan(temp1)
                text(c(1), c(2), sprintf('%d-Cell', temp1), ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'middle','FontSize',20,'Color','m');
            end
        end
    end
end
