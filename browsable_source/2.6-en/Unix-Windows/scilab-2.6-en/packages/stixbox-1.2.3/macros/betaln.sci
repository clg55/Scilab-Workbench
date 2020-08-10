function [y]=betaln(z,w)
  y = gammaln(z)+gammaln(w)-gammaln(z+w);
endfunction 
