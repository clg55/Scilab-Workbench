function [f]=dt(x,df)
//DT       The student t density function
//
//         f = dt(x,d)
//	Input	x	real
//		d	positive integer (degree of freedom)
//		(x and d can be matrix with common size)
//
//	Output	f	student density function with d degrees of freedom
//			at the values of x
//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg
//   last update: dec 2001 (jpc)
  
if or(df<=0) then
  error('DegreesOfFreedom is wrong');
end
 
f = gamma((df+1)/2)./sqrt(df*pi)./gamma(df/2).*(1+x.^2./df).^(-(df+1)/2);

