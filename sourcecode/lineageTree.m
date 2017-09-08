function lineageTree(p,label,weight)
% p = [0 1 2 2 4 4 4 1 8 8 10 10];
%

[x,y,h]=treelayout1(p);
f = find(p~=0);
pp = p(f);
X = [x(f); x(pp); NaN(size(f))];
Y = [y(f); y(pp); NaN(size(f))];

X = X(:);
Y = Y(:);
Xw = mean([x(f)' x(pp)'],2);
Yw = mean([y(f)' y(pp)'],2);

N = length(X);

tempX = X(1);
tempY = Y(1);
for i = 2:N
    
    tempX = [tempX X(i-1)];
    tempY = [tempY (Y(i-1) + Y(i))/2];   
    
    tempX = [tempX X(i)];
    tempY = [tempY (Y(i-1) + Y(i))/2];
    
    tempX = [tempX X(i)];
    tempY = [tempY Y(i)];
end


n = length(p);
hold on
plot( tempX, tempY, 'k','LineWidth',5);
hold on
scatter(x,y,1500,'filled','MarkerFaceColor',[224 224 224]/255)
for i = 1:length(x)
    if label(i) < 10
        text(x(i) - 0.008,y(i),num2str(label(i)),'fontSize',28)
    else
        text(x(i) - 0.02,y(i),num2str(label(i)),'fontSize',28)
    end
end
if ~isempty(weight)
    for i = 1:length(Xw)
        %     text(Xw(i) - 0.02,Yw(i) - 0.01,num2str(weight(i,),3),'fontSize',12);
        text(Xw(i) - 0.02,Yw(i) + 0.01,num2str(weight(i),3),'fontSize',18);
    end
end
hold on
xlabel(['height = ' int2str(h)]);
hold on
axis([0 1 0 1]);
axis off