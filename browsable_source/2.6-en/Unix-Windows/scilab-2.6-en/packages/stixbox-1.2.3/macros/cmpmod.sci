function [z, p, es, el] = cmpmod(Y, As, Al);
p=[];es=[];el=[];
//CMPMOD   Compare linear submodel versus larger one
// 
//         [z,p, esub, e] = cmpmod(Y, Xsub, X)
// 
//	  The standard hypothesis F-test of a regular linear model 
//	  against a smaller regular one.
//
//         Output parameters:
//            z		F-test statistic value
//            p		Prob(F variate > z)
//           esub	residus vector for the submodel
//           e		residus vector for the model
// 
//	  Input parameters:
//            Y		dependant variates vector
//            Xsub	controlled variates "X" matrix for the submodel
//	      X		controlled variates "X" matrix for the model
//	  See also LSFIT
//       Anders Holtsberg, 27-07-95
//       Copyright (c) Anders Holtsberg
// last update: dec 2001 (jpc)
Y=Y(:)
n = length(Y);
ns = size(As,2);
nl = size(Al,2);
one = ones(n,1);
if norm(one-As*(As\one)) >10*%eps then
  disp('Warning: perhaps you should include an intercept column of ones.');
end
if norm(As-Al*(Al\As))> 1000*%eps then
   disp('Warning: submodel not included in model, result is rubbish!')
end
 
ths = As\Y;
Ys = As*ths;
es = Y-Ys;
 
thl = Al\Y;
Yl = Al*thl;
el = Y-Yl;
 
Rs = sum(es.^2);
Rl = sum(el.^2);
 
z = (Rs-Rl)/(nl-ns) ./ (Rl/(n-nl));
 
p = 1-pf(z,nl-ns,n-nl);
