//[s]=%rflss(s1,s2)
//[s]=%rflss(s1,s2) calcule la concatenation d'une matrice de transfert
//s1 et d'un systeme lineaire decrit par sa representation d'etat s2.
//      y=[s1*u;y2]
//Cette macro correspond a l'operation [s1;s2]
//!
// origine s. steer inria 1987
//
[s1,s2]=sysconv(s1,s2);s=[s1;s2]
//end


