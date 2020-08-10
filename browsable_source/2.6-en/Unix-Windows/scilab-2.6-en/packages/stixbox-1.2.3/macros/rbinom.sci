function [X]=rbinom(num,n,p)
X=[];
//RBINOM  Random numbers from the binomial distribution (inversion method)
//
//        X = rbinom(num,n,p)
//	Input	num	positive integer or a vector [lig,col] of integers
//		n	nonnegative integer 
//		p	probability
//	Output	x	num-vector or a num-matrix of random numbers 
//			chosen from binomial distribution B(n,p)

//       Anders Holtsberg, 16-03-95
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud

 
if mtlb_length(num)==1 then
  num = [num,1];
end
X = qbinom(mtlb_rand(num),n,p);
 
