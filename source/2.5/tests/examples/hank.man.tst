clear;lines(0);
//Example of how to use the hank macro for 
//building a Hankel matrix from multidimensional 
//data (covariance or Markov parameters e.g.)
//
//This is used e.g. in the solution of normal equations
//by classical identification methods (Instrumental Variables e.g.)
//
//1)let's generate the multidimensional data under the form :
//  C=[c_0 c_1 c_2 .... c_n]
//where each bloc c_k is a d-dimensional matrix (e.g. the k-th correlation 
//of a d-dimensional stochastic process X(t) [c_k = E(X(t) X'(t+k)], ' 
//being the transposition in scilab)
//
//we take here d=2 and n=64
//
c=rand(2,2*64)
//
//generate the hankel matrix H (with 4 bloc-rows and 5 bloc-columns)
//from the data in c
//
H=hank(4,5,c);
//
