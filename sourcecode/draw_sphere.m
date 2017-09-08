function h = draw_sphere(pos,R,c)
%c = [1 0 1];

[x,y,z] = sphere(50);
x = pos(1) + x * R;
y = pos(2) + y * R;
z = pos(3) + z * R;

h = surf(x,y,z,...
		'LineStyle','none');
set(h, 'FaceColor', c)
% shading interp
% lighting phong
% camlight
hold on
