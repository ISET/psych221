%% Quarter wave plate
%
% The ordinary and extraordinary rays are polarized at 90 deg
% difference, so that one oscillates in the x- and the other in the
% y-direction.
%
% The quarter wave plot material has different index of refraction
% (speed of light) for the two rays.  If we cut the thickness of the
% plate correctly, then one is in sine and the other in cosine phase.
%
% This figure shows the two rays oscillating as the red markers.  The
% sum of the two is shown as the black line.
%
% The amplitude is constant.  The direction changes around in a circle
% over time, causing the circular polarization.

%% Set up the two waves

% Oscillating wave representing polarization in the x-direction
t = (0:255)/256;
f = 3;
ordinaryW = sin(2*pi*f*t);
% plot(t,ordinaryW);

% Oscillating wave representing polarization in the y-direction
extraordinaryW = cos(2*pi*f*t);
% plot(t,extraordinaryW);

total = [ordinaryW(:), extraordinaryW(:)];

%%  Make the movie.  Grab it with Apple screen shot
ieNewGraphWin; axis equal; grid on;
xlabel('X-axis'); ylabel('Y-axis');
for ii=1:numel(t)
    cla;   
    l = line([0 total(ii,1)],[0 total(ii,2)],'Color','k','LineWidth',2); hold on;
    plot(total(ii,1),0,'rx','MarkerSize',14); hold on;
    plot(0,total(ii,2),'ro','MarkerSize',14); hold on;
    set(gca,'xlim',[-1 1],'ylim',[-1 1]);
    pause(0.05); delete(l);
end

%% END

