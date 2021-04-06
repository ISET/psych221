%% Quarter wave plate

% Oscillating wave representing polarization in the x-direction
t = [0:255]/256;
f = 3;
ordinaryW = sin(2*pi*f*t);

% Oscillating wave representing polarization in the y-direction
extraordinaryW = cos(2*pi*f*t);
plot(t,extraordinaryW);

total = [ordinaryW(:), extraordinaryW(:)];

ieNewGraphWin; axis equal; grid on
for ii=1:numel(t)
    cla;
    l = line([0 total(ii,1)],[0 total(ii,2)],'Color','k'); hold on;
    plot(total(ii,1),0,'bx'); hold on;
    plot(0,total(ii,2),'bo'); hold on;
    set(gca,'xlim',[-1 1],'ylim',[-1 1]);
    pause(0.1); delete(l)
end


