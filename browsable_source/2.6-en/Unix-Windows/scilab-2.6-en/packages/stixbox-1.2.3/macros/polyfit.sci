function [p,cr] = polyfit(x,y,n)

if prod(size(x))<>prod(size(y))  then
  error('x and y  must be with the same size')
end

if(size(x,1) == 1) then x=x';end;
if(size(y,1) == 1) then y=y';end;
nx=prod(size(x));ny=prod(size(y));

vander = zeros(nx,n+1);
vander(:,n+1) = ones(nx,1);
for j = n:-1:1,
    vander(:,j) = x.*vander(:,j+1);
end;

[Q,R] = qr(vander,0);
Q = Q(:,1:size(R,2))
R = R(1:size(R,2),:)
p = R\(Q'*y); 
r = y - vander*p; //residuals
p = p($:-1:1);    //cofficients of the polynomial
p=p';
freed = ny - (n+1); //degree of freedom
//on return : choleski factor and the norm of residuals
cr = [R; [freed zeros(1,n)]; [norm(r) zeros(1,n)]];
