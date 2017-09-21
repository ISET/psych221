%% Illustrate the hwImageFormation example with ISET windows
%
% For fun, we show how the human optics blurs a thin line and forms an
% image at the back of the eye.  You can see the blurring and then you can
% see the absorptions in the cones.
%

%%
ieInit;

%%  Similar to the parameters in hwImageFormation

% General parameters
viewingDistance = 0.5;    % Meters
nSamples  = 200;          % Number of lines
DegPerDot = 0.005;        % Degrees per dot

% Make a Vernier acuity scene of a line and an offset line
width  = 3;  % In display pixels
offset = 2;
scene = sceneCreate('vernier',nSamples,width,offset,0.6,0.1);

% Set the viewing distance
scene = sceneSet(scene,'distance',viewingDistance);

% Set the field of view
scene = sceneSet(scene,'fov',nSamples*DegPerDot);   % Field of view

% Add the scene to the data base
ieAddObject(scene); sceneWindow;

%% Use the GUI to make some plots

oi = oiCreate('human');
oi = oiCompute(oi,scene);
ieAddObject(oi); oiWindow;

%%
sensor = sensorCreate('human');
sensor = sensorSet(sensor,'exp time',0.05);  % 50 ms absorptions
sensor = sensorCompute(sensor,oi);
ieAddObject(sensor); sensorWindow('scale',true);

%% Make a plot showing the absorptions two (x,y) locations (col, row)

sz = sensorGet(sensor,'size');

uData1 = sensorPlot(sensor,'electrons hline',[1 round((1/3)*sz(1))]);
uData2 = sensorPlot(sensor,'electrons hline',[1 round((2/3)*sz(1))]);

vcNewGraphWin;
plot(uData1.pos{1},uData1.data{1},'ro-',uData2.pos{1},uData2.data{1},'kx-');
grid on; xlabel('Position (um)'); ylabel('Absorptions');


%%