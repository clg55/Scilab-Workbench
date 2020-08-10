clear;lines(0);
//Find x in R^6 such that:
//C1*x = b1 (3 equality constraints i.e mi=3)
C1= [1,-1,1,0,3,1;
    -1,0,-3,-4,5,6;
     2,5,3,0,1,0];
b1=[1;2;3];
//C2*x <= b2 (2 inequality constraints)
C2=[0,1,0,1,2,-1;
    -1,0,2,1,1,0];
b2=[-1;2.5];
//with  x between ci and cs:
ci=[-1000;-10000;0;-1000;-1000;-1000];cs=[10000;100;1.5;100;100;1000];
//and minimize 0.5*x'*Q*x + p'*x with
p=[1;2;3;4;5;6]; Q=eye(6,6);
//No initial point is given;
C=[C1;C2] ; //
b=[b1;b2] ;  //
mi=3;
[x,lagr,f]=quapro(Q,p,C,b,ci,cs,mi)
//Only linear constraints (1 to 4) are active (lagr(1:6)=0):
[x,lagr,f]=quapro(Q,p,C,b,[],[],mi)   //Same result as above
