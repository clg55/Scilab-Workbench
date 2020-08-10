function [tt]=texprint(a)
// text = texprint(a) returns the Tex source code of the scilab variable a.
// a is a matrix (scalar, polynomial, rational) or a linear system
// (syslin list).
//!
//
// Copyright INRIA
debut='\begin{array}{l}';fin='\end{array}'
typ=type(a)

//-compat next row added for list/tlist compatibility
if typ==15 then typ=16,end
select typ
case 1 then  //scalars
  [m,n]=size(a)
  if m*n<>1 then tt='{\pmatrix{',else tt='{{',end
  if norm(imag(a))<=%eps*norm(real(a)) then
// matrice reelle
     a=string(real(a))
     for l=1:m,
       tt=tt+a(l,1)
       for k=2:n,tt=tt+'&'+a(l,k),end
       tt=tt+'\cr '
     end
     tt=part(tt,1:length(tt)-4)+'}}'
   else
       for l=1:m,
       tt=tt+cstring(a(l,1))
       for k=2:n,tt=tt+'&'+cstring(a(l,k)),end
       tt=tt+'\cr '
     end
     tt=part(tt,1:length(tt)-4)+'}}'
   end
case 2 then //polynomials
   [m,n]=size(a)
   if m*n<>1 then tt='{\pmatrix{',else tt='{{',end
   z=varn(a)
   nz=1;while part(z,nz)<>' ' then nz=nz+1,end
   z=part(z,1:nz-1)
//
   for l=1:m
     for k=1:n,tt=tt+pol2tex(a(l,k))+'&',end
     tt=part(tt,1:length(tt)-1)+'\cr '
   end
   tt=part(tt,1:length(tt)-4)+'}}'
case 10 then //strings
  [m,n]=size(a)
  if m*n<>1 then tt='{\pmatrix{',else tt='{{',end
     for l=1:m,
       tt=tt+a(l,1)
       for k=2:n,tt=tt+'&'+a(l,k),end
       tt=tt+'\cr '
     end
     tt=part(tt,1:length(tt)-4)+'}}'
 
case 16 then 
     a1=a(1)//transfer and linear systems
  select a1(1)
    case 'r' then //rationals
     num=a(2);a=a(3)
     [m,n]=size(a)
     if m*n<>1 then tt='{\pmatrix{',else tt='{{',end
     z=varn(a)
     nz=1;while part(z,nz)<>' ' then nz=nz+1,end
     z=part(z,1:nz-1)
//
     for l=1:m
       for k=1:n,
         if degree(a(l,k))==0 then
            num(l,k)=num(l,k)/coeff(a(l,k)),pol=1
         else
            pol=0
         end
         nlk=pol2tex(num(l,k));
         if nlk=='0' then
            tt=tt+'0&'
         else
           if pol==1 then
             tt=tt+nlk+'&'
           else
             dlk=pol2tex(a(l,k))
             tt=tt+'{'+nlk+'}\over{'+dlk+'}&',
           end
         end
       end
       tt=part(tt,1:length(tt)-1)+'\cr '
     end
     tt=part(tt,1:length(tt)-4)+'}}'
    case 'lss' //linear state space
     if a(7)=='c' then der=' \dot{x}',else der=' \stackrel{+}{X}',end
     tt=debut+der+' = '+texprint(a(2))+' X + '+...
         texprint(a(3))+'U \\ \\ Y = '+texprint(a(4))+' X '
     if norm(a(5),1)==0 then
       tt=tt+fin
     else
       tt=tt+' + '+texprint(a(5))+fin
     end
  end
 
end



