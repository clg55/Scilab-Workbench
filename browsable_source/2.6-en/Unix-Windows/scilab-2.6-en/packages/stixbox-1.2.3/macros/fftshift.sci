function [y]=fftshift(x)
y=[];
 
[m,n] = size(x);
m1 = 1:ceil(m/2);
m2 = ceil(m/2)+1:m;
n1 = 1:ceil(n/2);
n2 = ceil(n/2+1):n;
 
// Note: can remove the first two cases when null handling is fixed.
if m==1 then
  // mtlb_e(x,n2) may be replaced by x(n2) if x is a vector.
  // mtlb_e(x,n1) may be replaced by x(n1) if x is a vector.
  y = [mtlb_e(x,n2),mtlb_e(x,n1)];
elseif n==1 then
  // mtlb_e(x,m2) may be replaced by x(m2) if x is a vector.
  // mtlb_e(x,m1) may be replaced by x(m1) if x is a vector.
  y = [mtlb_e(x,m2);mtlb_e(x,m1)];
else
  y = [x(m2,n2),x(m2,n1);x(m1,n2),x(m1,n1)];
end
