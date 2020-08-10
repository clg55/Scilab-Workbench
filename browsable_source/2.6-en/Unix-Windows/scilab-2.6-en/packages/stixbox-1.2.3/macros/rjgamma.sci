function [x]=rjgamma(n,a)
x=[];
[nargout,nargin] = argn(0)
//RJGAMMA     Generates gamma random deviates.
//           x=rjgamma(n,a)
//	Input	n	positive integer or vector [lig,col] of integers
//               a       positive real
// 
//       Output  x       n-vector of random numbers
//                       chosen from gamma distribution with parameter a
 
// GKS 31 July 93
 
// Algorithm for A >= 1 is Best's rejection algorithm XG
// Adapted from L. Devroye, """"Non-uniform random variate
// generation"""", Springer-Verlag, New York, 1986, p. 410.
 
// Algorithm for A < 1 is rejection algorithm GS from
// Ahrens, J.H. and Dieter, U. Computer methods for sampling
// from gamma, beta, Poisson and binomial distributions.
// Computing, 12 (1974), 223 - 246.  Adapted from Netlib
// Fortran routine.
 
//	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
if nargin~=2 then
  error('Wrong number of input parameters');
  return
   
end
 
if mtlb_length(n)==1 then
  n = [n,1];
end
 
if mtlb_length(n)~=2|mtlb_length(a)>1 then
  error('Wrong input parameter type');
  return
   
end
 
if a<=0 then
  error('Wrong input parameter value');
  return
   
end
 
x = mtlb_zeros(n);
accept = x;
 
if a>=1 then
   
  b = a-1;
  c = 3*a-0.75;
  while mtlb_any(1-accept)== %T then
    u = mtlb_rand(n);
    w = u .* (1-u);
    y = sqrt(c ./ w) .* (u-0.5);
    gam = b+y;
    z = 64.*w.^3 .* mtlb_rand(n).^2;
    acc = (z<=(1-2.*y.^2 ./ gam));
    if a==1 then
      accept1 = (bool2s(gam>=0)) .* (bool2s(acc)+(1-acc) .* (bool2s(log(z)<=-2*y)));
    else
      accept1 = (bool2s(gam>=0)) .* (bool2s(acc)+(1-acc) .* (bool2s(log(z) <= real(2*(b*log(gam/b)-y)))));
    end
    change = accept1>accept;
    x = x+gam .* bool2s(change);
    accept = max(accept,accept1);
  end
   
else
   
  b = 1+0.3678794*a;
  while mtlb_any(1-accept)== %T then
    p = b*mtlb_rand(n);
    u = -log(mtlb_rand(n));
    gam = (bool2s(p<1)) .* exp(log(p)/a)-(bool2s(p>=1)) .* log((b-p)/a);
    accept1 = (bool2s(p<1)) .* (bool2s(u>=gam))+(bool2s(p>=1)) .* (bool2s(u>=(1-a)*log(gam)));
     
    x = x+gam .* (bool2s(accept1>accept));
    accept = max(accept1,accept);
  end
   
end
