function [x]=qt(p,a)
x=[];
//QT       The student t inverse distribution function
//
//         x = qt(p,d)
//	Input 	p	probability
//		d	positive integer (degree of freedom)
//		(p,d can be scalar or matrix with common size)
//
//	Output	x	value at p of an inverse of the student 
//			cumulative distribution with degree of 
//			freedom d

//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud

if or(mtlb_any( a<=0 | round(a)~=a))
    error('degree of freedom is wrong')
end
 
s = p<0.5;
p = p+(1-2*p) .* bool2s(s);
p = 1-2*(1-p);
x = qbeta(p,1/2,a/2);
x = x .* a ./ (1-x);
x = (1-2*bool2s(s)) .* sqrt(x);
