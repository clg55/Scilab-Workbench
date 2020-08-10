function [x]=qgamma(p,a,scale)
x=[];
//QGAMMA   The gamma inverse distribution function
//
//         x = qgamma(p,a)
//	Input	p	probability
//		a	positive real, parameter of the gamma distribution
//		(p and a can be matrix with common size)
//              scale   parameter 
//	Output	F	inverse of the gamma cumulative distribution 
//			function of parameter a and scale at p 
//      Anders Holtsberg, 18-11-93
//      Copyright (c) Anders Holtsberg
//	Revision 01-10-98 Mathematique Universite de Paris-Sud
//
//      last update: dec 2001 (jpc)
// 
[lhs,rhs]=argn(0) ; 
if rhs <=2 then scale = 1;end 
if length(a)==1 then a = a*ones(p);end 
if length(scale)==1 then scale = scale*ones(p);end 
x =cdfgam("X",a,scale,p,1-p);
