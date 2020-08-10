function [pval,cimean,cisigma]=test2n(x,y,cl)
pval=[];cimean=[];cisigma=[];
[nargout,nargin] = argn(0)
//TEST2N   Tests and confidence intervals based on two normal samples
//         with common variance.
//         
//         [pval, cidiffmean, cisigma] = test2n(x,y,CL)
//
//         Input  x,y samples (column vectors)
//                CL   confidence level for the confidence intervals
//                                                  (default 0.95). 
//
//         Output pval probability that Student statistic based on x and y
//                     is as far from 0 as it is actually, or further away 
//                     under hypothesis that theoretical means are equal.
//                cdiffmean  confidence interval for the difference of means.
//                cisigma    confidence interval for the standard deviation.
//            
// (Confidence intervals of the form [LeftLimit, PointEstimate, RightLimit]).
//         

//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg

// 	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
x = x(:);
y = y(:);
if nargin<3 then
  cl = 0.95;
end
nx = mtlb_length(x);
ny = mtlb_length(y);
mx = sum(x)/size(x,'*');
my = sum(y)/size(x,'*');
m = mx-my;
df = nx+ny-2;
s = sqrt(((nx-1)*var(x)+(ny-1)*var(y))/df);
d = s*sqrt(1/nx+1/ny);
T = m/d;
pval = (1-pt(abs(T),df))*2;
t = qt(1-(1-cl)/2,df);
cimean = [m-t*d,m,m+t*d];
cisigma = s*[sqrt(df/qchisq(1-(1-cl)/2,df)),1,sqrt(df/qchisq((1-cl)/2,df))];
