function [p]=dhypg(k,n,K,N)
p=[];
// The hypergeometric probability function
//
//      p = dhypg(k,n,K,N)
//	Input	k,n,K,N nonnegative integers such that 
//			n<= N, K<= N and n-k<= N-K	
//			N is the total number of elements of the population
//			n is the number of elements which are randomly
//			  extracted
//			K is the number of elements of the population which 
//			  have the studied property
//
//	Output  p	probability Prob(X=k) where X is an hypergeometric
//			random variable with parameters n,K,N
//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg
//   last update: dec 2001 (jpc)

if or(round(n)~=n | round(N)~=N |round(k)~=k |round(K)~=K)
    error('dhypg: requires integer arguments');
end

if or(n>N | K>N | K<0) then
  error('Incompatible input arguments');
end
 
z = k < 0 | (n-k) < 0 | k > K | (n-k)>(N-K);
//  mtlb_find(~z) may be replaced by
//  find(~z)' if ~z is not a row vector
I = mtlb_find(~z);
if mtlb_length(k)>1 then
  // mtlb_e(k,I) may be replaced by k(I) if k is a vector.
  k = mtlb_e(k,I);
end
if mtlb_length(K)>1 then
  // mtlb_e(K,I) may be replaced by K(I) if K is a vector.
  K = mtlb_e(K,I);
end
if mtlb_length(n)>1 then
  // mtlb_e(n,I) may be replaced by n(I) if n is a vector.
  n = mtlb_e(n,I);
end
if mtlb_length(N)>1 then
  // mtlb_e(N,I) may be replaced by N(I) if N is a vector.
  N = mtlb_e(N,I);
end
pp = bincoef(k,K) .* bincoef(n-k,N-K) ./ bincoef(n,N);
p = bool2s(z)*0;
if(size(p,1) == 1) then p(I) = pp(:)'; else p(I)=pp(:);end;


