//[]=lotest(f_l,odem,xdim,npts,pinit)
//[]=lotest(f_l,[odem,xdim,npts,pinit])
// Integration of the lorentz system 
//!
[lhs,rhs]=argn(0);
if rhs <=3, npts=[1000,0.01],end;
if rhs <=2 then xdim=[-20,20,-30,30,0,50];end;
if rhs <=1, odem='default';end;
if rhs <=0, f_l='loren';end
x_message(["Integration of the lorentz equation";
          "1.e-8[1;1;1], is a good initial point"]);
if rhs <=4 then  portr3d(f_l,odem,xdim,npts);
else  portr3d(f_l,odem,xdim,npts,pinit);end
//end

//[y]=lorentz(t,x)
//[y]=lorentz(t,x)
// The lorentz system 
//!
y(1)=sig*(x(2)-x(1));
y(2)=ro*x(1) -x(2)-x(1)*x(3);
y(3)=-beta*x(3)+x(1)*x(2);
//end


//[]=ilo(sig,ro,beta)
//[]=ilo([sig,ro,beta])
// Initialisation des parametres sig ro et beta
// si aucun des arguments n'est fourni on utilise des valeurs
// par defaut
//!
[lhs,rhs]=argn(0)
if rhs=0,sig=10,ro=28,beta=8/3;end
[sig,ro,beta]=resume(sig,ro,beta)
//end


//[]=ilof(sig,ro,beta)
//[]=ilof([sig,ro,beta])
// Initialisation des parametres sig ro et beta
// si aucun des arguments n'est fourni on utilise des valeurs
// par defaut
//!
[lhs,rhs]=argn(0)
if rhs=0,sig=10,ro=28,beta=8/3;end;
fort('loset',sig,1,'r',ro,2,'r',beta,3,'r','sort');
//end


