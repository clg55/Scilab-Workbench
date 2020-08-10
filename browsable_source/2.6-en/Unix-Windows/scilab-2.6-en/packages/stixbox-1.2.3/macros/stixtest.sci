function []=stixtest()
// 
// STIXTEST Demonstrate more stixbox routines.

//        J. Coursol, 1998
//        Copyright (c) Mathematique Universite de Paris-Sud

// 	Revision 01-10-98 Mathematique Universite de Paris-Sud
disp('When paused with -->halt() enter return key to continue')
halt()
n=10000;
y=1:10000;
z=y/2000;
y=y/10000;
                      // ++TBD     echo off
modele='exp';
for lambda=1:2
  x=-sort(-rexpweib(n,lambda));  
  F=1-exp(-lambda*z);
modele 
lambda
  stairs(x,y);
  halt()
		      // ++TBD     hold on
  plot2d(z,F,[5],"100",'r@ @ ')
  		      // ++TBD     hold off
  halt()
end

modele='normal 0 1';

randType=rand('info'); // save current mode for random generator
rand('normal');        // switch normal distribution with mean 0 and variance 1
x=-sort(-rand(n,1));
rand(randType);        // restore rand mode

F=pnorm(z);
modele
stairs(x,y);
halt()
		      // ++TBD    hold on
  plot2d(z,F,[5],"100",'r@ @ ')
		      // ++TBD    hold off
halt()

modele='chisq 5';
pp=5;
qq=pp/2;
x=-sort(-2*rjgamma(n,qq));
F=pchisq(2*z,pp);
modele
stairs(x,y);
halt()
		      // ++TBD    hold on
  plot2d(2*z,F,[5],"100",'r@ @ ')
		      // ++TBD    hold off
halt()
modele='chisq 5';
pp=5;
qq=pp/2;
x=-sort(-2*rjgamma(n,qq));
F=pchisq(2*z,pp);
modele
stairs(x,y);
halt()
		      // ++TBD    hold on
  plot2d(2*z,F,[5],"100",'r@ @ ')
		      // ++TBD    hold off
halt()

modele='fisher 4 8';
x=-sort(-rf(n,4,8));
F=pf(z,4,8);
modele
stairs(x,y);
		      // ++TBD    hold on
  plot2d(z,F,[5],"100",'r@ @ ')
		      // ++TBD    hold off
halt()

modele='student 5';
// x=sort(rt(n,5));
F=pt(z,5);
modele
//stairs(x,y);
 halt()
                      // hold on
  xbasc();
  plot2d(z,F,[5],"121",'r@ @ ')
		      // ++TBD    hold off
halt()

modele='hypergeom 10 20 50';
x=-sort(-rhypg(n,10,20,50));
F=phypg(z,10,20,50);
modele
stairs(x,y);
halt()
		      // ++TBD    hold on
  plot2d(z,F,[5],"100",'r@ @ ')
		      // ++TBD    hold off
halt()

modele='binomiale';
x=-sort(-rjbinom(n,20,.3));
F=pbinom(2*z,20,.3);
modele
stairs(x,y);
halt()
		      // ++TBD    hold on
  plot2d(2*z,F,[5],"100",'r@ @ ')
		      // ++TBD    hold off
halt()

modele='poisson';
for lambda=[.5 1 2 3]
  x=-sort(-rpoiss(n,lambda));
  m= maxi(x);
  zz=[0,z];
  zz1=bool2s(round(zz)==zz);
  F=cumsum(exp(-lambda+zz.*log(lambda)-gammaln(zz+1)).*zz1);
modele
lambda
  stairs(x,y);
  halt()
  xbasc()
		      // ++TBD      hold on
  plot2d(zz,F,[5],"121",'r@ @ ')
		      // ++TBD      hold off
end;
//
disp('==================FIN DU TEST=====================');





