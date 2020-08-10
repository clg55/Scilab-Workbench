function [k]=qbinom(pr,n,p)
k=[];
//QBINOM  The binomial inverse cdf
// 
//        k = qbinom(pr,n,p)
 
//       Anders Holtsberg, 16-03-95
//       Copyright (c) Anders Holtsberg
 
// The algorithm contains a nice vectorization trick which
// relies on the fact that if two elements in a vector
// are exactely the same then matlab's routine SORT sorts them
// into the order they had. Do not change this, Mathworks!
 
if max([mtlb_length(n),mtlb_length(p)])>1 then
  error('Sorry, this is not implemented');
end
if or(pr(:)>1)|or(pr(:)<0) then
  error('A probability should be 0<=p<=1, please!');
end
 
kk = (0:n)';
cdf = max(0,min(1,mtlb_cumsum(dbinom(kk,n,p))));
cdf(n+1) = 1;
[pp,J] = sort(pr(:))
pp = pp($:-1:1)
J = J($:-1:1)
np = max(size(pp));
[S,I] = sort([pp;cdf])
S = S($:-1:1)
I = I($:-1:1)
I = find(I<=np)'-((1:np)');
J(J) = (1:np)';
pr(:) = I(J);
k = pr;
