function [F]=pbeta(x,a,b)
//  The beta cumulative distribution function
//
//         F = pbeta(x,a,b)
//	Input	x	matrix (elements between 0 and 1)
//		a,b	positive reals, parameters of the beta distribution
//		(x,a,b  can be scalar or matrix with common size)
//
//	Output	F	for each element of x, F=Prob(X<x) where X is a random 
//			variable with beta density :
//			x--> x.^(a-1) .* (1-x).^(b-1) ./ beta(a,b)1_{0<x<1}
//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg
//       last update: dec 2001 (jpc)
//       completely changed in order to directly use cdfbet 
if length(a)==1 then a = a*ones(x);end 
if length(b)==1 then b = b*ones(x);end 

Ii = find(x>0 & x<1);
F = 0*ones(x);
Iu = find(x>=1);
if Iu<>[] then F(Iu)=1 ;end 
if Ii<>[] then
  F1=cdfbet("PQ",x(Ii),1-x(Ii),a(Ii),b(Ii))
  F(Ii)=F1;
end
