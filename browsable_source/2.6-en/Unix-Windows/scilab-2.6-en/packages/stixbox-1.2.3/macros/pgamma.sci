function [F]=pgamma(x,a)
//  The gamma cumulative distribution function
//         F = pgamma(x,a)
//	Input	x	real
//		a	positive real, parameter of the gamma distribution
//		(x and a can be matrix with common size)
//
//	Output	F	F =Prob(X<x) where X is a random variable with a gamma
//			distribution of parameter a
//	( the gamma density function with parameter a is :
//	   x --> x.^(a-1)exp(-x)./Gamma(a)1_{x>=0} )
//
// last update: dec 2001 (jpc)
// scilab version uses cdfgam 
//
if length(a)==1 then a=a*ones(x);end 
I0 = find(x>= 0);
F= 0*ones(x); 
if I0<>[] then 
  F(I0)= cdfgam("PQ",x(I0),a(I0),ones(x(I0)));
end


