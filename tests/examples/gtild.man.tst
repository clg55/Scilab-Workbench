clear;lines(0);
//Continuous time
s=poly(0,'s');G=[s,s^3;2+s^3,s^2-5]
Gt=gtild(G,'c')
Gt-horner(G,-s)'   //continuous-time interpretation
Gt=gtild(G,'d');
Gt-horner(G,1/s)'*s^3  //discrete-time interpretation
G=ssrand(2,2,3);Gt=gtild(G);   //State-space (G is cont. time by default)
clean((horner(ss2tf(G),-s))'-ss2tf(Gt))   //Check
// Discrete-time 
z=poly(0,'z');
Gss=ssrand(2,2,3);Gss('dt')='d'; //discrete-time
Gss(5)=[1,2;0,1];   //With a constant D matrix
G=ss2tf(Gss);Gt1=horner(G,1/z)';
Gt=gtild(Gss);
Gt2=clean(ss2tf(Gt)); clean(Gt1-Gt2)  //Check
//Improper systems
z=poly(0,'z');
Gss=ssrand(2,2,3);Gss(7)='d'; //discrete-time
Gss(5)=[z,z^2;1+z,3];    //D(z) is polynomial 
G=ss2tf(Gss);Gt1=horner(G,1/z)';  //Calculation in transfer form
Gt=gtild(Gss);    //..in state-space 
Gt2=clean(ss2tf(Gt));clean(Gt1-Gt2)  //Check
