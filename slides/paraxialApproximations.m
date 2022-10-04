%% Paraxial approximations

x = [-pi:0.1:pi];
ieNewGraphWin;
plot(x,sin(x));
hold on;
plot(x,x,'k--');
grid on;

ieNewGraphWin;
plot(x,cos(x));
hold on; plot(x,ones(size(x)),'k--');

ieNewGraphWin;
plot(x,tan(x),'')
hold on; plot(x,x,'k--');

