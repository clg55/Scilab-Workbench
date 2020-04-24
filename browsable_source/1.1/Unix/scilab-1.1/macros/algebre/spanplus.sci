function [X,dim,dima]=spanplus(A,B,tol)
//[X,dim,dima]=spanplus(A,B,tol) computes an orthogonal basis of
// a+b such that : the first dima columns of x span Range(A)
// and the following (dim-dima) columns make a basis of a+b
// relative to a. tol is an optional argument.
// The dim first columns of x make a basis for A+B.
//F.D.
//!
[na,ma]=size(a);[nb,mb]=size(b);
[lhs,rhs]=argn(0);
if rhs=2 then tol=%eps*na*nb*ma*mb;end
if na<>nb then error('uncompatible dimensions!'),end
[x,dima]=rowcomp(a);
b=x*b;x=x'    //update b,x
if dima = na then dim=dima,return,end;
low=(dima+1):na;
blow=b(low,:);
if norm(blow,1) <= tol*norm(b,1),dim=dima,return,end
[u2,r2]=rowcomp(blow);
dim=dima+r2;
x(:,low)=x(:,low)*u2';    //update



