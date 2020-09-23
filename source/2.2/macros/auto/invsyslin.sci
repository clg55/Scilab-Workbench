function it=invsyslin(t)

//-compat type(t)<>15 retained for list/tlist compatibility
if type(t)<>15&type(t)<>16 then error(91,1),end
if t(1) <> 'lss' then error(91,1),end;
[p,m]=size(t(5));
if p <> m then  warning('non square D matrix'),end
//
d=pinv(t(5));
a=t(2)-t(3)*d*t(4);
b=t(3)*d;
c=-d*t(4);
it=tlist('lss',a,b,c,d,t(6),t(7));



