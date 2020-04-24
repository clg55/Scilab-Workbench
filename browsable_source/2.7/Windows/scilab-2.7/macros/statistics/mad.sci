function [s2]=mad(x,orien)
//
//This function   computes the mean  absolute  deviation of a  vector or
//matrix x.
//
//For  a vector or  matrix x,  s2=mad(x)  returns in scalar s2  the mean
//absolute deviation of all the entries of x.
//
//s2=mad(x,'r')(or, equivalently,  s2=mad(x,1)) returns in each entry of
//the column vector s2 the mean absolute deviation of each column of x.
//
//s2=mad(x,'c')(or, equivalently, s2=mad(x,2))  returns in each entry of
//the column vector s2 the mean absolute deviation of each row of x.
//
//Reference: Wonacott  T.H.& Wonacott  R.J. .-  Introductory Statistics,
//5th edition, John Wiley, 1990.
//
//References:  Wonacott, T.H. & Wonacott, R.J.; Introductory
//Statistics, J.Wiley & Sons, 1990.
//
//author: carlos klimann
//
//date: 1999-06-11
//
  if x==[] then s2=%nan, return, end
  [lhs,rhs]=argn(0)
  [nrow,ncol] = size(x);
  if rhs==1 then
    s2=sum(abs(x-mean(x)))/(nrow*ncol)
    return
  elsef rhs==2 then
    if orien=='r'|orien==1 then
      s2=sum(abs(x-(ones(nrow,1)*mean(x,1))),1)/nrow
    elseif orien=='c'|orien==1 then
      s2=sum(abs(x-(mean(x,2)*ones(1,ncol))),2)/ncol
    else 
      error('The second input parameter must be ''r'', ''c'', 1 or 2')
    end
  else
    error('mad requires one or two inputs.')
  end
endfunction
