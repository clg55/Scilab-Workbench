clear;lines(0);
//Simple polynomial example
z=poly(0,'z');
p=(z-1/2)*(2-z)
w=sfact(p);
w*numer(horner(w,1/z))
//matrix example
F1=[z-1/2,z+1/2,z^2+2;1,z,-z;z^3+2*z,z,1/2-z];
P=F1*gtild(F1,'d');  //P is symmetric
F=sfact(P)    
roots(det(P))  
roots(det(gtild(F,'d')))  //The stable roots
roots(det(F))             //The antistable roots
clean(P-F*gtild(F,'d'))
//Example of continuous time use
s=poly(0,'s');
p=-3*(s+(1+%i))*(s+(1-%i))*(s+0.5)*(s-0.5)*(s-(1+%i))*(s-(1-%i));p=real(p);
//p(s) = polynomial in s^2 , looks for stable f such that p=f(s)*f(-s) 
w=horner(p,(1-s)/(1+s));  // bilinear transform w=p((1-s)/(1+s))
wn=numer(w);              //take the numerator
fn=sfact(wn);f=numer(horner(fn,(1-s)/(s+1))); //Factor and back transform
f=f/sqrt(horner(f*gtild(f,'c'),0));f=f*sqrt(horner(p,0));      //normalization
roots(f)    //f is stable
clean(f*gtild(f,'c')-p)    //f(s)*f(-s) is p(s) 
