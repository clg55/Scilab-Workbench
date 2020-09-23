//FICHIER_DE_TEST ADD NAME=bezout.tst,SSI=0
mode(5)
//test
un=poly(1,'s','c');
zer=0*un;
s=poly(0,'s');
[p,q]=bezout(un,s);
if norm(coeff([un s]*q-[p 0]))>10*%eps then pause,end
[p,q]=bezout(s,un);
if norm(coeff([s un]*q-[p 0]))>10*%eps then pause,end
[p,q]=bezout(un,un);
if norm(coeff([un un]*q-[p 0]))>10*%eps then pause,end
//
[p,q]=bezout(zer,s);
if norm(coeff([zer s]*q-[p 0]))>10*%eps then pause,end
[p,q]=bezout(s,zer);
if norm(coeff([s zer]*q-[p 0]))>10*%eps then pause,end
[p,q]=bezout(zer,zer);
if norm(coeff([zer zer]*q-[p 0]))>10*%eps then pause,end
//
[p,q]=bezout(zer,un);
if norm(coeff([zer un]*q-[p 0]))>10*%eps then pause,end
[p,q]=bezout(un,zer);
if norm(coeff([un zer]*q-[p 0]))>10*%eps then pause,end
//
 
//simple
a=poly([1 2 3],'z');
b=poly([4 1],'z');
 
[p q]=bezout(a,b);
dt=q(1,1)*q(2,2)-q(1,2)*q(2,1);dt0=coeff(dt,0);
if norm(coeff(dt/dt0-1))>10*%eps then pause,end
qi=[q(2,2) -q(1,2);-q(2,1) q(1,1)]/dt0;
if norm(coeff([p 0]*qi-[a b]))>100*%eps then pause,end
 
//more difficult
 
b1=poly([4 1+1000*%eps],'z');del=10*norm(coeff(b1-b));
[p,q]=bezout(a,b1);
dt=q(1,1)*q(2,2)-q(1,2)*q(2,1);dt0=coeff(dt,0);
if norm(coeff(dt/dt0-1))>del then pause,end
qi=[q(2,2) -q(1,2);-q(2,1) q(1,1)]/dt0;
if norm(coeff([p 0]*qi-[a b1]))>del then pause,end
 
b1=poly([4 1+.001],'z');del=10*norm(coeff(b1-b));
[p,q]=bezout(a,b1);
dt=q(1,1)*q(2,2)-q(1,2)*q(2,1);dt0=coeff(dt,0);
if norm(coeff(dt/dt0-1))>100000*%eps then pause,end
qi=[q(2,2) -q(1,2);-q(2,1) q(1,1)]/dt0;
if norm(coeff([p 0]*qi-[a b1]))>100000*%eps then pause,end
 
 
b1=poly([4 1+10000*%eps],'z');del=10*norm(coeff(b1-b));
[p,q]=bezout(a,b1);
dt=q(1,1)*q(2,2)-q(1,2)*q(2,1);dt0=coeff(dt,0);
if norm(coeff(dt/dt0-1))>del then pause,end
qi=[q(2,2) -q(1,2);-q(2,1) q(1,1)]/dt0;
if norm(coeff([p 0]*qi-[a b1]))>del then pause,end
//
z=poly(0,'z');
num = 0.99999999999999922+z*(-4.24619123578530730+..
      z*(10.0503215227460350+z*(-14.6836461849931740+..
      z*(13.924822877119892+z*(-5.63165998008533460+..
      z*(-5.63165998008530710+z*(13.9248228771198730+..
      z*(-14.683646184993167+z*(10.0503215227460330+..
      z*(-4.24619123578530910+z*(0.99999999999999989)))))))))));
den = -0.17323463717888873+z*(1.91435457459735380+..
      z*(-9.90126732768255560+z*(31.6286096652930410+..
      z*(-69.3385546880304280+z*(109.586435800377690+..
      z*(-127.516160100808290+z*(109.388684898145950+..
      z*(-67.92645394857864+z*(29.1602681026148110+..
      z*(-7.8212498781094952+z*(0.99999999999999989)))))))))));
//
[p,q]=bezout(num,den);del=1.d-4;
dt=q(1,1)*q(2,2)-q(1,2)*q(2,1);dt0=coeff(dt,0);
if norm(coeff(dt/dt0-1))>del then pause,end
qi=[q(2,2) -q(1,2);-q(2,1) q(1,1)]/dt0;
// JPC 
del=3*del
if norm(coeff([p 0]*qi-[num den]))>del then pause,end
if degree(p)>0 then pause,end
// une autre "solution" telle que l'erreur directe est petite mais l'erreur
// inverse grande
q1=[]
q1(1,1)=poly([0.011533588674 , 3.570224012502 , -28.78817740957 ,...
            102.9479419903, -210.8258579715 , 266.2028963639 ,...
           -207.427018299 , 92.74478640319, -18.5259652457],'z','c');
q1(1,2)=poly([0.000270220664 , -0.002465565223 , 0.010039706635 ,...
           -0.023913827007, 0.036387144032 , -0.036175176058 ,...
            0.022954475171 , -0.008514798968,  0.001417382492],'z','c');
q1(2,1)=poly([0.000639302018 , 20.502472606 , -26.66621972106 ,...
            39.74001534015,  -5.945830824342 , -7.973226036298 ,...
            39.84118622788 , -26.51337424414, 18.5259652457],'z','c');
q1(2,2) =poly( [0.001562930385 , -0.003589174974 , 0.005076237479 ,...
            -0.003483568682,  -0.000135940266 , 0.003651509121 ,...
            -0.005059502869 , 0.003447573440, -0.001417382492],'z','c');
p1 =poly( [0.011422839421 , -0.029264363070 , 0.030070175223 ,...
         -0.012596066108],'z','c');
 
//
//simplification
num =[0.03398330733500143,-0.20716057008572933,0.64660689206696986,...
     -1.97665462134021790,3.38751027286891300,-3.58940006392108120,...
      5.09956159043231680,5.2514918861834694,1.00000000000000020];
den = [0.03398330733500360,-0.20716057008816283,0.64660689204312,...
      -1.97665462079896660,3.38751027286891300,-3.58940006392108350,...
       5.09956159043232040,5.2514918861834712,1];
num=poly(num,'z','c');
den=poly(den,'z','c');
[p,q]=bezout(num,den);del=1.d-8;
dt=q(1,1)*q(2,2)-q(1,2)*q(2,1);dt0=coeff(dt,0);
if norm(coeff(dt/dt0-1))>del then pause,end
qi=[q(2,2) -q(1,2);-q(2,1) q(1,1)]/dt0;
if norm(coeff([p 0]*qi-[num den]))>del then pause,end
if degree(p)<8 then pause,end
