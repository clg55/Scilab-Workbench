// Copyright INRIA
//formal
mode(-1)
if addf('1','1')<>'2' then pause,end
if addf('1','0')<>'1' then pause,end
if addf('0','1')<>'1' then pause,end
if addf('0','0')<>'0' then pause,end
if addf('1','-1')<>'0' then pause,end
if addf('-1','1')<>'0' then pause,end
if addf('-1','0')<>'-1' then pause,end
if addf('0','-1')<>'-1' then pause,end

if addf('1','a')<>'a+1' then pause,end
if addf('a','1')<>'a+1' then pause,end
if addf('a','0')<>'a' then pause,end
if addf('0','a')<>'a' then pause,end
if addf('a','-1')<>'a-1' then pause,end
if addf('-1','a')<>'a-1' then pause,end
if addf('a','b')<>'a+b' then pause,end
if addf('a+b','c')<>'a+b+c' then pause,end
if addf('c','a+b')<>'c+a+b' then pause,end
if addf('a+b','a+b')<>'a+b+a+b' then pause,end
if addf('a+b','a-b')<>'a+a' then pause,end
if addf('2*a+b','a-b')<>'2*a+a' then pause,end

if mulf('1','1')<>'1' then pause,end
if mulf('1','0')<>'0' then pause,end
if mulf('0','1')<>'0' then pause,end
if mulf('0','0')<>'0' then pause,end
if mulf('1','-1')<>'-1' then pause,end
if mulf('-1','1')<>'-1' then pause,end
if mulf('-1','0')<>'0' then pause,end
if mulf('0','-1')<>'0' then pause,end

if mulf('1','a')<>'a' then pause,end
if mulf('a','1')<>'a' then pause,end
if mulf('a','0')<>'0' then pause,end
if mulf('0','a')<>'0' then pause,end
if mulf('a','-1')<>'-a' then pause,end
if mulf('-1','a')<>'-a' then pause,end
if mulf('a','b')<>'a*b' then pause,end
if mulf('a+b','c')<>'(a+b)*c' then pause,end
if mulf('c','a+b')<>'c*(a+b)' then pause,end
if mulf('a+b','a+b')<>'(a+b)*(a+b)' then pause,end
if mulf('2*a+b','a-b')<>'(2*a+b)*(a-b)' then pause,end

