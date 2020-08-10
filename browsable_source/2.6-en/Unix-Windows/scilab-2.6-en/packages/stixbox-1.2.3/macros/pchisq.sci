function [F]=pchisq(x,a)
F=[];
//PCHISQ   The chisquare distribution function
//
//         F = pchisq(x,d)
//	Input	x	real
//		d	degree of freedom
//		(x,d can be scalar or matrix with common size)
//
//	Output	F	for each element of x, F=Prob(X<x) where
//			X is a chisquare random variable 
//			with  d degrees of freedom

//        Anders Holtsberg, 18-11-93
//        Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
if or(mtlb_any(a<=0)) then
  error('Degrees Of Freedom is wrong');
end
 
F = pgamma(x/2,a*0.5);
