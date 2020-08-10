function [x]=rgamma(n,a,s)
//RGAMMA   Random numbers from the gamma distribution (inversion method)
//
//         x = rgamma(n,a)
//	Input	n	positive integer or a vector [lig,col] of integers
//		a	positive real 
//
//	Output	x	n-vector or a n-matrix of random numbers 
//			chosen from Gamma distribution with parameter a
// 
//	( the gamma density function with parameter a is :
//	   x --> x.^(a-1) exp(-x)./Gamma(a)1_{x>=0} )
//        Anders Holtsberg, 18-11-93
//        Copyright (c) Anders Holtsberg
// last update: dec 2001 (jpc)
[lhs,rhs]=argn(0) ; 
if rhs <=2 then s = 1;end 
if or(a<=0) then
  error('Parameter a is wrong');
end
if size(n)==1 then n = [n,1]; end
x = qgamma(rand(n(1),n(2),'u'),a,s);
