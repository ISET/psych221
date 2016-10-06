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

%%  Standard initialization
ieInit

%% Measure the variation in sensor electrons (shot noise)

% We start with a low intensity uniform scene with equal energy at every
% wavelength.  10 cd/m2 is pretty dark.  But you can experiment by changing
% the
uscene  = sceneCreate('uniform equal energy');
candelas = 10;                         % Units are cd/m^2
uscene  = sceneAdjustLuminance(uscene,candelas);   
uscene  = sceneSet(uscene,'fov',10);
% ieAddObject(uscene); sceneWindow;

% Calculate the optical image for a diffraction limited optics
oi = oiCreate('diffraction limited');
oi = oiSet(oi,'optics off axis method','skip');   % No relative illumination
oi = oiCompute(oi,uscene);
% ieAddObject(oi); oiWindow;

% Set up a monochrome sensor with a field of view that is smaller than the
% scene
msensor = sensorCreate('monochrome');
msensor = sensorSetSizeToFOV(msensor,5,uscene,oi);

% A short (1ms) exposure duration.  You can experiment with this.
msensor = sensorSet(msensor,'exp time',0.001);    % Units are sec

% Measure with no noise or quantization or clipping
msensor = sensorSet(msensor,'noise flag',-1);  % No noise or quantization
msensor = sensorCompute(msensor,oi);

% Add photon noise.  Normally this happens within sensorCompute, but we are
% specially controlling the processing in this tutorial.
msensor = sensorSet(msensor,'noise flag',1);   % Add only photon noise
msensor = sensorAddNoise(msensor);
% ieAddObject(msensor); sensorWindow('scale',true);

% Plot a histogram of the electron count across the pixels.  Given that the
% scene is uniform, and how we have controlled the noise, this produces the
% shot noise distribution (variation in electrons due to photon noise)
e = sensorGet(msensor,'electrons');
r = range(e(:));
nBins = min(r,50);  % Nice plot

vcNewGraphWin; 
h = histogram(e(:),nBins);
xlabel('Number of photons');
ylabel('Number of pixels');
mn = double(mean(e(:)));
txt = sprintf('Mean %.1f\nVar %.1f',mn,var(e(:)));
text(mn,max(h.Values)/3,0,txt,'HorizontalAlignment','center','FontSize',20,'Color',[1 1 1])

%% Experiments with spatial resolution 

%  We consider the effect of pixel size on the sensor MTF

ieInit

%% List of parameters 

dyeSizeMicrons = 512;            % Microns
clear psSize;                    % Pixel size (width)
pSize = [2 3 5 8];               % Microns

% The slanted bar scene is often used to assess spatial resolution.  We can
% compute the modulation transfer function (MTF) from the sensor and image
% processing response to the slanted bar.
scene = sceneCreate('slanted bar', 512);

% Now we will set the parameters of these various objects.
% First, let's set the scene field of view.
scene = sceneAdjustLuminance(scene,10);    % Candelas/m2
scene = sceneSet(scene,'distance',1);       % meters
scene = sceneSet(scene,'fov',5);            % Field of view in degrees
% ieAddObject(scene); sceneWindow;

%% Create an optical image with some default optics.
oi = oiCreate('diffraction limited');
fNumber = 4;
oi = oiSet(oi,'optics fnumber',fNumber);

% Now, compute the optical image from this scene and the current optical
% image properties
oi = oiCompute(scene,oi);
% ieAddObject(oi); oiWindow;

%%  Create a monochrome image sensor array

sensor = sensorCreate('monochrome');                %Initialize
sensor = sensorSet(sensor,'autoExposure',1);

% We are now ready to set sensor and pixel parameters to produce a variety
% of captured images.  
% Set the rendering properties for the monochrome imager. The default does
% not color convert or color balance, so it is appropriate. 
ip = ipCreate;

%% Compute the MTF as we change the pixel size

% Loop over different pixel sizes
mtfData = cell(1,length(pSize));
for ii=1:length(pSize)
    fprintf('Pixel size %.1f ',pSize(ii));
    % Adjust the pixel size (meters)
    sensor = sensorSet(sensor,'pixel size constant fill factor',[pSize(ii) pSize(ii)]*1e-6);

    %Adjust the sensor row and column size so that the sensor has a constant
    %field of view.
    sensor = sensorSetSizeToFOV(sensor,5,scene,oi);   
    sensor = sensorCompute(sensor,oi);
     
    ip = ipCompute(ip,sensor);
    mrect = ISOFindSlantedBar(ip);  % This is an option
    % ieAddObject(ip); ipWindow;
    % ieDrawShape(ip,'rectangle',mrect);
    
    barImage = vcGetROIData(ip,mrect,'results');
    c = mrect(3)+1; r = mrect(4)+1;
    barImage = reshape(barImage,r,c,3);
    % figure; imagesc(barImage(:,:,1)); axis image; colormap(gray);
    
    dx = sensorGet(sensor,'pixel width','mm');
    
    % Run the ISO 12233 code.
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
fov   = sceneGet(scene,'fov');
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

%% Homework questions
%
%  * In the first part of this homework, try increasing or decreasing the
%  exposure time or uniform scene intensity, and plot the histogram showing
%  the electron count distribution.  What is the relationship between the
%  mean number of electrons and the variance of the number of electrons?
%  Why?  
%
%  * What would happen to the photon count calculations if we specified the
%  original scene as having a different spectral radiance distribution, say
%  D65 or equal photon rates across wavelength?  Do we expect a different
%  mean number of electrons? What about the relationship between the mean
%  and the variance?
%
%  * In the second part of the homework recalculate the MTFs using
%  diffraction limited optics with, say, an fNumber of 12.  What happens to
%  the different curves?
%
%  * Putting together the first and second parts of the homework, do you
%  think that you will get the exact same curve when you repeat the MTF
%  simulation?
%
%  * Bonus: In the second part of this homework, on spatial resolution, the
%  colored and labeled tickmarks show the Nyquist frequency for line-paris
%  per millimeter.  Why would a two micron pixel have a Nyquist frequency
%  of 250 line pairs per millimeter?
%
%%  


