clear;lines(0);
//squared magnitude response of Butterworth filter
h=buttmag(13,300,1:1000);
mag=20*log(h)'/log(10);
plot2d((1:1000)',mag,[2],"011"," ",[0,-180,1000,20])
