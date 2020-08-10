function [X]=rnorm(n,m,s)
//RNORM    Normal random numbers
// 
// X = rnorm(Number,Mean,StandardDeviation)
// Input  n positive integer or a 2-vector [lig, col] of 
//   positive integers
//  m mean
//  s standard deviation
// Output  X n-vector or n-matrix of normal random numbers 
//   with mean m and standard deviation s.
// 
//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg
// last update: dec 2001 (jpc)
// 
[nargout,nargin] = argn(0)
if nargin<3 then  s = 1;end
if nargin<2 then  m = 0;end
if nargin<1 then  n = 1;end
if length(n)==1 then  n = [n,1]; end 
if length(n)<>2 then error('rnorm: first argument has a wrong size');end 
X = rand(n(1),n(2),'n')*s + m;
