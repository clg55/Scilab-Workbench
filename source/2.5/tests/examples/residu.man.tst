clear;lines(0);
s=poly(0,'s');
H=[s/(s+1)^2,1/(s+2)];N=numer(H);D=denom(H);
w=residu(N.*horner(N,-s),D,horner(D,-s));  //N(s) N(-s) / D(s) D(-s)
sqrt(sum(w))  //This is H2 norm
h2norm(tf2ss(H))
//
p=(s-1)*(s+1)*(s+2)*(s+10);a=(s-5)*(s-1)*(s*s)*((s+1/2)**2);
b=(s-3)*(s+2/5)*(s+3);
residu(p,a,b)+531863/4410    //Exact
z=poly(0,'z');a=z^3+0.7*z^2+0.5*z-0.3;b=z^3+0.3*z^2+0.2*z+0.1;
atild=gtild(a,'d');btild=gtild(b,'d');
residu(b*btild,z*a,atild)-2.9488038   //Exact
a=a+0*%i;b=b+0*%i;
real(residu(b*btild,z*a,atild)-2.9488038) //Complex case
