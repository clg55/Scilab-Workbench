//[hzt]=trans(pd,zd,gd,tr_type,frq)
//hzt=trans(pd,zd,gd,tr_type,frq)
//macro for transforming standardized low-pass filter into
//one of the following filters:
//     low-pass, high-pass, band-pass, stop-band.
// hz      :input polynomial
// tr_type :type of transformation
// frq     :frequency values
// hzt     :output polynomial
//!
//author: C. Bunks  date: 9 Sept 1988
// correction : Masse john date: 14 April 1992.
   z=poly(0,'z');
   fc=.25;
   fu=frq(1);
   fl=frq(2);

//make filter type using all-pass change of variables

   select tr_type
   case 'lp' then
      alpha=sin(%pi*(fc-fu))/sin(%pi*(fc+fu));
       num=z-alpha;
      den=1-alpha*z;
   case 'hp' then
// correction       alpha=-cos(%pi*(fc-fu))/cos(%pi*(fc+fu));
       alpha=-cos(%pi*(fc+fu))/cos(%pi*(fc-fu));
       num=-(z+alpha);
       den=1+alpha*z;
   case 'bp' then
      k=tan(%pi*fc)/tan(%pi*(fu-fl));
      alpha=cos(%pi*(fu+fl))/cos(%pi*(fu-fl));
      num=-((k+1)*z**2-2*alpha*k*z+(k-1));
      den=(k+1)-2*alpha*k*z+(k-1)*z**2;
   case 'sb' then
      k=tan(%pi*fc)*tan(%pi*(fu-fl));
      alpha=cos(%pi*(fu+fl))/cos(%pi*(fu-fl));
      num=(k+1)*z**2-2*alpha*z+(1-k);
      den=(k+1)-2*alpha*z+(1-k)*z**2;
   else
      error('Unknown filter type --- program termination'),
   end
   [pt,zt,gt]=bilt(pd,zd,gd,num,den);
   hzt=gt*real(poly(zt,'z'))./real(poly(pt,'z'));

//end
