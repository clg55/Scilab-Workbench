function [x]=rchisq(n,a)
x=[];
//RCHISQ   Random numbers from the chisquare distribution
//   x = rchisq(n,d)
//   nput	n	positive integer or a vector [lig,col] of integers
//		d	degree of freedom
//
//   Output	x	n-vector or a n-matrix of random numbers 
//			chosen from chisquare distribution with d degrees 
//			of freedom
//        Anders Holtsberg, 18-11-93
//        Copyright (c) Anders Holtsberg
// 	Revision 01-10-98 Mathematique Universite de Paris-Sud
if or(mtlb_any(a<=0)) then
  error('Degrees Of Freedom is wrong');
end
x = rgamma(n,a*0.5,0.5);
