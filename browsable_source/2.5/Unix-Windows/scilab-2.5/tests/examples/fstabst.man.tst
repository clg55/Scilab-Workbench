clear;lines(0);
ny=2;nu=3;nx=4;
P22=ssrand(ny,nu,nx);
bigQ=rand(nx+nu,nx+nu);bigQ=bigQ*bigQ';
bigR=rand(nx+ny,nx+ny);bigR=bigR*bigR';
[P,r]=lqg2stan(P22,bigQ,bigR);
J=fstabst(P,r);
Q=ssrand(nu,ny,1);Q('A')=-1;  //Stable Q
K=lft(J,r,Q);
A=h_cl(P,r,K); spec(A)
