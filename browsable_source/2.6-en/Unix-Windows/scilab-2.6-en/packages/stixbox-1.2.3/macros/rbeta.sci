function [x]=rbeta(n,a,b)
// Random numbers from the beta distribution (inversion method)
//
//      x = rbeta(n,a,b)
//	Input	n	positive integer or a vector [lig,col] of 2 
//			positive integers
//		a,b	positive reals 
//	Output	x 	n-vector or a n-matrix of random numbers 
//			chosen from a beta distribution with parameters 
//			a and b (density :
//			x--> x.^(a-1) .* (1-x).^(b-1) ./ beta(a,b)1_{0<x<1}
//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg
//       last update: dec 2001 (jpc)
  
if or(a<=0|b<=0) then
  error('Parameter a or b is nonpositive');
end
 
if size(n)==1 then n = [n,1]; end
if length(n)<>2 then error('rbeta: first argument has a wrong size');end ...
x = qbeta(rand(n(1),n(2),'u'),a,b);

