function [p]=pbinom(k,n,p)
//PBINOM  The binomial cumulative probability function
//
//        P = pbinom(k,n,p)
//	Input	k 	vector or matrix of nonnegative integers such that k<=n
//               n 	nonnegative integer
//	        p	probability
//
//    	Output	P	prob(X<=k)where X is a binomial variable B(n,p)

//       Anders Holtsberg, 27-07-95
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
if max([mtlb_length(n),mtlb_length(p)])>1 then
  error('Sorry, this is not implemented');
end
 
kk = (0:n)';

//  AL MOD 14Jan99 from MG 12Jan99
//  cdf = max(0,min(1,[0;mtlb_cumsum(dbinom(kk,n,p))]));
xx1=[0;mtlb_cumsum(dbinom(kk,n,p))];
xx1= min(ones(xx1),xx1);
cdf= max(zeros(xx1),xx1);
//  End  AL MOD 14Jan99 

cdf(n+2) = 1;
p = k;
// mtlb_e(cdf,max(1,min(n+2,floor(k(:))+2))) may be replaced by 
//        cdf(max(1,min(n+2,floor(k(:))+2))) if cdf is a vector.

//  AL MOD 14Jan99 from MG 12Jan99
//p(:) = mtlb_e(cdf,max(1,min(n+2,floor(k(:))+2)));
xx1=floor(k(:))+2;
xx1=min((n+2)*ones(xx1),xx1);
xx1=max(ones(xx1),xx1);
p(:) = mtlb_e(cdf,xx1);
//  End  AL MOD 14Jan99 