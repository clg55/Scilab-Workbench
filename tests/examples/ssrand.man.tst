clear;lines(0);
//flag=list('st',dim_cont_subs,dim_stab_subs,dim_stab0)  
//dim_cont_subs<=dim_stab_subs<=dim_stab0  
//pair (A,B) U-similar to:
//    [*,*,*,*;     [*;    
//    [0,s,*,*;     [0;
//A=  [0,0,i,*;   B=[0;
//    [0,0,0,u]     [0]
//     
// (A11,B1) controllable  s=stable matrix i=neutral matrix u=unstable matrix
[Sl,U]=ssrand(2,3,8,list('st',2,5,5));
w=ss2ss(Sl,inv(U)); //undo the random change of basis => form as above
[n,nc,u,sl]=st_ility(Sl);n,nc
