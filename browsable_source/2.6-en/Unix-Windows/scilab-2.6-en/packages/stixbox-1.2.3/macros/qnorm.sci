function [x]=qnorm(p,m,s)
// The normal inverse distribution function
//   q = qnorm(p,m,s)
//	Input	 p	probability
//		 m	mean (default value is 0)
//		 s 	standard deviation (default value is 1)
//		(q,m,s can be scalar or matrix with common size)
//	Output   q  	real such that Prob(X<q)=p where X is a 
//			normal variable with mean m 
//			and standard deviation s
//       Anders Holtsberg, 13-05-94
//       Copyright (c) Anders Holtsberg
// last update: dec 2001 (jpc)
// scilab version uses cdfnor 
//
[nargout,nargin] = argn(0)
if nargin<3 then  s = ones(p);end
if nargin<2 then  m = zeros(p);end
if length(m)==1 then m=m*ones(x);end 
if length(s)==1 then s=s*ones(x);end 
x =cdfnor("X",m,s,p,1-p); 

