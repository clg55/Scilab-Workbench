C/MEMBR ADD NAME=WPODIV,SSI=0
      subroutine wpodiv(ar,ai,br,bi,na,nb  )
      implicit double precision (a-h,o-z)
      dimension ar(*),br(*),ai(*),bi(*)
c     division euclidienne de deux polynomes a coefficients complexes
c     le suffixe r designe la partie reelle et i la partie imaginaire
c
c     1. a: avant execution c'est le tableau des coefficients du
c    1polynome dividende range suivant les puissances croissantes
c    2de la variable (ordre na+1).
c    3apres execution,contient dans les nb premiers elements
c    4le tableau des coefficients du reste ordonne suivant les
c    5puissances croissantes, et dans les (na-nb+1) derniers elements,
c    6le tableau des coefficients du polynome quotient range suivant
c    7les puissances croissantes de la variable.
c     2. b: tableau des coefficients du polynome diviseur range suivant
c    1les puissances croissantes de la variable (ordre nb+1).
c     3. na: degre du polynome a.
c     4. nb: degre du polynome b.
c
      l=na-nb+1
    2 if(l)5,5,3
    3 n=l+nb
c      q=a(n)/b(nb+1)
      call wdiv(ar(n),ai(n),br(nb+1),bi(nb+1),qr,qi)
      nb1=nb+1
      do4 i=1,nb1
      n1=nb-i+2
      n2=n-i+1
c   4  a(n2)=a(n2)-b(n1)*q
      call wmul(br(n1),bi(n1),qr,qi,wr,wi)
      ar(n2)=ar(n2)-wr
      ai(n2)=ai(n2)-wi
    4 continue
      ar(n)=qr
      ai(n)=qi
      l=l-1
      goto 2
   5  continue
      return
      end
