//<f>=%ssr(m,f)
// %ssr(m,f)  soustrait la  matrice de fractions rationnelles  f  a la
//matrice de scalaires m.
//Cette macro correspond a l'operation  m-f
//!
[t,n2,d2]=f(1:3),
if sum(size(m))=-2 then m=m*eye(d2); end;
[n2,d2]=simp(m.*d2-n2,d2)
f=list(t,n2,d2,f(4))
//end


