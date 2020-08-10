function [ci,y]=ciboot(x,theta,method,C,B,p1,p2,p3,p4,p5,p6,p7,p8,p9)
ci=[];y=[];
[nargout,nargin] = argn(0)
//CIBOOT   Various bootstrap confidence interval.
// 
//	  ci = ciboot(x,'T',method,C,B)
//	
//	  Compute a bootstrap confidence interval for T(X) with level
//	  C. Default for C is 0.90. Number of resamples is B, with default
//	  that is different for different methods. The method is
// 
//	  1.  Normal approximation (std is bootstrap).
//	  2.  Simple bootstrap principle (bad, don't use).
//	  3.  Studentized, std is computed via jackknife (If T is
//	      'mean' this done the fast way via the routine TEST1B).
//	  4.  Studentized, std is 30 samples' bootstrap.
//	  5.  Efron's percentile method.
//	  6.  Efron's percentile method with bias correction (BC).
// 
//	  Default method is 5. Often T(X) is a number but it may also
//	  be a vector or a even a matrix. Every row of the result ci
//	  is of the form
//	
//	      [LeftLimit, PointEstimate, RightLimit]
// 
//	  and the corresponding element of T(X) is found by noting
//	  that t = T(X); t = t(:); is used in the routine. Try for
//	  example X = rand(13,2), C = cov(X), ci = ciboot(X,'cov').
// 
//	  See also STDBOOT and STDJACK.
 
//       Anders Holtsberg, 14-12-94
//       Copyright (c) Anders Holtsberg
 
if nargin<5 then
  B = [];
end
if nargin<4 then
  C = [];
end
if nargin<3 then
  method = [];
end
arglist = [];
for i = 6:nargin
  arglist = arglist+',p'+string(i-5);
end
if min(size(x))==1 then
  x = x(:);
end
if method==[] then
  method = 5;
end
if C==[] then
  C = 0.9;
end
alpha = (1-C)/2;
[n,nx] = size(x);
 
// === 1 ================================================
 
if method==1 then
  if B==[] then
    B = 500;
  end
  s = evstr('stdboot(x,theta,B'+arglist+')');
  s = s(:);
  t0 = evstr(theta+'(x'+arglist+')');
  t0 = t0(:);
  z = qnorm(1-(1-C)/2);
  ci = [t0-z*s,t0,t0+z*s];
  return
   
end
 
// === 2 5 6 ==============================================
 
if method==2|method==5|method==6 then
  if B==[] then
    B = 500;
  end
  execstr('[s,y] = stdboot(x,theta,B'+arglist+')')
  t0 = evstr(theta+'(x'+arglist+')');
  t0 = t0(:);
  if method==2|method==5 then
    q = quantile(y',[alpha,1-alpha]',1);
    if method==2 then
      ci = [2*t0-q(2,:)',t0,2*t0-q(1,:)'];
    else
      ci = [q(1,:)',t0,q(2,:)'];
    end
  else
    J = (bool2s(y<t0)+bool2s(y<=t0))/2;
    z0 = qnorm(mtlb_sum(J)/max(size(J)));
    beta = pnorm(qnorm([alpha,1-alpha]')+2*z0);
    q = quantile(y',beta,1);
    ci = [q(1,:)',t0,q(2,:)'];
  end
  return
   
end
 
// === 3 'mean' ===========================================
 
if (method==3)&(theta=='mean') then
  if B==[] then
    B = 1000;
  end
  [dummy1,ci,dummy2,y] = test1b(x,C,B);
  return
   
end
 
// === 3 4 ================================================
 
if method==3|method==4 then
  if B==[] then
    B = 200;
  end
  evalstring1 = theta+'(xb'+arglist+')';
  if method==3 then
    evalstring2 = 'stdjack(xb,theta'+arglist+')';
  else
    evalstring2 = 'stdboot(xb,theta,30'+arglist+')';
  end
  xb = x;
  t0 = evstr(evalstring1);
  s0 = evstr('stdboot(xb,theta,200'+arglist+')');
  t0 = t0(:);
  s0 = s0(:);
  y = zeros(mtlb_length(t0(:)),B);
//  tic = tic;
//  nfl = flops;
//  fprintf(' B-i      flops\n');
  for i = 1:B
    xb = rboot(x);
    tb = evstr(evalstring1);
    sb = evstr(evalstring2);
    tb = tb(:);
    sb = sb(:);
    y(:,i) = (tb-t0) ./ sb;
//    if toc>1 then
//      tic = tic;
      // fprintf('%4.0f %10.0f\n',B-i,flops-nfl),
//    end
  end
  q = quantile(y',[alpha,1-alpha]',1);
  ci = [t0-s0 .* q(2,:)',t0,t0-s0 .* q(1,:)'];
  return
   
end
