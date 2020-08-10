function [f]=dchisq(x,a)
f=[];
//DCHISQ   The chisquare density function
//
//         f = dchisq(x,d)
//	Input	x 	real
//		d	degree of freedom
//		(x,d can be matrix with common dimensions)
//
//	Output	f	chisquare density function with d degree of freedom
//			at the values of x 
//        Anders Holtsberg, 18-11-93
//        Copyright (c) Anders Holtsberg
//   last update: dec 2001 (jpc)
 
if or(a<=0) then
  error('dchisq: Degrees of freedom is wrong');
end

f = dgamma(x/2,a*0.5)/2;
