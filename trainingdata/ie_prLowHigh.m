%% L3:  Transform low to high resolution data using machine learning (e.g., L3)
%
% Choose a high resolution natural scene as a first example. 
% Make a sensor image for a particular lens and sensor
% Render the sensor data
% Double the sensor spatial resolution and render again
% Store the matched sensor data
%
% Possibe approaches
%   Transform each of the low resolution pixels to a 2x2 superpixel
%   Transform each of the 2x2 low resolution super pixels to a 4x4 high
%   resolution super pixel
%   Render these data using an ip object and learn based on the RGB images
%
% Software dependencies
%   ISETCam and RDT
%
% BW, 2018

%%
ieInit;
rdt = RdtClient('isetbio');
fov = 5;

%%  Figure out some scenes on the RDT
% The data in 2009 go out to 950nm
rdt.crp('/resources/scenes/multiband/scien/2008'); % change remote path

% rdt.listRemotePaths
a = rdt.listArtifacts('type','mat','print',true);
%%
data = rdt.readArtifacts(a(1));
scene = sceneFromBasis(data{1});

% Treat the scene as small
scene = sceneSet(scene,'fov',fov);
ieAddObject(scene); sceneWindow;

oi = oiCreate;
oi = oiCompute(oi,scene);
ieAddObject(oi); oiWindow;

%% Create a low (sensorL) and high (sensorH) resolution sensor

sensor = sensorCreate;
sz = sensorGet(sensor,'pixel size');  % Row Col
sensorL = sensorSetSizeToFOV(sensor,fov);

% Make the pixel half the size
sensorH = sensorSet(sensorL,'pixel size same fill factor',sz(1)/2);
sensorH = sensorSetSizeToFOV(sensorH,fov);

%%  Compute the low and high resolution sensor images

sensorH = sensorCompute(sensorH,oi);
sensorL = sensorCompute(sensorL,oi);
ieAddObject(sensorH); sensorWindow;
ieAddObject(sensorL); sensorWindow;

%%  To see what the data look like after image processing

ip = ipCreate;
ipH = ipCompute(ip,sensorH);
ipL = ipCompute(ip,sensorL);
ieAddObject(ipH); ieAddObject(ipL); ipWindow;

