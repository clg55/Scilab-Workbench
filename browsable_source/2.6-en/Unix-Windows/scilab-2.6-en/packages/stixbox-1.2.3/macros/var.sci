function [y]=var(x)
// VAR    Variance (normalized by n-1 where n is the sample length)
//
//        Input    x    vector or matrix
//
//        Outpout  v    - variance of x, if x is a vector
//                      - row vector containing the variance of 
//                        each column of x, if x is a matrix
//	 Revision 03-2-99 Mathematique Universite de Paris-Sud

y=[];
[nargout,nargin] = argn(0)
 
if min(size(x))==1 then
  x = x(:);
end
 
[m,n] = size(x);
 
if x==[] then  y = %nan;  return end
 
if m==1 then
  y = 0;
  return
end
 
s=sum(x,'r')
s2=sum(x.*x,'r');
y=(s2-s.*s/m)/(m-1);

 
