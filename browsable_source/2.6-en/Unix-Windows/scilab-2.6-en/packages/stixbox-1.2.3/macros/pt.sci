function [F]=pt(x,df)
F=[];
//PT       The Student t cumulative distribution function
//
//         F = pt(x,d)
//	Input 	x	real
//		d	degree of freedom
//		(x,d can be scalar or matrix with common size)
//
//	Output	F	for each element of x, F=Prob(X<x) where
//			X is a Student random variable with d 
//			degrees of freedom

//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
if or(mtlb_any(df<=0)) then
  error('Degrees Of Freedom is wrong');
end
 
df = min(df,1000000);
// make it converge and also accept Inf.
 
neg = x<0;
F = pf(x.^2,1,df);
F = 1-(1-F)/2;
F = F+(1-2*F) .* bool2s(neg);

