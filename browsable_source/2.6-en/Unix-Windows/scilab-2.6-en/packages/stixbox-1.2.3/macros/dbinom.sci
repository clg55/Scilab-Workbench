function [p]=dbinom(k,n,p)
//DBINOM  The binomial probability function
// 
//        p = dbinom(k,n,p)
//	Input	k 	nonnegative integer
//		n 	nonnegative integer such that k<=n
//		p  	probability number
//		(k,n,p can be real or matrix, the size of  matrix 
//		must be the same)
//					
//	Output 	P  prob(X=k) where X is a binomial variable B(n,p)
//       Anders Holtsberg, 16-03-95
//       Copyright (c) Anders Holtsberg
//   last update: dec 2001 (jpc)
   
if or( k<0 | k>n | p<0 | p>1) then
  error('dbinom: Strange input arguments');
end
p = bincoef(k,n) .* p.^k .* (1-p).^(n-k);
