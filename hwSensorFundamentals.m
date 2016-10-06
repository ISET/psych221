%% Sensor fundamentals
%
% 1. We learn a great deal about image quality and noise limits by counting
% the (*Poisson*) arrival of photons at each pixel. Because ISET uses
% physical units throughout, we can easily calculate the number of incident
% photons, or stored electrons, at the sensor.
%    
% Show the Poisson distribution and noise characteristics
%
% 2. Impact of pixel size on the sensor resolution; make the nice MTF graph
% that we use all the time
%
% 3. s_sensorSNR ...
%    s_sensorStackedPixels ()
%    
%
% Copyright Imageval Consulting, LLC 2011

%%
ieInit

%% Look at the photon noise in an image

% Make a low intensity scene
uscene  = sceneCreate('uniform equal energy');
uscene  = sceneAdjustLuminance(uscene,10);
uscene  = sceneSet(uscene,'fov',10);
ieAddObject(uscene); sceneWindow;

% Calculate the optical image
oi = oiCreate('diffraction limited');
oi = oiSet(oi,'optics off axis method','skip');
oi = oiCompute(oi,uscene);
% ieAddObject(oi); oiWindow;

% Set up a monochrome sensor to a small field of view
msensor = sensorCreate('monochrome');
msensor = sensorSetSizeToFOV(msensor,5,uscene,oi);
msensor = sensorSet(msensor,'exp time',0.001);

% Measure with no noise
msensor = sensorSet(msensor,'noise flag',-1);  % No noise at all
msensor = sensorCompute(msensor,oi);

% Add noise, but just photon noise
msensor = sensorSet(msensor,'noise flag',1);   % Add only photon noise
msensor = sensorAddNoise(msensor);
% ieAddObject(msensor); sensorWindow('scale',true);

% Plot the histogram of the electron count
e = sensorGet(msensor,'electrons');
r = range(e(:));
nBins = min(r,50);

vcNewGraphWin; 
h = histogram(e(:),nBins);
xlabel('Number of photons');
ylabel('Number of pixels');
mn = double(mean(e(:)));
txt = sprintf('Mean %.1f\nVar %.1f',mn,var(e(:)));
text(mn,max(h.Values)/3,0,txt,'HorizontalAlignment','center','FontSize',20,'Color',[1 1 1])

%% Consider the effect of pixel size on the sensor MTF

% List of parameters we will set
fNumber = 4;
dyeSizeMicrons = 512;            % Microns

clear psSize;
pSize = [2 3 5 9];                % Microns

%% SCENE: Create a slanted bar image.  Make the slope some uneven value
scene = sceneCreate('slantedBar');

% Now we will set the parameters of these various objects.
% First, let's set the scene field of view.
scene = sceneAdjustLuminance(scene,100);    % Candelas/m2
scene = sceneSet(scene,'distance',1);       % meters
scene = sceneSet(scene,'fov',5);            % Field of view in degrees
% ieAddObject(scene); sceneWindow;

%% Create an optical image with some default optics.
oi = oiCreate;
oi = oiSet(oi,'optics fnumber',fNumber);

% Now, compute the optical image from this scene and the current optical
% image properties
oi = oiCompute(scene,oi);
% ieAddObject(oi); oiWindow;

%%  Create a default monochrome image sensor array

sensor = sensorCreate('monochrome');                %Initialize
sensor = sensorSet(sensor,'autoExposure',1);

% We are now ready to set sensor and pixel parameters to produce a variety
% of captured images.  
% Set the rendering properties for the monochrome imager. The default does
% not color convert or color balance, so it is appropriate. 
ip = ipCreate;

% This is how I typically select a region of interest
% [roiLocs,masterRect] = vcROISelect(ip);
% masterRect = [ 199   168   101   167]; 

%% Compute MTF across pixel sizes

mtfData = cell(1,length(pSize));
for ii=1:length(pSize)
    
    % Adjust the pixel size (meters)
    sensor = sensorSet(sensor,'pixel size constant fill factor',[pSize(ii) pSize(ii)]*1e-6);

    %Adjust the sensor row and column size so that the sensor has a constant
    %field of view.
    sensor = sensorSet(sensor,'rows',round(dyeSizeMicrons/pSize(ii)));
    sensor = sensorSet(sensor,'cols',round(dyeSizeMicrons/pSize(ii)));

    sensor = sensorCompute(sensor,oi);
    vcReplaceObject(sensor); 
    % sensorImageWindow;
     
    ip = ipCompute(ip,sensor);
    vcReplaceObject(ip); 
    % ipWindow;
    
    mrect = ISOFindSlantedBar(ip);
       
    barImage = vcGetROIData(ip,mrect,'results');
    c = mrect(3)+1; r = mrect(4)+1;
    barImage = reshape(barImage,r,c,3);
    % figure; 
    % imagesc(barImage(:,:,1)); axis image; colormap(gray); pause;
    
    dx = sensorGet(sensor,'pixel width','mm');
    
    % Run the ISO 12233 code.
    % ISO12233(barImage);
    weight = [];
    mtfData{ii} = ISO12233(barImage, dx, weight, 'none');
    
end

%% Plot all the mtfData

% The mtfData cell array contains all the information plotted in this
% figure.  We graph the results, comparing the different pixel size MTFs. 
vcNewGraphWin;
c = {'r','g','b','c','m','y','k'};
for ii=1:length(mtfData)
    h = plot(mtfData{ii}.freq,mtfData{ii}.mtf,['-',c{ii}]);
    hold on
    newText = sprintf('%.0f um\n',pSize(ii));
    nfreq = mtfData{ii}.nyquistf;
    l = line([nfreq ,nfreq],[0.1,0],'color',c{ii});
    text((nfreq-10),0.12,newText,'color',c{ii});
end

xlabel('lines/mm');
ylabel('Relative amplitude');
title('MTF for different pixel sizes (fixed die size)');
hold off; grid on

%%  Show a visual example of the effect of pixel size

scene = sceneCreate('freq orient',512);
fov = sceneGet(scene,'fov');
oi    = oiCreate('diffraction limited');
oi    = oiCompute(oi,scene);
ip    = ipCreate;

% Let's try it with an RGB sensor this time.
sensor = sensorCreate;

for ii=1:length(pSize)
    
    % Adjust the pixel size (meters)
    sensor = sensorSet(sensor,'pixel size constant fill factor',[pSize(ii) pSize(ii)]*1e-6);
    sensor = sensorSetSizeToFOV(sensor,fov,scene,oi);
    sensor = sensorCompute(sensor,oi);
   
    ip = ipCompute(ip,sensor);
    ip = ipSet(ip,'name',sprintf('pSize %.2f',pSize(ii)));
    ieAddObject(ip); ipWindow;
end




