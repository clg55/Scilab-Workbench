function xwait()
  while %t
    if xclick()&winsid()==[] ;break,end
  end;
endfunction;
