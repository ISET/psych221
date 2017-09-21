%% Image irradiance calculations illustrating linespread
% Shows the creation of a scene and the calculation of the irradiance image 
% (optics)
% 
% Wandell, Stanford, 2017

ieInit;
%% Set parameters like those in hwImageFormation
%%
viewingDistance = 0.5;    % Meters
nSamples  = 200;          % Number of lines
DegPerDot = 0.005;        % Degrees per dot (3600*DegPerDot is in arcsec)

% Make a Vernier acuity scene of a line and an offset line
width  = 3;  % In display pixels
offset = 1;  % Also in display pixels
scene = sceneCreate('vernier',nSamples,width,offset,0.6,0.1);

% Set the viewing distance
scene = sceneSet(scene,'distance',viewingDistance);

% Set the field of view
scene = sceneSet(scene,'fov',nSamples*DegPerDot);   % Field of view

% Add the scene to the data base
ieAddObject(scene); sceneWindow;
%% Create the irradiance image
%%
oi = oiCreate('human');
oi = oiCompute(oi,scene);

% Notice the chromatic aberration!
ieAddObject(oi); oiWindow;
%% Create a human sensor
%%
sensor = sensorCreate('human');
sensor = sensorSet(sensor,'exp time',0.05);  % 50 ms absorptions
sensor = sensorCompute(sensor,oi);
ieAddObject(sensor); sensorWindow('scale',true);
%% Calculate the L-cone absorptions across a top and bottom line
%%
sz = sensorGet(sensor,'size');

% Retrieve the plotting data, but do not show the figure.
uData1 = sensorPlot(sensor,'electrons hline',[1 round((1/3)*sz(1))],'no fig');
uData2 = sensorPlot(sensor,'electrons hline',[1 round((2/3)*sz(1))],'no fig');

% Compare the top line and the bottom line
vcNewGraphWin;
plot(uData1.pos{1},uData1.data{1},'ro-',uData2.pos{1},uData2.data{1},'kx-');
grid on; xlabel('Position (um)'); ylabel('Absorptions');
legend({'Top line','Bottom line'});
title('Line of L-cone absorptions');