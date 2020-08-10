clear;lines(0);
M=mlist(['V','name','value'],['a','b','c'],[1 2 3]);
//define display
deff('%V_p(M)','disp([M(''name'');string(M(''value''))])')
//define extraction operation
deff('r=%V_e(i,M)','r=mlist([''V'',''name'',''value''],M(''name'')(i),M(''value'')(i))')
//define M as a tlist
M=tlist(['V','name','value'],['a','b','c'],[1 2 3]);
M(2)
M('name')
