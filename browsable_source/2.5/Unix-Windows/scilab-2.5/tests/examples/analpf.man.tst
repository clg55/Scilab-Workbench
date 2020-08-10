clear;lines(0);
//Evaluate magnitude response of continuous-time system 
hs=analpf(4,'cheb1',[.1 0],5)
fr=0:.1:15;
hf=freq(hs(2),hs(3),%i*fr);
hm=abs(hf);
plot(fr,hm)
