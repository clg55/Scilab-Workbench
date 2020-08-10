c      
c     SUBROUTINE ener
c      
c     Copyright INRIA
      subroutine ener(th,e)
        parameter (n=10)
        implicit doubleprecision (t)
        doubleprecision th(2*n),thd(n),et(1,1),r(n),j(n),m(n)
        integer i 
        data g / 9.81/
        data r / n*1.0/
        data m / n*1.0/
        data j / n*0.3/
c         
        do 1000, i =1,n ,1
          thd(i) = th(i+n)
 1000   continue
c       
      t1 = thd(1)**2
      t4 = thd(2)**2
      t7 = thd(3)**2
      t10 = thd(4)**2
      t13 = thd(5)**2
      t16 = thd(6)**2
      t19 = thd(7)**2
      t23 = thd(8)**2
      t26 = thd(9)**2
      t29 = thd(10)**2
      t32 = sin(th(7))
      t33 = r(7)*t32
      t34 = 2*t33
      t35 = sin(th(8))
      t36 = r(8)*t35
      t37 = 2*t36
      t38 = sin(th(1))
      t39 = r(1)*t38
      t40 = 2*t39
      t41 = sin(th(6))
      t42 = r(6)*t41
      t43 = 2*t42
      t44 = sin(th(5))
      t45 = r(5)*t44
      t46 = 2*t45
      t47 = sin(th(3))
      t48 = r(3)*t47
      t49 = 2*t48
      t50 = sin(th(2))
      t51 = r(2)*t50
      t52 = 2*t51
      t53 = sin(th(4))
      t54 = r(4)*t53
      t55 = 2*t54
      t56 = sin(th(9))
      t57 = r(9)*t56
      t63 = -2*r(1)*t38*thd(1)
      t65 = r(2)*t50*thd(2)
      t68 = (t63-t65)**2
      t69 = cos(th(1))
      t72 = 2*r(1)*t69*thd(1)
      t75 = r(2)*cos(th(2))*thd(2)
      t77 = (t72+t75)**2
      t84 = r(5)*t44*thd(5)
      t85 = -2*t84
      t87 = r(3)*t47*thd(3)
      t88 = -2*t87
      t89 = -2*t65
      t91 = r(4)*t53*thd(4)
      t92 = -2*t91
      t94 = r(6)*t41*thd(6)
      t97 = (t63+t85+t88+t89+t92-t94)**2
      t100 = r(3)*cos(th(3))*thd(3)
      t101 = 2*t100
      t104 = r(4)*cos(th(4))*thd(4)
      t105 = 2*t104
      t106 = 2*t75
      t109 = r(5)*cos(th(5))*thd(5)
      t110 = 2*t109
      t113 = r(6)*cos(th(6))*thd(6)
      t115 = (t72+t101+t105+t106+t110+t113)**2
      t119 = r(1)**2
      t120 = t38**2
      t123 = t69**2
      t133 = (t63+t89-t87)**2
      t135 = (t72+t106+t100)**2
      t144 = (t88+t63+t89-t91)**2
      t146 = (t101+t72+t106+t104)**2
      t155 = (t63+t88+t89+t92-t84)**2
      t157 = (t101+t105+t72+t106+t109)**2
      t178 = sin(th(10))
      t184 = r(7)*t32*thd(7)
      t185 = -2*t184
      t187 = r(9)*t56*thd(9)
      t190 = r(8)*t35*thd(8)
      t191 = -2*t190
      t192 = -2*t94
      t197 = (t185-2*t187+t191+t63+t192+t85+t88+t89+t92-r(10)*t178*thd(1
     +0))**2
      t200 = r(7)*cos(th(7))*thd(7)
      t201 = 2*t200
      t204 = r(9)*cos(th(9))*thd(9)
      t208 = r(8)*cos(th(8))*thd(8)
      t209 = 2*t208
      t210 = 2*t113
      t215 = (t201+2*t204+t209+t72+t210+t101+t105+t106+t110+r(10)*cos(th
     +(10))*thd(10))**2
      t221 = (t63+t192+t85+t88+t89+t92-t184)**2
      t223 = (t72+t210+t101+t105+t106+t110+t200)**2
      t229 = (t185+t191+t63+t192+t85+t88+t89+t92-t187)**2
      t231 = (t201+t209+t72+t210+t101+t105+t106+t110+t204)**2
      t237 = (t185+t63+t192+t85+t88+t89+t92-t190)**2
      t239 = (t201+t72+t210+t101+t105+t106+t110+t208)**2
         et(1,1) = J(4)*t10/2+J(3)*t7/2+J(6)*t16/2+J(5)*t13/2+J(8)*t23/2
     ++J(7)*t19/2+J(9)*t26/2+J(10)*t29/2+m(10)*g*(t34+2*t57+t37+t40+t43+
     +t46+t49+t52+t55+r(10)*t178)+m(8)*(t237+t239)/2+m(8)*g*(t34+t40+t43
     ++t46+t49+t52+t55+t36)+m(7)*g*(t40+t43+t46+t49+t52+t55+t33)+m(2)*(t
     +68+t77)/2+m(6)*(t97+t115)/2+m(1)*(t119*t120*t1+t119*t123*t1)/2+m(3
     +)*(t133+t135)/2+m(4)*(t144+t146)/2+m(5)*(t155+t157)/2+m(4)*g*(t49+
     +t40+t52+t54)+m(7)*(t221+t223)/2+m(10)*(t197+t215)/2+m(9)*(t229+t23
     +1)/2+J(2)*t4/2+m(1)*g*t39+J(1)*t1/2+m(5)*g*(t40+t49+t52+t55+t45)+m
     +(3)*g*(t40+t52+t48)+m(2)*g*(t40+t51)+m(9)*g*(t34+t37+t40+t43+t46+t
     +49+t52+t55+t57)+m(6)*g*(t40+t46+t49+t52+t55+t42)
        e = et(1,1)
        return
      end
