function [X]=rhypg(num,n,K,N)
X=[];
//RHYPGEO  Random numbers from the hypergeometric distribution
// 
//        X = rhypg(num,n,K,N)
 
//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg
 
if mtlb_length(num)==1 then
  num = [num,1];
end
X = qhypg(mtlb_rand(num),n,K,N);
 
 
