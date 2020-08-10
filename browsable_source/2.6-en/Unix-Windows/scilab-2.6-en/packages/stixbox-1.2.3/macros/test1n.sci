function [pval,cimean,cisigma]=test1n(x,cl)
pval=[];cimean=[];cisigma=[];
[nargout,nargin] = argn(0)
//TEST1N   Tests and confidence intervals based on a normal sample
//         
//         [pval, cimean, cisigma] = test1n(x,CL)
//         
//         Input  x    sample (column vector)
//                CL   confidence level for the confidence intervals
//                                                  (default 0.95). 
//
//         Output pval probability that Student variate based on x
//                     is as far from 0 as it is actually, or further away 
//                     under hypothesis that theoretical mean is 0.
//                cimean  confidence interval for the mean.
//                cisigma confidence interval for the standard deviation.
//
// (Confidence intervals of the form [LeftLimit, PointEstimate, RightLimit]).
//

//       Anders Holtsberg, 01-11-95
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
x = x(:);
if nargin<2 then
  cl = 0.95;
end
n = mtlb_length(x);
m = sum(x)/size(x,'*');
s = sqrt(var(x));
T = m/s*sqrt(n);
pval = (1-pt(abs(T),n-1))*2;
t = qt(1-(1-cl)/2,n-1);
cimean = [m-t*s/sqrt(n),m,m+t*s/sqrt(n)];
cisigma = s*[sqrt((n-1)/qchisq(1-(1-cl)/2,n-1)),1,sqrt((n-1)/qchisq((1-cl)/2,n-1))];
