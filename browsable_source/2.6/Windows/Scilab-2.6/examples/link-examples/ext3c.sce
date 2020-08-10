//Copyright INRIA

//Example #3

files=G_make(['/tmp/ext3c.o'],'ext3c.dll');
link(files,'ext3c','C');

a=[1,2,3];b=[4,5,6];n=3;
c=call('ext3c','yes',1,'c',n,2,'i',a,3,'d',b,4,'d','out',[1,3],5,'d');
if norm(c-(sin(a)+cos(b)))> %eps then pause,end
c=call('ext3c','no',1,'c',n,2,'i',a,3,'d',b,4,'d','out',[1,3],5,'d');
if norm(c-(a+b)) > %eps then pause,end
