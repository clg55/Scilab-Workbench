function [x]=erfinv(y)
x=[];
 
%v=size(y)
x = %nan*ones(%v(1),%v(2));
 
// Coefficients in rational approximations.
 
a = [0.886226899,-1.645349621,0.914624893,-0.140543331];
b = [-2.1183777250000002,1.442710462,-0.329097515,0.012229801];
c = [-1.970840454,-1.6249064929999999,3.4295678029999999,1.641345311];
d = [3.5438892000000002,1.6370678000000001];
 
// Central range.
 
y0 = 0.7;
k = mtlb_find(abs(y)<=y0);
if or(k) then
  // mtlb_e(y,k) may be replaced by y(k) if y is a vector.
  // mtlb_e(y,k) may be replaced by y(k) if y is a vector.
  z = mtlb_e(y,k) .* mtlb_e(y,k);
  // mtlb_e(y,k) may be replaced by y(k) if y is a vector.
  x(k) = mtlb_e(y,k) .* (((a(4)*z+a(3)) .* z+a(2)) .* z+a(1)) ./ ((((b(4)*z+b(3)) .* z+b(2)) .* z+b(1)) .* z+1);
end
 
// Near end points of range.
 
//  mtlb_find((y0<y)&(y<1)) may be replaced by
//  find((y0<y)&(y<1))' if (y0<y)&(y<1) is not a row vector
k = mtlb_find((y0<y)&(y<1));
if or(k) then
  // mtlb_e(y,k) may be replaced by y(k) if y is a vector.
  z = sqrt(-log((1-mtlb_e(y,k))/2));
  x(k) = (((c(4)*z+c(3)) .* z+c(2)) .* z+c(1)) ./ ((d(2)*z+d(1)) .* z+1);
end
 
//  mtlb_find((-y0>y)&(y>-1)) may be replaced by
//  find((-y0>y)&(y>-1))' if (-y0>y)&(y>-1) is not a row vector
k = mtlb_find((-y0>y)&(y>-1));
if or(k) then
  // mtlb_e(y,k) may be replaced by y(k) if y is a vector.
  z = sqrt(-log((1+mtlb_e(y,k))/2));
  x(k) = -(((c(4)*z+c(3)) .* z+c(2)) .* z+c(1)) ./ ((d(2)*z+d(1)) .* z+1);
end
 
// Two steps of Newton-Raphson correction to full accuracy.
// Without these steps, erfinv(y) would be about 3 times
// faster to compute, but accurate to only about 6 digits.
 
x = x-(erf(x)-y) ./ (2/sqrt(%pi)*exp(-x.^2));
x = x-(erf(x)-y) ./ (2/sqrt(%pi)*exp(-x.^2));
 
// Exceptional cases.
 
//  mtlb_find(y==-1) may be replaced by
//  find(y==-1)' if y==-1 is not a row vector
k = mtlb_find(y==-1);
if or(k) then
  x(k) = -%inf*k;
end
//  mtlb_find(y==1) may be replaced by
//  find(y==1)' if y==1 is not a row vector
k = mtlb_find(y==1);
if or(k) then
  x(k) = %inf*k;
end
//  mtlb_find(abs(y)>1) may be replaced by
//  find(abs(y)>1)' if abs(y)>1 is not a row vector
k = mtlb_find(abs(y)>1);
if or(k) then
  x(k) = %nan*k;
end
 
