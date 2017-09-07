function network_regions(path)

N = size(path.lineageMatrix,1);
matrix1 = triu(ones(N,N),0);
matrix2 = matrix1.*path.lineageMatrix;
cm = round(matrix2,4,'significant');
bg = biograph(cm, [],'ShowWeights', 'on','EdgeFontSize',18,'ShowArrows','off');
for i = 1:length(bg.nodes)
    bg.nodes(i).Shape = 'circle';
    bg.nodes(i).size = [40 40];
    bg.nodes(i).ID = strcat('S',num2str(i));
    bg.nodes(i).FontSize = 40;
end


for i = 1:length(bg.edges)
    bg.edges(i).LineWidth = 2;
    bg.edges(i).LineColor = [0 0 0];
end

view(bg)