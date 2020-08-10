function [x]=rt(n,df)
x=[];
//RT       Random numbers from the student t distribution (inversion method)
//
//         X = rt(n,d)
//	Input	n	positive integer or a 2-vector [lig, col] of 
//			positive integers
//		d	positive integer (degree of freedom)
//		X	n-vector or a n-matrix of random numbers 
//			chosen from the student distribution with d 
//			degrees of freedom

//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud

 
if or(mtlb_any(df<=0)) then
  error('Degrees Of Freedom is wrong');
end
 
if size(n)==1 then
  n = [n,1];
end
 
x = qt(mtlb_rand(n),df);
