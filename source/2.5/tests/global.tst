//
global a
a=133;
clear a;
if exists('a') then pause,end
global a;
if a<>133 then pause,end

global b
b=10;a=-1
clear a b
global a b
if a<>-1|b<>10 then pause,end
//

clearglobal()
errcatch(228,'continue','nomessage')
a
if ~iserror(228) then pause,end
errclear(228)
errcatch(-1)

global a b c 
a=1;b=2;c=3;
clearglobal b
errcatch(228,'continue','nomessage')
b
if ~iserror(228) then pause,end
errclear(228)
errcatch(-1)
if a<>1|c<>3 then pause,end

clearglobal c
errcatch(228,'continue','nomessage')
c
if ~iserror(228) then pause,end
errclear(228)
errcatch(-1)
if a<>1 then pause,end

clearglobal a
errcatch(228,'continue','nomessage')
a
if ~iserror(228) then pause,end
errclear(228)
errcatch(-1)


clearglobal()


//
global a
a=133;
//insertion
a(2,2)=10;
if or(a<>[133 0;0 10]) then pause,end
clear a;
global a;
if or(a<>[133 0;0 10]) then pause,end

clear a;
global a;
if a(1,1)<>133  then pause,end

// global between the base workspace and the function workspace

deff('foo()','global a;if a<>133 then pause,end,a=10')
a=133;
foo();
if a<>10 then pause,end

// skipping a level
deff('y=foo()','y=f1()')
deff('y=f1(x)','global a,y=a^2')

a=5;
if foo()<>a^2 then pause,end

// a global variable used as an argument
deff('y=foo()','global a;a=143;y=f1(a)')
deff('y=f1(x)','a=1;y=x^2')
if foo()<>143^2|a<>143 then pause,end


//dealing with insertion and extraction
deff('foo()','global a;a=[];for k=1:5,a(1,k)=k;end')
foo();
if or(a<>(1:5)) then pause,end

deff('y=foo()','global a;y=a(1:2:$)')
if or(foo()<>(1:2:5)) then pause,end

if ~isglobal(a) then pause,end
clearglobal a
a=1
if isglobal(a) then pause,end
if isglobal(1) then pause,end

clearglobal()

gsz=gstacksize();

global a b c
n=int(sqrt(gsz(1)))-3;
b=ones(n,n);
deff('foo()','global b;for k=1:5,b=[b ones(n,10)];end')
foo()
if or(size(b)<>[n,n+50]) then pause,end
if find(b<>1)<>[] then pause,end
