function [z]=%pds(x,y)
//z = x ./ y , x vector of polynomials y scalar
// and other matrix polynomial
[m,n]=size(x)
if m*n==1 then
  z=x*ones(y)./y
else
  z=x./y*ones(x)
end
