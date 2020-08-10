function [p]=phypg(k,n,K,N)
p=[];
//PHYPGEO  The hypergeometric cumulative probability function
//
//         p = phypg(k,n,K,N)

//	Input	k	nonnegative integers (scalar, vector or matrix)
//		n,K,N   nonnegative integers such that 
//			n<= N, K<= N and n-k<= N-K	
//			N is the total number of elements of the population
//			n is the number of elements which are randomly
//			  extracted
//			K is the number of elements of the population which 
//			  have the studied property
//
//	Output  p	for each k, p is the probability Prob(X<=k) where
//			X is an hypergeometric random variable with 
//			parameters n,K,N


//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
if max([mtlb_length(n),mtlb_length(K),mtlb_length(N)])>1 then
  error('Sorry, this is not implemented');
end
 
kk = 0:n;
cdf = mtlb_cumsum(dhypg(kk,n,K,N));
cdf(n+1) = 1;
p = k;
//        AL Mod 13Jan99 (selon MG 12 Jan 99)
// p(:) = cdf(max(1,min(n+1,floor(k(:))+1)));
xx1= floor(k(:))+1;
xx1=min((n+1)*ones(xx1),xx1);
xx1=max(ones(xx1),xx1);
p(:)=cdf(xx1);
//        End AL Mod 13Jan99
