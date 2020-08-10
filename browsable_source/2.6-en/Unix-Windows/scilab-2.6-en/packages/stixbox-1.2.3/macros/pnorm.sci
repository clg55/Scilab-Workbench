function [p]=pnorm(x,m,s)
//   The normal cumulative distribution function
//
//   p = pnorm(x,m,s)
//         
//	Input	x	real
//	  	m	mean (default value is 0)
//		s 	standard deviation (default value is 1)
//               (x,m,s can be scalar or matrix with common size)
//	Output	p	normal cumulative distribution function 
//                       with mean m and standard deviation s, 
//                       at the value of x :
//			 y=integral form -inf to x of
//			exp(-0.5*((t-m)./s)^2)./(sqrt(2*pi)*s)dt
// last update: dec 2001 (jpc)
// scilab version uses cdfnor 
[nargout,nargin] = argn(0)
if nargin<3 then  s = ones(x);end
if nargin<2 then  m = zeros(x);end
if length(m)==1 then m=m*ones(x);end 
if length(s)==1 then s=s*ones(x);end 
p =cdfnor("PQ",x,m,s);

