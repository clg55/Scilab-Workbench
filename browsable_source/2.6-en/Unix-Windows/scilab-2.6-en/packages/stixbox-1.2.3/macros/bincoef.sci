function [k]=bincoef(n,N)
k=[];
//  Binomial coefficients
//         k = bincoef(n,N)
//       Anders Holtsberg, 13-05-94
//       Copyright (c) Anders Holtsberg
// 	Input	n,N 	scalar or matrix with common size, such that 0<=n<=N
//
//	Output	k	matrix of binomial coefficients
//			Gamma(N+1)/(Gamma(n+1)Gamma(N-n+1))
// last update: dec 2001 (jpc)
k = exp(gammaln(N+1)-gammaln(n+1)-gammaln(N-n+1));
if and(round(n)==n) & and(round(N)==N) then
  k = round(k)
end
