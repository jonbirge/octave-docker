[x,y] = meshgrid(linspace(-11, 11, 128));
r = sqrt(x.^2 + y.^2);
z = sin(r)./r;
surfc(x, y, z)
savefig('testfig')
