function [k]=qhypg(p,n,K,N)
k=[];
//QHYPGEO  The hypergeometric inverse cdf
//
//        k = qhypg(p,n,K,N)
//
//	Input	p	probability (scalar, vector or matrix)
//		n,K,N   nonnegative integers such that 
//			n<= N, K<= N and n-k<= N-K	
//			N is the total number of elements of the population
//			n is the number of elements which are randomly
//			  extracted
//			K is the number of elements of the population which 
//			  have the studied property
//
//	Output  k	for each p, k is the smallest integer j so
//			 that P(X <= j) >= p.

//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud

// The algorithm contains a nice vectorization trick which
// relies on the fact that if two elements in a vector
// are exactely the same then matlab's routine SORT sorts them
// into the order they had. Do not change this, Mathworks!
 
if max([mtlb_length(n),mtlb_length(K),mtlb_length(N)])>1 then
  error('Sorry, this is not implemented');
end
if or(mtlb_any(abs(2*p-1)>1)) then
  error('A probability should be 0<=p<=1, please!');
end
 
lowerlim = max(0,n-(N-K));
upperlim = min(n,K);
kk = (lowerlim:upperlim)';
nk = mtlb_length(kk);
//  Mod MG/12Jan99
// cdf = max(0,min(1,mtlb_cumsum(dhypg(kk,n,K,N))));
xx1=mtlb_cumsum(dhypg(kk,n,K,N));
xx1=min(ones(xx1),xx1);
cdf=max(zeros(xx1),xx1);

//  End Mod MG/12Jan99
cdf(max(size(cdf))) = 1;
[pp,J] = sort(p(:))
pp = pp($:-1:1)
J = J($:-1:1)
np = max(size(pp));
[S,I] = sort([pp;cdf])
S = S($:-1:1)
I = I($:-1:1)
I = find(I<=np)'-((1:np)')+lowerlim;
J(J) = (1:np)';
p(:) = I(J);
k = p;
