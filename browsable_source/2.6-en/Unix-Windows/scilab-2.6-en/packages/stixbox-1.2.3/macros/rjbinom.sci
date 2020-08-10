function [m]=rjbinom(num,n,p)
m=[];
[nargout,nargin] = argn(0)
//RJBINOM  Random numbers from the binomial distribution (reject method)
// 
//        x = rjbinom(num,n,p)
//	Input	num	positive integer or vector [lig,col] of integers
//		n	nonnegative integer
//		p	probability (scalar)
//	Output	x	vector or matrix of random numbers
//			chosen from binomial distribution B(n,p)
 
//       Adapted from Press, Teukolsky, Vetterling
//       and Flannery, Numerical Recipes in C p.220
 
//	Jean Coursol 01-10-98 Mathematique Universite de Paris-Sud
 
if nargin~=3 then
  error('Wrong number of input parameters');
  return
   
end
 
if mtlb_length(num)==1 then
  num = [num,1];
end
 
if mtlb_length(num)~=2|mtlb_length(n)>1|mtlb_length(p)>1 then
  error('Wrong input parameter type');
  return
   
end
 
if n<1|p<0|p>1 then
  error('Wrong input parameter value');
  return
   
end
 
if p>0.5 then
  pp = p;
else
  pp = 1-p;
end
 
mmean = n*pp;
sq = sqrt(2*mmean*(1-pp));
g = gammaln(n+1);
plog = log(pp);
qlog = log(1-pp);
 
 
if n<25 then
  m = mtlb_zeros(num);
  for j = 1:n
    m = m+bool2s(mtlb_rand(num)<pp);
  end
else
  m = mtlb_zeros(num);
  t = m;
  while mtlb_any(1-t)==1 then
    y = tan(%pi*mtlb_rand(num));
    mm = sq*y+mmean;
    uu = (bool2s(mm>=0)) .* (bool2s(mm<=(n+1)));
    mm = floor(mm) .* uu;
    tt = 1.2*sq*(1+y .* y) .* exp(g-gammaln(mm+1)-gammaln(n-mm+1)+plog*mm+qlog*(n-mm))-mtlb_rand(num);
    t1 = uu .* (bool2s(tt>0));
    m = m+mm .* (bool2s(t1>t));
    t = max(t,t1);
  end
end
 
if p~=pp then
  m = n-m;
end
 
