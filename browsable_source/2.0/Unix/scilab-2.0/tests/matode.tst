Leps=1.e-6;
//     definition of rhs
deff('[ydot]=f(t,y)',...
   'f1=-0.04*y(1)+1e4*y(2)*y(3),...
    f3=3e7*y(2)*y(2),...
    ydot=[f1;-f1-f3;f3]')
//     jacobian
deff('[jac]=j(t,y)',..
'jac(1,1)=-0.04;jac(1,2)=1.e4*y(3);jac(1,3)=1.e4*y(2),...
 jac(3,1)=0;jac(3,2)=6.e7*y(2);jac(3,3)=0;...
 jac(2,1)=-jac(1,1);jac(2,2)=-jac(1,2)-jac(3,2);jac(2,3)=-jac(1,3);')
//    
y0=[1;0;0];t0=0;t1=[0.4,4];
//    solution 
yref=[0.9851721 0.9055180;0.0000339 0.0000224;0.0147940 0.0944596];
//  1. fortran called by fydot,without jacobian
y1=ode(y0,t0,t1,'fex');
if maxi(y1-yref) > Leps then pause,end
//  2. fortran called by fydot,type given (stiff),no jacobian
y2=ode('stiff',y0,t0,t1,'fex');
if maxi(y2-yref) > Leps then pause,end
//  3. fortran called by fydot , fjac,type given
y3=ode('stiff',y0,t0,t1,'fex','jex');
if maxi(y3-yref) > Leps then pause,end
//   hot restart
[z,w,iw]=ode('stiff',y0,0,0.4,'fex','jex');
z=ode('stiff',z,0.4,4,'fex','jex',w,iw);
if maxi(z-y3(:,2)) > %eps then pause,end
//   variation of tolerances
atol=[0.001,0.0001,0.001];rtol=atol;
//    externals 
comp(f),comp(j)
//  4. type given , scilab lhs ,jacobian not passed
y4=ode('stiff',y0,t0,t1(1),atol,rtol,f);
if maxi(y4(:,1)-yref(:,1)) > 0.01 then pause,end
//  5. type non given, rhs and scilab jacobian
y5=ode(y0,t0,t1,f,j);
if maxi(y5-yref) > Leps then pause,end
//  6. type given (stiff),rhs and jacobian  by scilab
y6=ode('stiff',y0,t0,t1,0.00001,0.00001,f,j);
if (y6-yref) > 2*0.00001 then pause,end
//  7. matrix rhs, type given(adams),jacobian not passed
// 
a=rand(3,3);ea=exp(a);
deff('[ydot]=f(t,y)','ydot=a*y')
comp(f);
t1=1;y=ode('adams',eye(a),t0,t1,f);
if maxi(ea-y) > Leps then pause,end
//   DAE's
// scilab macros
deff('[r]=resid(t,y,s)','...
r(1)=-.04d0*y(1)+1.d4*y(2)*y(3)-s(1),...
r(2)=.04d0*y(1)-1.d4*y(2)*y(3)-3.d7*y(2)*y(2)-s(2),...
r(3)=y(1)+y(2)+y(3)-1.d0')
deff('[p]=aplusp(t,y,p)','...
p(1,1)=p(1,1)+1.d0,...
p(2,2)=p(2,2)+1.d0')
deff('[p]=dgbydy(t,y,s)','...
p(1,1)=-.04d0,...
p(1,2)=1.d4*y(3),...
p(1,3)=1.d4*y(2),...
p(2,1)=.04d0,...
p(2,2)=-1.d4*y(3)-6.d7*y(2),...
p(2,3)=-1.d4*y(2),...
p(3,1)=1.d0,...
p(3,2)=1.d0,...
p(3,3)=1.d0')
comp(resid);comp(aplusp);comp(dgbydy);
//         calling scilab
//  
yt=impl([1;0;0],[-.04;.04;0],0,0.4,resid,aplusp,dgbydy);
//  
r1=yt-impl([1;0;0],[-0.04;0.04;0],0,0.4,resid,aplusp);
if abs(r1) > 1.e-10 then pause,end
//   calling fortran
r2=yt-impl([1;0;0],[-0.04;0.04;0],0,0.4,'resid','aplusp');
if abs(r2) > 1.e-10 then pause,end



