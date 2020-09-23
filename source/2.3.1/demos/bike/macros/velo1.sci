function []=velo1()
// "full wheel" version
ct=-cos(t);cp=cos(p);st=-sin(t);sp=sin(p);
  xe=[xmin;xmax;xmax;xmin;xmin]
  ye=[ymin;ymin;ymax;ymax;ymin]
  ze=[zmin;zmin;zmin;zmin;zmin];
  xer=ct*xe-st*ye;
  yer=cp*(st*xe+ct*ye)+sp*ze;
  isoview(mini(xer),maxi(xer),mini(yer),maxi(yer));
  xpoly(xer,yer,'lines')

[n1,n2]=size(xfrontar);
xset("alufunction",6)
deff('[]=velod(i)',['xnr=ct*xfrontar(:,i)-st*yfrontar(:,i);';
      'ynr=cp*(st*xfrontar(:,i)+ct*yfrontar(:,i))+sp*zfrontar(:,i);';
      'xnt=ct*xf(:,i)-st*yf(:,i);';
      'ynt=cp*(st*xf(:,i)+ct*yf(:,i))+sp*zf(:,i);';
      'xnf=ct*xrearar(:,i)-st*yrearar(:,i),';
      'ynf=cp*(st*xrearar(:,i)+ct*yrearar(:,i))+sp*zrearar(:,i);';
      'xpoly(xnt,ynt,''lines'')';
      'xfpoly(xnr,ynr)';
      'xfpoly(xnf,ynf)']);

xset('thickness',2); 
for i=1:n2-1,velod(i);ww=i:i+1;
plot2d((ct*xprear(1,ww)-st*xprear(2,ww))',...
     (cp*(st*xprear(1,ww)+ct*xprear(2,ww))+sp*xprear(3,ww))',...
     [1,-1],"000");
velod(i);
end
velod(n2-1);
xset("alufunction",3);
xset('thickness',1);


