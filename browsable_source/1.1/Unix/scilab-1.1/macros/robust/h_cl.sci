function [A#]=H_cl(P,r,K)
//[A#]=H_cl(P,r,K)
//Given the standard plant P (with r=size(P22)) and the controller
//K (computed e.g. by H_inf) this macro returns the closed loop
//matrix A# whose poles allows to checks the internal stability
//of the closed loop system.
//A# is the A matrix of [I -P22;-K I]^-1;
//!
//FD.
if P(1)='r' then P=tf2ss(P);end
if K(1)='r' then K=tf2ss(K);end
[LHS,RHS]=argn(0);
if RHS==3 then
[A,B1,B2,C1,C2,D11,D12,D21,D22]=smga(P,r);
end
if RHS==2 then
[A,B2,C2,D22]=P(2:5);K=r;
end
//if type(K)=1 then [ny,nu]=size(K),Ac=0;Bc=0*ones(1,nu);Cc=0*ones(ny,1);Dc=K;
[Ac,Bc,Cc,Dc]=K(2:5);
[n,p]=size(B2);[ndc1,ndc2]=size(Dc);[nd1,nd2]=size(d22);
[m,q]=size(Bc);
Bw=[B2,0*ones(n,ndc2);
    0*ones(m,p),Bc];
[n1,m2]=size(Cc);
[n2,m1]=size(C2);
Cw=[0*ones(ndc1,m1),Cc;
    C2,0*ones(n2,m2)];
A#=[A, 0*ones(n,m);
    0*ones(m,n),Ac]+...
    Bw*inv([eye(ndc1,ndc1),-Dc;-D22,eye(nd1,nd1)])*Cw;



