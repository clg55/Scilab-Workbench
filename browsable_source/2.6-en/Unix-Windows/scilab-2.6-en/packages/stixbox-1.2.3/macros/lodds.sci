function [z]=lodds(p)
z=[];
//LODDS    Log odds function.
// 
//	  z = lodds(p)
// 
//	  The function is log(p/(1-p)).
 
//       Anders Holtsberg, 14-12-94
//       Copyright (c) Anders Holtsberg
 
if or(mtlb_any(abs(2*p-1)>=1)) then
  error('A probability input please');
end
z = log(p ./ (1-p));
