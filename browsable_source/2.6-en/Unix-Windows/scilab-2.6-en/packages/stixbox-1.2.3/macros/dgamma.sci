function [f]=dgamma(x,a)
//DGAMMA   The gamma density function
//
//         f = dgamma(x,a)
//	Input	x	real
//		a	positive real
//		(x,a can be vector or matrix with common dimensions)
//
//	Output	f	gamma density function with parameter a 
//			at the values of x : 
//			f(x)=x.^(a-1)exp(-x)./Gamma(a)1_{x>=0}
//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg
//   last update: dec 2001 (jpc)
   
if or(a<=0) then
  error('Parameter a is wrong');
end
if length(a)==1 then a = a*ones(x); end 
f = zeros(x);
I= find(x>=0) 
f(I) = x(I).^(a(I)-1) .* exp(-x(I)) ./ gamma(a(I));

