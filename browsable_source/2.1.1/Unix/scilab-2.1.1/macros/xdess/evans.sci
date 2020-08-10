function []=evans(n,d,kmax)
//seuil maxi et mini (relatifs) de discretisation
// en espace
smax=0.01;smin=smax/3;
nptmax=500 //nbre maxi de pt de discretisation en k
//
//analyse de la liste d'appel
[lhs,rhs]=argn(0)
select type(n)
  case 1  then
    if rhs=2 then kmax=0,end
  case 2  then
    if rhs=2 then kmax=0,end
  case 15 then
     if rhs=2 then kmax=d,else kmax=0,end
     select n(1)
        case 'r' then [n,d]=n(2:3)
        case 'lss' then n=ss2tf(n);[n,d]=n(2:3)
        else error('transfer or state-space only')
     end
  else error('transfer or state-space only')
end
if prod(size(n))<>1 then
    error('SISO system only'),
end
if kmax<=0 then
     nm=mini([degree(n),degree(d)])
     fact=norm(coeff(d),2)/norm(coeff(n),2)
     kmax=round(500*fact),
end
//
//calcul de la discretisation en k et racines associees
nroots=roots(n);racines=roots(d);
nrm=maxi([norm(racines,1),norm(nroots,1),norm(roots(d+kmax*n),1)])
md=degree(d)
//
ord=1:md;kk=0;nr=1;k=0;pas=0.99;fin='no';
while fin='no' then
k=k+pas
r=roots(d+k*n);r=r(ord)
dist=maxi(abs(racines(:,nr)-r))/nrm
//
point='nok'
if dist <smax then //pas correct
         point='ok'
              else //pas trop grand ou ordre incorrect
         // on cherche l'ordre qui minimise la distance
         ix=1:md
         ord1=[]
         for ky=1:md
           yy=r(ky)
           mn=10*dist*nrm
           for kx=1:md
             if ix(kx)>0 then
             if  abs(yy-racines(kx,nr)) < mn then
                  mn=abs(yy-racines(kx,nr))
                  kmn=kx
             end
             end
           end
           ix(kmn)=0
           ord1=[ord1 kmn]
         end
         r(ord1)=r
         dist=maxi(abs(racines(:,nr)-r))/nrm
         if dist <smax then
                          point='ok',
                          ord(ord1)=ord
                       else
                           k=k-pas,pas=pas/2.5
         end
end
if dist<smin then
    //pas trop petit
    pas=2*pas;
end
if point='ok' then
        racines=[racines,r];kk=[kk,k];nr=nr+1
        if k>kmax then fin='kmax',end
        if nr>nptmax then fin='nptmax',end
end
end
//taille du cadre graphique
       x1 =[nroots;matrix(racines,md*nr,1)];
       xmin=mini(real(x1));xmax=maxi(real(x1))
       ymin=mini(imag(x1));ymax=maxi(imag(x1))
       dx=abs(xmax-xmin)*0.05
       dy=abs(ymax-ymin)*0.05
       rect=[xmin-dx;ymin-dy;xmax+dx;ymax+dy];

dx=maxi(abs(xmax-xmin),abs(ymax-ymin));
//trace des lieux des zeros
xx=xget("mark")
xset("mark",xx(1),xx(1)+3);
plot2d(real(nroots),imag(nroots),[5,4],"111",...
    'open loop zeroes',rect);
xtitle('Evans root locus','Real axis','Imag. axis');
//trace des lieu des poles en boucle ouverte
plot2d(real(racines(:,1)),imag(racines(:,1)),[2,5],"111",...
     'open-loop poles',rect)
// trace des branches asymptotiques
plot2d(0,0,[-1,2],"100",'asymptotic directions');
xclip(rect(1),rect(4),rect(3)-rect(1),rect(4)-rect(2));
m=degree(n);q=md-m
if q>0 then
   la=0:q-1;
   so=(sum(racines(:,1))-sum(nroots))/q
   i1=real(so);i2=imag(so);
   if prod(size(la))<>1 then
       ang1=%pi/q*(ones(la)+2*la)
       x1=dx*cos(ang1),y1=dx*sin(ang1)
//     ang2=%pi/q*2*la
//     x2=dx*cos(ang2),y2=dx*sin(ang2)
            else
       x1=0,y1=0,//x2=0,y2=0,
   end
   if md=2,
       if coeff(d,md)<0 then
          x1=0*ones(2),y1=0*ones(2)
//        x2=0*ones(2),y2=0*ones(2),
       end,
   end;
   if maxi(k)>0 then
     for i=1:q,xsegs([i1,x1(i)+i1],[i2,y1(i)+i2]),end,
   end
// if mini(k)<0 then
//     for i=1:q,xsegs([i1,x2(i)+i1],[i2,y2(i)+i2]),end,
// end
end;
xclip();

//lieu de evans
[n1,n2]=size(racines);
  plot2d(real(racines)',imag(racines)',-3*ones(1,n2),"111",...
     'closed-loop poles loci',rect);
if fin='nptmax' then
  write(%io(2),'evans : too many points required')
end
xset("mark",xx(1),xx(2));



