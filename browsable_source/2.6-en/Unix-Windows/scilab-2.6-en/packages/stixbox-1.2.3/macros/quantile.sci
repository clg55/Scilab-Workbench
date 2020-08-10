function [q]=quantile(x,p,method)
q=[];
[nargout,nargin] = argn(0)
//QUANTILE Empirical quantile (percentile).
//
//         q = quantile(x,p)
//	Input	x	vector or matrix of reals
//		p	probability (scalar or vector of probabilities numbers)
//
//	Output	q 	the empirical quantile of the sample x, a value
//			that is greater than p percent of the values in x
//	  		If input x is a matrix then the quantile is 
//			computed for  every column. 
//			If p is a vector then q is a matrix, each line contain 
//			the quantiles  computed for a value of p
//			 
//	  The empirical quantile is computed by one of three ways
//	  determined by a third input argument (with default 1).
//
//	  1. Interpolation so that F(X_(k)) == (k-0.5)/n.
//	  2. Interpolation so that F(X_(k)) == k/(n+1).
//	  3. Based on the empirical distribution.
//

//       Anders Holtsberg, 27-07-95
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud

if nargin<3 then
  method = 1;
end
if min(size(x))==1 then
  x = x(:);
  %v1=size(p)
  q = zeros(%v1(1),%v1(2));
else
  q = zeros(mtlb_length(p),size(x,2));
end
if min(size(p))>1 then
  error('Not matrix p input');
end
if mtlb_any(p>1|p<0) then
  error('Input p is not probability');
end
 
%v = x
if min(size(%v))==1 then %v=sort(%v),else %v=sort(%v,'r'),end
x = %v($:-1:1,:);
p = p(:);
n = size(x,1);
if method==3 then
// Must improve this ...
// qq = mean([x(ceil(min(max(1,p*n),n)),:); x(floor(min(max(1,p*n),n)+1),:)]);
qq = mtlb_mean([x(ceil(min(max(1,p*n),n)),:);x(floor(min(max(1,p*n),n)+1))']);
else
  x = [x(1,:);x;x(n,:)];
  if method==2 then
    // This method is from Hjort's """"Computer
    // intensive statistical methods"""" page 102
    i = p*(n+1)+1;
  else
    // Method 1
    i = p*n+1.5;
  end
  iu = ceil(i);
  il = floor(i);
  d = (i-il)*ones(1,size(x,2));
  qq = x(il,:) .* (1-d)+x(iu,:) .* d;
end
 
q(:) = qq;
 
