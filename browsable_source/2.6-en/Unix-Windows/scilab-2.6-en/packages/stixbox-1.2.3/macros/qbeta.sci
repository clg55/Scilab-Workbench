function [x]=qbeta(p,a,b)
// The beta inverse distribution function
//
//         x = qbeta(p,a,b)
//	Input	p	probability
//		a,b	positive reals, parameters of the beta distribution
//		(p,a,b  can be scalar or matrix with common size)
//
//	Output		for each element of p, F is an ``inverse'' of the 
//			beta cumulative distribution function with parameter
//			a and b (the beta density is :
//			x--> x.^(a-1) .* (1-x).^(b-1) ./ beta(a,b)1_{0<x<1})
//       Anders Holtsberg, 27-07-95
//       Copyright (c) Anders Holtsberg
//       last update: dec 2001 (jpc)
//       completely changed in order to directly use cdfbet 
// 
if length(a)==1 then a = a*ones(p);end 
if length(b)==1 then b = b*ones(p);end 
x =cdfbet("XY",a,b,p,1-p);

 
