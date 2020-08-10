function res=stairs(x,y)
//STAIRS
//
//	Plot a stairs graph
//
//      A. Lichnewsky, 1998

x = x(:);
y = y(:); 

nelem = size(x,1);
reselem = 2*nelem -1;



if (size(y,1) <> nelem)
	error("both vectors must be of same length")
end


xx=zeros(reselem,1);
yy=zeros(reselem-1,1);

xx(1:2:reselem) = x;
xx(2:2:reselem) = x(2:nelem);

yy(1:2:reselem) = y;
yy(2:2:reselem) = y(1:(nelem-1));

plot(xx,yy);

res = 0;

