clear;lines(0);
x=0:0.2:2*%pi;
x1=[sin(x);100*sin(x)];
y1=[cos(x);100*cos(x)];
y1=y1+20*ones(y1);
// No clip 
plot2d([-100,500],[-100,600],[-1,-1],"022")
xsegs(10*x1+200*ones(x1),10*y1+200*ones(y1))
// rectangle clipping zone 
xbasc(); plot2d([-100,500],[-100,600],[-1,-1],"022")
xrect(150,460,100,150)
xclip(150,460,100,150)
xsegs(10*x1+200*ones(x1),10*y1+200*ones(y1))
// usual rectangle boundaries clipping zone 
xbasc(); plot2d([-100,500],[-100,600],[-1,-1],"022")
xclip("clipgrf")
xsegs(10*x1+200*ones(x1),10*y1+200*ones(y1));
// clipping of
xclip()
