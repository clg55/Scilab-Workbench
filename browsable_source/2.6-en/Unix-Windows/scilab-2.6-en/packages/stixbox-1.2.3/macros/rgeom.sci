function [x]=rgeom(n,p)
x=[];
[nargout,nargin] = argn(0)
//RGEOM   Random numbers from the geometric distribution
// 
//         x=rexp(n,l)
//       Input    n  positive integer or vector [lig,col] of integers
//                p  probability
// 
//       Output   x  n-vector of random numbers
//                   chosen from geometric distribution G(p)
// 
// 
 
//	Revision 01-10-98 Mathematique Universite de Paris-Sud
// 
if nargin~=2 then
  error('Wrong number of input parameters');
  return
   
end
 
if mtlb_length(n)==1 then
  n = [n,1];
end
 
if mtlb_length(n)~=2|mtlb_length(p)>1 then
  error('Wrong input parameter type');
  return
   
end
 
if p<=0|p>=1 then
  error('Wrong input parameter value');
  return
   
end
 
x = floor(log(mtlb_rand(n))/log(1-p));
