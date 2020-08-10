function [Si,Pi,Di,order]=penlaur(E,A)
//[Si,Pi,Di,order]=penlaur(E,A)
// First Laurent coefficients of (s*E-A)^-1;
// (s*E-A)^-1 = ... + Si/s - (Pi + s*Di + ... +s^order Ni) at s = infinity
// order = order of the singularity
// The matrix s*E-A should be invertible.
// F.D. (1988,1990) (Experimental version: troubles when bad conditioning of
// (so*E-A)...)
//!
[LHS,RHS]=argn(0);
if RHS==1 then [E,A]=pen2ea(E);end
rand('normal')
tests=rand(1,10);
conditions=0*tests;k=1;
for s0=tests, conditions(k)=cond(s0*E-A);k=k+1;end
[w,k1]=mini(conditions);
if w>1.d+20 then error('Singular pencil!');return;end
s0=tests(k1);
J=inv(s0*E-A);
[Se,Pe,De,i1]=projspec(J*E);
[Sa,Pa,Da,i2]=projspec(J*A);
order=i1-1;
Si=Se*J;
Pi=Pe*Sa*J;
Di=Pi*E*Pi;
if order=0 then Di=0*Di;end
//[S,P,D,index]=projspec(Di*E);
