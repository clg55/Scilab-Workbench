function [F]=pf(x,a,b)
F=[];
//PF       The F (or Fisher-Snedecor) cumulative distribution function 
//
//         F = pf(x,df1,df2)
//	Input	x	real
//		df1,df2 degrees of freedom
//		(x,df1,df2 can be scalar or matrix with common size)
//
//	Output	F	for each element of x, F=Prob((X/df1)/(Y/df2) < x)
//			where X and Y are independent Chisquare random 
//			variables with one degree of freedom

//        Anders Holtsberg, 18-11-93
//        Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud

if or(mtlb_any(a<=0 | b<=0 | round(a)~=a | round(b)~=b))
   error('Degrees of freedom are wrong')
end

x = x ./ (x+b ./ a);
F = pbeta(x,a/2,b/2);

