function [den]=denom(r)
//returns the denominator of a rational matrix 
//%Syntax: den=denom(r)
//with
//r: rational function matrix (may be polynomial or scalar matrix)
//den: polynomial matrix
//!
select type(r)
case 1 then
  den=ones(r);
case 2 then
  den=ones(r);
case 15 then
  if r(1)<>'r' then error(92,1),end
  den=r(3)
else
  error(92,1)
end

