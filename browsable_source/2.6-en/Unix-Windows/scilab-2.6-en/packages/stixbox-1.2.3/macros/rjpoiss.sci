function [x]=rjpoiss(n,l)
x=[];
[nargout,nargin] = argn(0)
//RJPOISSON   Random numbers from the poisson distribution (reject method)
// 
//         x=rjpoiss(n,l)
//       Input    n  positive integer or vector [lig,col] of integers
//                l  positive real
// 
//       Output   x  n-vector of random numbers
//                   chosen from a poisson distribution with parameter l
// 
 
//       Adapted from Press, Teukolsky, Vetterling
//       and Flannery, Numerical Recipes in C p.222
 
//	Jean Coursol 01-10-98 Mathematique Universite de Paris-Sud
 
if nargin~=2 then
  error('Wrong number of input parameters');
  return
   
end
 
if mtlb_length(n)==1 then
  n = [n,1];
end
 
if mtlb_length(n)~=2|mtlb_length(l)>1 then
  error('Wrong input parameter type');
  return
   
end
// 
if n<1|l<=0 then
  error('Wrong input parameter value');
  return
   
end
 
g = l*log(l)-gammaln(l+1);
 
x = mtlb_zeros(n);
t = x;
while mtlb_any(1-t)==1 then
  v = tan(%pi*mtlb_rand(n));
  y = v*sqrt(2*l)+l;
  u = y>0;
  y = floor(y) .* bool2s(u);
  t1 = (bool2s(0.9*(1+v .* v) .* exp(y*log(l)-gammaln(y+1)-g)>mtlb_rand(n))) .* bool2s(u);
  x = x+y .* (bool2s(t1>t));
  t = max(t,t1);
end
 
