function [s]=%lssslss(s1,s2)
//s=%lssslss(s1,s2) <=> s=s1-s2
// s1, s2: syslin lists
//!
[s1 s2]=sysconv(s1,s2)
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
[a2,b2,c2,d2,x2]=s2(2:6)
[n1,n1]=size(a1);[n2,n2]=size(a2);
a1=[a1,0*ones(n1,n2);0*ones(n2,n1),a2];
s=tlist(['lss','A','B','C','D','X0','dt'],a1,[b1;-b2],[c1 c2],d1-d2,[x1;x2],dom1)



