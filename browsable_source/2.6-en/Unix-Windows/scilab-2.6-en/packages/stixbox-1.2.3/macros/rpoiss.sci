function [x]=rpoiss(n,l)
x=[];
[nargout,nargin] = argn(0)
//RJPOISSON   Random numbers from the poisson distribution (renewal method)
// 
//         x=rpoiss(n,l)
//       Input    n  positive integer or vector [lig,col] of integers
//                l  positive real
// 
//       Output   x  vector or matrix of random numbers
//                   chosen from a poisson distribution with parameter l
// 
 
//	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
if nargin~=2 then
  error('Wrong number of input parameters');
  return
   
end
 
if mtlb_length(n)==1 then
  n = [n,1];
end
 
if mtlb_length(n)>2|mtlb_length(l)>1 then
  error('Wrong input parameter type');
  return
   
end
 
if l<=0 then
  error('Wrong input parameter value');
  return
   
end
 
s = mtlb_zeros(n);
x = s;
t = mtlb_ones(n);
while mtlb_any(t) then
  s = s+t .* rexpweib(n,1);
  x = x+t;
  t = s<l;
end
x = x-mtlb_ones(n);
