function lineageTree1(p)
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

n = length(p);
hold on
plot( X, Y, 'r-');
hold on
scatter(x,y,1500,'filled')

hold on
xlabel(['height = ' int2str(h)]);
hold on
axis([0 1 0 1]);
axis off