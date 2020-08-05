//test de la fonction rtitr
eps=100*%eps;
//
//siso
//----
//
//causal
//n1 scalaire
n1=1;d1=poly([1 1],'s','c');       // yj=y(j-1)+u(j-1)
r1=[0 1 0 1 0 1 0 1 0 1 0];
r=rtitr(n1,d1,ones(1,10));if norm(r1-r)>eps then pause,end
//redemarrage a chaud
r=rtitr(n1,d1,ones(1,9),1,0);if norm(r1(2:11)-r)>eps then pause,end
//n1 polynomial
n1=poly(1,'s','c');
r=rtitr(n1,d1,ones(1,10));if norm(r1-r)>eps then pause,end
//
r=rtitr(n1,d1,ones(1,9),1,0);if norm(r1(2:11)-r)>eps then pause,end
//
//non causal
n2=poly([1 1 1],'s','c');d2=d1;    // yj=-y(j-1)+u(j-1)+u(j)+u(j+1)
r2=[2 1 2 1 2 1 2 1 2];
r=rtitr(n2,d2,ones(1,10));if norm(r-r2)>eps then pause,end
//redemarrage a chaud
r=rtitr(n2,d2,ones(1,9),1,2);if norm(r2(2:9)-r)>eps then pause,end
//
//mimo
//----
//
//causal
d1=d1*diag([1 0.5]);n1=[1 3 1;2 4 1];r1=[5;14]*r1;
r=rtitr(n1,d1,ones(3,10));if norm(r1-r)>eps then pause,end
//
r=rtitr(n1,d1,ones(3,9),[1;1;1],[0;0]);if norm(r1(:,2:11)-r)>eps then pause,end
//n1 polynomial
n1(1,1)=poly(1,'s','c');
r=rtitr(n1,d1,ones(3,10));if norm(r1-r)>eps then pause,end
//
r=rtitr(n1,d1,ones(3,9),[1;1;1],[0;0]);if norm(r1(:,2:11)-r)>eps then pause,end
//non causal
d2=d1;n2=n2*n1;r2=[5;14]*r2;
r=rtitr(n2,d2,ones(3,10));if norm(r2-r)>eps then pause,end
//
r=rtitr(n2,d2,ones(3,9),[1;1;1],[10;28]);if norm(r2(:,2:9)-r)>eps then pause,end
 
//
  a = [0.21 , 0.63 , 0.56 , 0.23 , 0.31
       0.76 , 0.85 , 0.66 , 0.23 , 0.93
       0 , 0.69 , 0.73 , 0.22 , 0.21
       0.33 , 0.88 , 0.2 , 0.88 , 0.31
       0.67 , 0.07 , 0.54 , 0.65 , 0.36];
  b = [0.29 , 0.5 , 0.92
       0.57 , 0.44 , 0.04
       0.48 , 0.27 , 0.48
       0.33 , 0.63 , 0.26
       0.59 , 0.41 , 0.41];
  c = [0.28 , 0.78 , 0.11 , 0.15 , 0.84
       0.13 , 0.21 , 0.69 , 0.7 , 0.41];
  d = [0.41 , 0.11 , 0.56
       0.88 , 0.2 , 0.59];
s=syslin('d',a,b,c,d);
h=ss2tf(s);num=h(2);den=h(3);den=den(1,1)*eye(2);
u=1;u(3,10)=0;
r3=flts(u,h);
//r=rtitr(num,den,u);if norm(r3-r)>1000*eps then pause,end
 
 
