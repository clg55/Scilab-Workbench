function [x]=qchisq(p,a)
x=[];
//QCHISQ   The chisquare inverse distribution function
//
//         x = qchisq(p,d)
//	Input	p	probability
//		d	degree of freedom
//		(p,d can be scalar or matrix with common size)
//
//	Output	F	for each element of p, F is the value at p of an 
//			inverse of the chisquare cumulative distribution 
//			function  d degrees of freedom

//        Anders Holtsberg, 18-11-93
//        Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
if or(mtlb_any(abs(2*p-1)>1)) then
  error('A probability should be 0<=p<=1, please!');
end
if or(mtlb_any(a<=0)) then
  error('Degrees Of Freedom is wrong');
end
 
x = qgamma(p,a*0.5)*2;
