function [x]=qf(p,a,b)
x=[];
//
//         x = qf(p,df1,df2)
//	Input	p	probability
//		df1,df2	degrees of freedom
//		(p,df1,df2 can be scalar or matrix with common size)
//
//	Output	F	inverse at p of the F cumulative distribution
//			function with degrees of freedom df1, df2
//
//	(the F law with  degrees of freedom df1 and df2
//	 is the law of (X/df1)/(Y/df2)  where  X and Y
//	 are independent Chisquare random variables 
//	 with one degree of freedom)		 

//        Anders Holtsberg, 18-11-93
//        Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud

if or(mtlb_any(a<=0 | b<=0))
   error('degrees of freedom are wrong')
end
 
x = qbeta(p,a/2,b/2);
x = x .* b ./ ((1-x) .* a);
