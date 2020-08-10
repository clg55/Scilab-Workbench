function [C,y]=stdjack(x,theta,p1,p2,p3,p4,p5,p6,p7,p8,p9)
C=[];y=[];
[nargout,nargin] = argn(0)
//STDJACK  Jackknife estimate of the standard deviation of a parameter
//	  estimate.
// 
//	  C = stdjack(X,'T')
//	
//	  The function is equal to sqrt(diag(covjack(X,'T')))
 
//       Anders Holtsberg, 28-02-95
//       Copyright (c) Anders Holtsberg
 
arglist = [];
for i = 3:nargin
  arglist = arglist+',p'+string(i-2);
end
 
C = sqrt(diag(evstr('covjack(x,theta'+arglist+')')));
