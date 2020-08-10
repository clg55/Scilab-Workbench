function [C,y]=stdboot(x,theta,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
C=[];y=[];
[nargout,nargin] = argn(0)
//STDBOOT  Bootstrap estimate of the parameter standard deviation.
// 
//	  s = stdboot(X,'T')
//	
//         The function is equal to sqrt(diag(covboot(X,'T')))
// 
//	  See also STD, STDJACK, COVBOOT, and CIBOOT.
 
//       Anders Holtsberg, 02-03-95
//       Copyright (c) Anders Holtsberg
 
arglist = [];
for i = 3:nargin
  arglist = arglist+',p'+string(i-2);
end
 
execstr('[C,y] = covboot(x,theta'+arglist+')')

C = sqrt(diag(C));
