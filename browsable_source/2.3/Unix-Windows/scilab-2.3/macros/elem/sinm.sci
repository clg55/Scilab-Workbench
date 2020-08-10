function x=sinm(a)
//   sinm - computes the matrix sine 
//%CALLING SEQUENCE
//   x=sinm(a)
//%PARAMETERS
//   a   : square  matrix
//   x   : square  matrix
//!
if type(a)<>1 then error(53),end
if a==[] then x=[],return,end
if norm(imag(a),1)==0 then
  x=imag(expm(%i*a))
else
  x=-0.5*%i*(expm(%i*a)-expm(-%i*a));
end
