function [f]=df(x,a,b)
// The F density function (or Fisher-Snedecor density function)
//
//         f = df(x,df1,df2)
//	Input	x	real (scalar, vector or matrix)
//		df1,df2	degrees of freedom
//
//	Output	f	F density function at the value of x, of 
//			(X/df1)/(Y/df2) where X and Y are independent 
//			Chi^2 variables with one degree of freedom
//        Anders Holtsberg, 18-11-93
//        Copyright (c) Anders Holtsberg
//   last update: dec 2001 (jpc)
  
if or(a<=0 | b<= 0)
   error('Degrees of freedom is wrong')
end

c = b ./ a;
xx = x ./ (x+c);
f = dbeta(xx,a/2,b/2);
f = f ./ ((x+c).^2)*c;

