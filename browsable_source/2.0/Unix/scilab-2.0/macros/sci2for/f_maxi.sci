//[stk,nwrk,txt,top]=f_maxi(nwrk)
//
//!
vnms,vtps;
select rhs
case 1 then
  s2=stk(top)
  stk=list(dvmax('+mulf(s2(4),s2(5))+','+s2(1)+',1)','0',s2(3),s2(4),s2(5))
case 2 then
  s2=stk(top);s1=stk(top-1);top=top-1
  if s2(4)=='1'&s2(5)=='1'&s1(4)=='1'&s1(5)=='1'then
    stk=list('max('+s1(1)+','+s2(1)+')','0',s2(3),'1','1')
  else
    warning('max with 2 matrix args: not implemented')
  end
else
  warning('max with more than 2 args. not implemented')
end
//end


