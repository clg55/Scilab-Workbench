clear;lines(0);
s=poly(0,'s');NUM=[1+s,s];den=s^2-5*s+1;
sl=cont_frm(NUM,den); 
slss=ss2tf(sl);       //Compare with NUM/den
