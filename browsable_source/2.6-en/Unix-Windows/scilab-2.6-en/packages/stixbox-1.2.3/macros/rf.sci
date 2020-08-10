function [x]=rf(n,a,b)
x=[];
//RF       Random numbers from the F distribution (inversion method)
//
//         x = rf(n,df1,df2)
//	Input	n	positive integer or a vector [lig,col] of integers
//		df1,df2	degrees of freedom
//
//	Output	x	n-vector or a n-matrix of random numbers 
//			chosen from Fisher-Snedecor distribution with
//			df1 and df2 degrees of freedom
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
 
x = rbeta(n,a/2,b/2);
x = x .* b ./ ((1-x) .* a);
 
