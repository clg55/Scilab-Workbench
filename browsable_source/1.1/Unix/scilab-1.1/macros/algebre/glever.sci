function [Bfs,Bis,chis]=glever(E,A,s)
// [Bfs,Bis,chis]=glever(E,A,'s')
// Computation of (s*E-A)^-1 ('s'=character string with default value 's')
// Generelized Leverrier's algorithm for a matrix pencil ;
// (s*E-A)^-1 = (Bfs/chis) - Bis
// chis = characteristic polynomial (up to a multiplicative constant)
// Bfs  = polynomial matrix
// Bis  = polynomial matrix ( - expansion of (s*E-A)^-1 at infinity).
// Caveat: uses cleanp to simplify Bfs,Bis and chis !
// See also shuffle, determ, invr, coffg
// F.D. (1988)
//!
[LHS,RHS]=argn(0);
 
if RHS=2 then s=poly(0,'s'),else s=poly(0,s);end
[Si,Pi,Di,index]=penlaur(E,A);
k=round(sum(diag(Si*E)));

a0=1;
B=Si;
SiAsi=Si*A*Si;
chis=a0+0*s;
Bfs=Si+0*s*Si;
 
for i=1:k,
  B=SiASi*E*B;
  alfa=-sum(diag(E*B))/i;
  B=B+alfa*Si;
  chis=s*chis+alfa;
  if i<k then Bfs=s*Bfs+B;end
end
Bis=Pi;
AAD=s*A*Di;
P=eye(A);
 
for nu=1:index+1,
   P=AAD*P;
   Bis=cleanp(Bis+Pi*P,1.d-10);
end
Bfs=cleanp(Bfs,1.d-10);
chis=cleanp(chis,1.d-10);
 



